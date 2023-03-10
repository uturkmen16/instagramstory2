

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramstory2/storycontent.dart';
import 'package:video_player/video_player.dart';

import 'appscreen.dart';

class VideoStory extends StatelessWidget implements StoryContent{

  late final VideoStoryController videoStoryController;

  VideoStory(String contentUrl, Function onContentFinished, String tag) : videoStoryController = Get.put(VideoStoryController(contentUrl: contentUrl, onContentFinished: onContentFinished), tag: tag);

  @override
  Widget build(BuildContext context) {
    //After the widget is inserted call play video
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('POSTFRAMECALLBACK');
      videoStoryController.isInsertedToTree = true;
      print('POSTFRAMECALLBACK2');
      videoStoryController.start();
      print('POSTFRAMECALLBACK3');

    });
    return
      Obx( () {
        return videoStoryController.isInitialized.value ?
          //If video is initialized show video
          Center(
            child:
              AspectRatio(
                aspectRatio: videoStoryController.videoPlayerController.value
                    .value.aspectRatio,
                child: VideoPlayer(
                    videoStoryController.videoPlayerController.value),
              ),
          )
        :
        //If video is not initialized show buffering
          const Center(
            child: CircularProgressIndicator(),
          );
        }
      );
  }

  @override
  StoryController getStoryController() => videoStoryController;

}

class VideoStoryController extends StoryController {

  @override
  String contentUrl;
  @override
  Function onContentFinished;
  @override
  bool isStopped = false;
  bool isInsertedToTree = false;

  Rx<Duration> elapsedTime = Rx<Duration>(Duration.zero);
  Rx<Duration> contentLength = Rx<Duration>(Duration.zero);

  RxBool isInitialized = false.obs;
  RxBool isCallbackSent = false.obs;

  late Rx<VideoPlayerController> videoPlayerController;

  VideoStoryController({required this.contentUrl, required this.onContentFinished});

  @override
  void onInit() {
    print("ONINIT");
    print(contentUrl);
    isInsertedToTree = false;
    videoPlayerController = Rx<VideoPlayerController>(VideoPlayerController.network(contentUrl));
    super.onInit();
  }

  @override
  void start() {
    isCallbackSent.value = false;
    videoPlayerController.value.addListener(videoListener);
    print('Start1');
    videoPlayerController.value.initialize().then((_) {
      print(contentUrl);
      print("video init");
      videoPlayerController.value.play();
      contentLength.value = videoPlayerController.value.value.duration;
      isInitialized.value = true;
      if(Get.find<AppScreenController>().isPressedDown.value) pause();
      if(contentLength.value.inMilliseconds <= 0) {
        print('CANT OPEN VIDEO');
        stop();
      }
      update();
    });
  }

  @override
  void reset() {
    isCallbackSent.value = false;
    isInsertedToTree = false;
  }

  @override
  void stop() {
    print('VIDEO STOPPED');
    isStopped = true;
    videoPlayerController.value.pause();
    videoPlayerController.value.removeListener(videoListener);
    isInsertedToTree = false;
    onContentFinished();
    update();
  }

  @override
  void pause() {
    videoPlayerController.value.pause();
  }

  @override
  void play() {
    videoPlayerController.value.play();
  }

  videoListener() {
    elapsedTime.value = videoPlayerController.value.value.position;
    if(videoPlayerController.value.value.position >= videoPlayerController.value.value.duration && videoPlayerController.value.value.position.inMilliseconds != 0 && !isCallbackSent.value) {
      //video has finished
      isCallbackSent.value = true;
      stop();
    }
    update();
  }

  @override
  void dispose(){
    bool isInsertedToTree = false;
    elapsedTime.close();
    contentLength.close();
    videoPlayerController.value.removeListener(videoListener);
    super.dispose();
  }

  @override
  Rx<Duration> getElapsedTime() => elapsedTime;

  @override
  Rx<Duration> getContentLength() => contentLength;



}