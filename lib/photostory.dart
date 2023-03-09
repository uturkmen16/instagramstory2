

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:instagramstory2/appscreen.dart';
import 'package:instagramstory2/storycontent.dart';

class PhotoStory extends StatelessWidget implements StoryContent{

  late final PhotoStoryController photoStoryController;

  PhotoStory(String contentUrl, Function onContentFinished, String tag) : photoStoryController = Get.put(PhotoStoryController(contentUrl: contentUrl, onContentFinished: onContentFinished),tag: tag);

  @override
  Widget build(BuildContext context) {

    //After the widget is inserted call play video
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(!photoStoryController.isInsertedToTree) {
        //First time
        photoStoryController.isInsertedToTree = true;
        photoStoryController.start();
        if(Get.find<AppScreenController>().isPressedDown.value) photoStoryController.pause();
        photoStoryController.update();
        print("-----------------");
      }
    });

    return Image.network(photoStoryController.contentUrl);
  }

  @override
  StoryController getStoryController() => photoStoryController;

}

class PhotoStoryController extends StoryController {

  @override
  String contentUrl;
  @override
  Function onContentFinished;
  @override
  bool isStopped = false;
  RxBool isCallbackSent = false.obs;
  bool isInsertedToTree = false;
  bool isTimerActive = false;

  Rx<Duration> elapsedTime = Rx<Duration>(Duration.zero);
  Rx<Duration> contentLength = Rx<Duration>(const Duration(milliseconds: PHOTO_DURATION_MS)); //Initialize this to 5seconds

  late Timer _timer;

  PhotoStoryController({required this.contentUrl, required this.onContentFinished});
  @override
  void onInit() {
    super.onInit();
    elapsedTime.value = Duration.zero;
    contentLength.value = const Duration(milliseconds: PHOTO_DURATION_MS); //Initialize this to 5seconds
  }

  @override
  Rx<Duration> getElapsedTime() => elapsedTime;

  @override
  Rx<Duration> getContentLength() => contentLength;


  void _updateTimer(Timer timer) {
    elapsedTime.value += const Duration(milliseconds: 10);
    if (elapsedTime.value >= const Duration(milliseconds: PHOTO_DURATION_MS) && elapsedTime.value.inMilliseconds != 0 && !isCallbackSent.value) {
      stop();
    }
    update();
  }

  @override
  void start() {
    elapsedTime.value = Duration.zero;
    contentLength.value = Duration(milliseconds: PHOTO_DURATION_MS);
    if(!isTimerActive) _timer = Timer.periodic(const Duration(milliseconds: 10), _updateTimer);
    isTimerActive = true;
    update();
  }

  @override
  void reset() {
    if(isTimerActive) _timer.cancel();
    isTimerActive = false;
    isInsertedToTree = false;
    isCallbackSent.value = false;
    update();
  }

  @override
  void stop() {
    if(isTimerActive) _timer.cancel();
    isTimerActive = false;
    isInsertedToTree = false;
    isCallbackSent.value = true;
    // Callback function to change this story to the next one
    print('calling back');
    onContentFinished();
    update();
  }

  @override
  void pause() {
    if(isTimerActive) _timer.cancel();
    isTimerActive = false;
    update();
  }

  @override
  void play() {
    print('played');
    if(!isTimerActive) _timer = Timer.periodic(const Duration(milliseconds: 10), _updateTimer);
    isTimerActive = true;
    update();
  }

  @override
  void dispose(){
    isInsertedToTree = false;
    //elapsedTime.close();
    //contentLength.close();
    if(isTimerActive) _timer.cancel();
    super.dispose();
  }

  static const int PHOTO_DURATION_MS = 5000;


}