

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramstory2/story.dart';
import 'package:video_player/video_player.dart';

class VideoStory extends StoryContent{

  late final VideoStoryController videoStoryController;

  VideoStory(String contentUrl, Function onContentFinished) {
    videoStoryController = Get.put(VideoStoryController(contentUrl: contentUrl, onContentFinished: onContentFinished));
  }

  @override
  Widget build(BuildContext context) {
    return
      Obx( () {
        return videoStoryController.isInitialized.value ?
          //If video is initialized show video
          Column(
            children: [
              AspectRatio(
                aspectRatio: videoStoryController.videoPlayerController.value
                    .value.aspectRatio,
                child: VideoPlayer(
                    videoStoryController.videoPlayerController.value),
              ),
              //Text(videoStoryController.elapsedTime.value.toString()),
            ]
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

class VideoStoryController extends GetxController implements StoryController {

  @override
  String contentUrl;
  @override
  Function onContentFinished;
  @override
  Rx<Duration> elapsedTime = Rx<Duration>(Duration.zero);
  @override
  Rx<Duration> contentLength = Rx<Duration>(Duration.zero);
  @override
  RxBool isStopped = false.obs;

  RxBool isInitialized = false.obs;
  RxBool isCallbackSent = false.obs;

  late Rx<VideoPlayerController> videoPlayerController;

  VideoStoryController({required this.contentUrl, required this.onContentFinished});

  @override
  void onInit() {
    videoPlayerController = Rx<VideoPlayerController>(VideoPlayerController.network(contentUrl, videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true)));
    super.onInit();
  }

  @override
  void start() {
    isCallbackSent.value = false;
    videoPlayerController.value.addListener(videoListener);
    videoPlayerController.value.initialize().then((_) {
      contentLength.value = videoPlayerController.value.value.duration;
      isInitialized.value = true;
      update();
    });
    videoPlayerController.value.play();
  }

  @override
  void stop() {
    isStopped.value = true;
    videoPlayerController.value.pause();
    videoPlayerController.value.removeListener(videoListener);
    onContentFinished();
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
    elapsedTime.close();
    contentLength.close();
    videoPlayerController.value.removeListener(videoListener);
    videoPlayerController.value.dispose();
    super.dispose();
  }

  @override
  void onReady() {
    //Video needs to be displayed so we start the video
    start();
    super.onReady();
  }
}