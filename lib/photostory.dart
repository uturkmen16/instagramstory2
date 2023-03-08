

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:instagramstory2/story.dart';

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
      isCallbackSent.value = true;
      timer.cancel(); //Timer is over
      stop();
    }
    update();
  }

  @override
  void start() {
    elapsedTime.value = Duration.zero;
    contentLength.value = Duration(milliseconds: PHOTO_DURATION_MS);
    isCallbackSent.value = false;
    _timer = Timer.periodic(const Duration(milliseconds: 10), _updateTimer);
  }

  @override
  void stop() {
    isStopped = true;
    // Callback function to change this story to the next one
    onContentFinished();
    update();
  }

  @override
  void pause() {
    print('paused');
    print(elapsedTime.value.inMilliseconds);
    print(contentUrl);
    _timer.cancel();
    update();
  }

  @override
  void play() {
    print('played');
    _timer = Timer.periodic(const Duration(milliseconds: 10), _updateTimer);
  }

  @override
  void dispose(){
    isInsertedToTree = false;
    //elapsedTime.close();
    //contentLength.close();
    _timer.cancel();
    super.dispose();
  }

  static const int PHOTO_DURATION_MS = 5000;

}