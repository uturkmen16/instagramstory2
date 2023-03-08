

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramstory2/photostory.dart';
import 'package:instagramstory2/story.dart';
import 'package:instagramstory2/videostory.dart';

class StoryGroup extends StatelessWidget{

  late StoryGroupController storyGroupController;
  int screenPosition;

  StoryGroup({required List<String> stories, userName, required this.screenPosition}) : storyGroupController = Get.put(StoryGroupController(stories: stories, userName: userName));

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      return GestureDetector(
        child: Scaffold(
            body:Transform(
              alignment: Alignment.center,
              transform:
              Matrix4.identity()
                ..scale((1.2 - ((storyGroupController.horizontalDragStart.value.dx - storyGroupController.horizontalDrag.value.dx + (3 * screenPosition * MediaQuery.of(context).size.width) / 4 ) / (MediaQuery.of(context).size.width * 2)).abs()) / 1.2)
                ..translate(-(storyGroupController.horizontalDragStart.value.dx - storyGroupController.horizontalDrag.value.dx + (3 * screenPosition * MediaQuery.of(context).size.width) / 4))
                ..setEntry(3, 2, 0.001)
                ..rotateY(pi * ((storyGroupController.horizontalDragStart.value.dx - storyGroupController.horizontalDrag.value.dx + (3 * screenPosition * MediaQuery.of(context).size.width) / 4) / (MediaQuery.of(context).size.width * 1.8))),
              child: Stack(children: [
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
            )
        ),
        onTapDown: (TapDownDetails details) {
          print("tapped");
        },
        onHorizontalDragStart: (DragStartDetails details) {
          storyGroupController.storyContents[storyGroupController.currentStoryIndex.value].getStoryController().pause();
          storyGroupController.horizontalDragStart.value = details.globalPosition;
        },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          storyGroupController.horizontalDrag.value = details.globalPosition;
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          if(!storyGroupController.storyContents[storyGroupController.currentStoryIndex.value].getStoryController().isStopped) storyGroupController.storyContents[storyGroupController.currentStoryIndex.value].getStoryController().play();
          storyGroupController.horizontalDrag.value = Offset.zero;
          storyGroupController.horizontalDragStart.value = Offset.zero;
        },
      );
    });
  }

  static const int LEFT = 1;
  static const int CENTER = 0;
  static const int RIGHT = -1;

}

class StoryGroupController extends GetxController {
  //This can probably be done by one list instead of two.
  List<String> stories;
  List<StoryContent> storyContents = [];
  RxInt currentStoryIndex = 0.obs;
  String userName;
  Rx<Offset> horizontalDragStart = Offset.zero.obs;
  Rx<Offset> horizontalDrag = Offset.zero.obs;

  StoryGroupController({required this.stories, required this.userName});

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
      currentStoryIndex.value++;
      print("hehehe");
      print(currentStoryIndex.value);
      print(storyContents.elementAt(currentStoryIndex.value).getStoryController().getElapsedTime().value);
      print(storyContents.elementAt(currentStoryIndex.value).getStoryController().getContentLength().value);
      print('callback');
    }
    else {
      //GO TO NEXT STORY GROUP
    }
  }
}