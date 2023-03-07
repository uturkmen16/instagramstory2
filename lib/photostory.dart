

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:instagramstory2/story.dart';

class PhotoStory extends StoryContent {

  @override
  late final PhotoStoryController photoStoryController;

  PhotoStory(String contentUrl, Function onContentFinished) {
    photoStoryController = Get.put(PhotoStoryController(contentUrl: contentUrl, onContentFinished: onContentFinished));
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(photoStoryController.contentUrl);
  }

  @override
  StoryController getStoryController() => photoStoryController;

}

class PhotoStoryController extends GetxController implements StoryController {

  @override
  String contentUrl;
  @override
  Function onContentFinished;
  @override
  Rx<Duration> elapsedTime = Rx<Duration>(Duration.zero);
  @override
  Rx<Duration> contentLength = Rx<Duration>(const Duration(milliseconds: PHOTO_DURATION_MS)); //Initialize this to 5seconds
  @override
  RxBool isStopped = false.obs;

  PhotoStoryController({required this.contentUrl, required this.onContentFinished});


  late Timer _timer;

  @override
  void start() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), _updateTimer);
  }

  void _updateTimer(Timer timer) {
    elapsedTime.value += const Duration(milliseconds: 10);
    if (elapsedTime.value >= const Duration(milliseconds: PHOTO_DURATION_MS)) {
      _timer.cancel(); //Timer is over
      stop();
    }
    update();
  }

  @override
  void stop() {
    isStopped.value = true;
    elapsedTime.value = const Duration(milliseconds: PHOTO_DURATION_MS);
    // Callback function to change this story to the next one
    onContentFinished();
    //update();
  }

  @override
  void pause() {
    _timer.cancel();
  }

  @override
  void play() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), _updateTimer);
  }

  @override
  void dispose(){
    elapsedTime.close();
    contentLength.close();
    _timer.cancel();
    super.dispose();
  }

  @override
  void onReady() {
    //Image needs to be displayed so we start the timer
    start();
    super.onReady();
  }
  static const int PHOTO_DURATION_MS = 5000;

}