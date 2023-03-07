

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramstory2/photostory.dart';
import 'package:instagramstory2/story.dart';
import 'package:instagramstory2/videostory.dart';

class StoryGroup extends StatelessWidget{

  late StoryGroupController storyGroupController;

  StoryGroup({required List<String> stories}){
    storyGroupController = Get.put(StoryGroupController(stories: stories));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        child: Scaffold(
            body:Transform(
              alignment: Alignment.center,
              transform:
              Matrix4.identity()
                ..scale((1.2 - ((storyGroupController.horizontalDragStart.value.dx - storyGroupController.horizontalDrag.value.dx) / (MediaQuery.of(context).size.width * 2)).abs()) / 1.2)
                ..translate(-(storyGroupController.horizontalDragStart.value.dx - storyGroupController.horizontalDrag.value.dx))
                ..setEntry(3, 2, 0.001)
                ..rotateY(pi * ((storyGroupController.horizontalDragStart.value.dx - storyGroupController.horizontalDrag.value.dx) / (MediaQuery.of(context).size.width * 1.8))),
              child: Stack(children: [
                storyGroupController.storyContents.elementAt(storyGroupController.currentStoryIndex.value),
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
                            value: index > storyGroupController.currentStoryIndex.value ? 0.0 : (index < storyGroupController.currentStoryIndex.value ? 1.0 : (storyGroupController.storyContents.elementAt(storyGroupController.currentStoryIndex.value).getStoryController().elapsedTime.value.inMilliseconds == 0 ? 0.0 : storyGroupController.storyContents.elementAt(storyGroupController.currentStoryIndex.value).getStoryController().elapsedTime.value.inMilliseconds / storyGroupController.storyContents.elementAt(storyGroupController.currentStoryIndex.value).getStoryController().contentLength.value.inMilliseconds)),
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
          storyGroupController.storyContents.elementAt(storyGroupController.currentStoryIndex.value).getStoryController().pause();
          storyGroupController.horizontalDragStart.value = details.globalPosition;
        },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          storyGroupController.horizontalDrag.value = details.globalPosition;
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          if(!storyGroupController.storyContents.elementAt(storyGroupController.currentStoryIndex.value).getStoryController().isStopped.value) storyGroupController.storyContents.elementAt(storyGroupController.currentStoryIndex.value).getStoryController().play();
          storyGroupController.horizontalDrag.value = Offset.zero;
          storyGroupController.horizontalDragStart.value = Offset.zero;
        },
      );
    });
  }

}

class StoryGroupController extends GetxController {
  //This can probably be done by one list instead of two.
  List<String> stories;
  List<StoryContent> storyContents = [];
  RxInt currentStoryIndex = 0.obs;
  Rx<Offset> horizontalDragStart = Offset.zero.obs;
  Rx<Offset> horizontalDrag = Offset.zero.obs;

  StoryGroupController({required this.stories});

  @override
  void onInit() {
    for (var url in stories) {
      if(url.contains('.mp4') || url.contains('.mov') || url.contains('.mov') || url.contains('.wmv') || url.contains('.flv') || url.contains('.avi')) {
        storyContents.add(VideoStory(url, nextStory));
      }
      else if(url.contains('.jpeg') || url.contains('.jpg') || url.contains('.png') || url.contains('.svg') || url.contains('.gif') || url.contains('.webp')) {
        storyContents.add(PhotoStory(url, nextStory));
      }
      else {
        throw UnsupportedError('Media file type is not supported!');
      }
    }
    super.onInit();
  }

  nextStory() {
    if(currentStoryIndex < storyContents.length - 1){
      currentStoryIndex.value++;
      update();
    }
    else {
      //GO TO NEXT STORY GROUP
    }
  }
}