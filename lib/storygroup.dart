

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramstory2/photostory.dart';
import 'package:instagramstory2/storycontent.dart';
import 'package:instagramstory2/videostory.dart';

class StoryGroup extends StatelessWidget{

  late StoryGroupController storyGroupController;


  StoryGroup({required List<String> stories, required String userName, required Function storyGroupFinished}) : storyGroupController = Get.put(StoryGroupController(stories: stories, userName: userName, storyGroupFinished: storyGroupFinished), tag: userName);

  @override
  Widget build(BuildContext context) {

    return Obx(() {
        return Scaffold(
            body: Stack(children: [
                storyGroupController.storyContents[storyGroupController.currentStoryIndex.value],
                Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        storyGroupController.stories.length,
                            (index) => SizedBox(
                          width: MediaQuery.of(context).size.width / (storyGroupController.stories.length + 1),
                          child: LinearProgressIndicator(
                            backgroundColor: const Color.fromARGB(50, 30, 30, 30),
                            valueColor: const AlwaysStoppedAnimation(Color.fromARGB(150, 240, 240, 240)),
                            minHeight: 4,
                            value: index > storyGroupController.currentStoryIndex.value ? 0.0 : (index < storyGroupController.currentStoryIndex.value ? 1.0 : (storyGroupController.storyContents.elementAt(storyGroupController.currentStoryIndex.value).getStoryController().getElapsedTime().value.inMilliseconds == 0 ? 0.0 : storyGroupController.storyContents.elementAt(storyGroupController.currentStoryIndex.value).getStoryController().getElapsedTime().value.inMilliseconds / storyGroupController.storyContents.elementAt(storyGroupController.currentStoryIndex.value).getStoryController().getContentLength().value.inMilliseconds)),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],),
        );
    });
  }

}

class StoryGroupController extends GetxController {
  //This can probably be done by one list instead of two.
  List<String> stories;
  List<StoryContent> storyContents = [];
  RxInt currentStoryIndex = 0.obs;
  String userName;
  Rx<Offset> horizontalDragStart = Offset.zero.obs;
  Rx<Offset> horizontalDrag = Offset.zero.obs;
  Function storyGroupFinished;

  StoryGroupController({required this.stories, required this.userName, required this.storyGroupFinished});

  @override
  void onInit() {
    for (int i = 0; i < stories.length; i++) {
      String url = stories.elementAt(i);
      if(url.contains('.mp4') || url.contains('.mov') || url.contains('.mov') || url.contains('.wmv') || url.contains('.flv') || url.contains('.avi')) {
        storyContents.add(VideoStory(url, nextStory, userName + i.toString()));
        print("videostory");
      }
      else if(url.contains('.jpeg') || url.contains('.jpg') || url.contains('.png') || url.contains('.svg') || url.contains('.gif') || url.contains('.webp')) {
        storyContents.add(PhotoStory(url, nextStory, userName + i.toString()));
        print("photostory");
      }
      else {
        throw UnsupportedError('Media file type is not supported!');
      }
    }
    super.onInit();
  }

  nextStory() {
    if(currentStoryIndex.value < storyContents.length - 1) {
      //There are more stories to show
      storyContents[currentStoryIndex.value].getStoryController().reset();
      currentStoryIndex.value++;
      storyContents[currentStoryIndex.value].getStoryController().play();
      //print("hehehe");
      print(currentStoryIndex.value);
    }
    else {
      //No more stories here make callback
      storyContents[currentStoryIndex.value].getStoryController().reset();
      print('makin callback');
      storyGroupFinished();
    }
  }

  previousStory() {
    if(currentStoryIndex.value > 0) {
      storyContents[currentStoryIndex.value].getStoryController().reset();
      currentStoryIndex--;
    }
    storyContents[currentStoryIndex.value].getStoryController().reset();
    storyContents[currentStoryIndex.value].getStoryController().play();
    update();
  }

  resetCurrentStory() {
    storyContents[currentStoryIndex.value].getStoryController().reset();
  }
  pauseCurrentStory() {
    storyContents[currentStoryIndex.value].getStoryController().pause();
  }
  playCurrentStory() {
    storyContents[currentStoryIndex.value].getStoryController().play();
  }
}