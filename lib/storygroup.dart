

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramstory2/appscreen.dart';
import 'package:instagramstory2/photostory.dart';
import 'package:instagramstory2/storycontent.dart';
import 'package:instagramstory2/videostory.dart';
import 'package:like_button/like_button.dart';

class StoryGroup extends StatelessWidget{

  late StoryGroupController storyGroupController;
  


  StoryGroup({required List<String> stories, required String userName, required Function storyGroupFinished, required String profilePictureUrl}) : storyGroupController = Get.put(StoryGroupController(stories: stories, userName: userName, storyGroupFinished: storyGroupFinished, profilePictureUrl: profilePictureUrl), tag: userName);

  @override
  Widget build(BuildContext context) {

    return Obx(() {
        return Scaffold(
            body: Stack(children: [
                Center(child: storyGroupController.storyContents[storyGroupController.currentStoryIndex.value]),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
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
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 20),
                          CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(storyGroupController.profilePictureUrl),
                          ),
                          const SizedBox(width: 10),
                          Text(storyGroupController.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 7 / 10,
                              height: 35,
                              child: TextField(
                                textAlign: TextAlign.start,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    filled: true,
                                    hintStyle: TextStyle(color: Colors.grey[800]),
                                    hintText: "Send Message",
                                    fillColor: Colors.white),
                              ),
                            ),
                            const LikeButton(
                              size: 30,
                              bubblesSize: 20,
                              circleColor:
                                CircleColor(start: Color(0xff000000),  end: Color(0xffff0000)),
                              bubblesColor: BubblesColor(
                                dotPrimaryColor: Color(0xff000000),
                                dotSecondaryColor: Color(0xffff0000),
                              ),
                            ),
                            const Icon(
                              Icons.send,
                              size: 30,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                      ],
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
  Function storyGroupFinished;
  String profilePictureUrl;

  StoryGroupController({required this.stories, required this.userName, required this.storyGroupFinished, required this.profilePictureUrl});

  @override
  void onInit() {
    for (int i = 0; i < stories.length; i++) {
      String url = stories.elementAt(i);
      if(url.contains('.mp4') || url.contains('.mov') || url.contains('.mov') || url.contains('.wmv') || url.contains('.flv') || url.contains('.avi')) {
        storyContents.add(VideoStory(url, nextStory, userName + i.toString()));
      }
      else if(url.contains('.jpeg') || url.contains('.jpg') || url.contains('.png') || url.contains('.svg') || url.contains('.gif') || url.contains('.webp')) {
        storyContents.add(PhotoStory(url, nextStory, userName + i.toString()));
      }
      else {
        throw UnsupportedError('Media file type is not supported!');
      }
    }
    super.onInit();
  }

  nextStory() {
    print("---------");
    print('NEXTSTORY INDEXES');
    print('LOG FROM:');
    print(Get.find<AppScreenController>().currentStoryGroupIndex.value);
    print(currentStoryIndex.value);
    print(storyContents.length);
    print("---------");
    if(currentStoryIndex.value < storyContents.length - 1) {
      //There are more stories to show
      storyContents[currentStoryIndex.value].getStoryController().reset();
      currentStoryIndex.value++;
      storyContents[currentStoryIndex.value].getStoryController().play();
      //print(currentStoryIndex.value);
    }
    else {
      //No more stories here make callback
      print('STORY GROUP FINISEHED');
      print(currentStoryIndex.value);
      print(storyContents.length);
      //storyContents[currentStoryIndex.value].getStoryController().reset();
      storyGroupFinished();
    }
  }

  previousStory() {
    if(currentStoryIndex.value > 0) {
      storyContents[currentStoryIndex.value].getStoryController().reset();
      currentStoryIndex--;
      update();
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
