import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:instagramstory2/storycontent.dart';
import 'package:instagramstory2/storygroup.dart';

class AppScreen extends StatelessWidget {

  late AppScreenController appScreenController;

  AppScreen({required List<StoryGroup> storyGroups}) : appScreenController = Get.put(AppScreenController(storyGroups: storyGroups));

  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: CarouselSlider(
          slideTransform: const CubeTransform(),
          controller: appScreenController.carouselSliderController,
          children: appScreenController.storyGroups,
          autoSliderTransitionTime: Duration(milliseconds: 750),
          onSlideChanged: (newIndex) {
            for (int i = 0; i  < appScreenController.storyGroups.length; i++) {
              if(i != newIndex || appScreenController.isPressedDown.value) {
                //Reset other storygroups when change
                appScreenController.storyGroups[i].storyGroupController.resetCurrentStory();
                appScreenController.storyGroups[i].storyGroupController.update();
              }
            }
            //Set new story group index
            appScreenController.currentStoryGroupIndex.value = newIndex;

          },
          onSlideStart: () {
            print('slidestart');
            for (int i = 0; i  < appScreenController.storyGroups.length; i++) {
              { //Reset other storygroups when change
                appScreenController.storyGroups[i].storyGroupController.pauseCurrentStory();
                appScreenController.storyGroups[i].storyGroupController.update();
              }
            }
            appScreenController.isPressedDown.value = true;
          },
          onSlideEnd: () {
            print('ONSLIDEEND PLAYING:');
            print(appScreenController.currentStoryGroupIndex);
            print(appScreenController.storyGroups[appScreenController.currentStoryGroupIndex.value].storyGroupController.currentStoryIndex);
            appScreenController.storyGroups[appScreenController.currentStoryGroupIndex.value].storyGroupController.playCurrentStory();
            for (int i = 0; i  < appScreenController.storyGroups.length; i++) {
              { //Reset other storygroups when change
                if(i != appScreenController.currentStoryGroupIndex.value){
                  //appScreenController.storyGroups[i].storyGroupController.pauseCurrentStory();
                  //appScreenController.storyGroups[i].storyGroupController.update();
                }
              }
            }
            appScreenController.isPressedDown.value = false;
          },
        ),
        onTapUp: (TapUpDetails details) {
          if(details.globalPosition.dx >= MediaQuery.of(context).size.width / 2) {
            //RIGHT
            if(appScreenController.storyGroups[appScreenController.currentStoryGroupIndex.value].storyGroupController.currentStoryIndex.value < appScreenController.storyGroups[appScreenController.currentStoryGroupIndex.value].storyGroupController.storyContents.length - 1){
              //Go to the next story
              appScreenController.storyGroups[appScreenController.currentStoryGroupIndex.value].storyGroupController.nextStory();
            }
            else if(appScreenController.currentStoryGroupIndex.value < appScreenController.storyGroups.length - 1){
              //Go to next story group
              print('APPSCREEN:GOTONEXTPAGE');
              appScreenController.storyGroups[appScreenController.currentStoryGroupIndex.value].storyGroupController.storyGroupFinished();
            }
          }
          else {
            //LEFT
            if(appScreenController.storyGroups[appScreenController.currentStoryGroupIndex.value].storyGroupController.currentStoryIndex.value > 0) {
              //Go to the previous story
              appScreenController.storyGroups[appScreenController.currentStoryGroupIndex.value].storyGroupController.previousStory();
            }
            else if(appScreenController.currentStoryGroupIndex.value > 0) {
              appScreenController.carouselSliderController.previousPage();
            }
          }
          //if(!storyGroupController.storyContents[storyGroupController.currentStoryIndex.value].getStoryController().isStopped) storyGroupController.storyContents[storyGroupController.currentStoryIndex.value].getStoryController().play();
        },
      ),
    );
  }

}

class AppScreenController extends GetxController {

  List<StoryGroup> storyGroups;
  RxInt currentStoryGroupIndex = 0.obs;
  CarouselSliderController carouselSliderController = CarouselSliderController();
  RxBool isPressedDown = false.obs;

  AppScreenController({required this.storyGroups});
/*
  storyGroupFinished() {
    if(currentStoryGroupIndex.value < storyGroups.length - 1){
      //Go to next story group
      //storyGroups[.currentStoryGroupIndex.value].storyGroupController.nextStory();
      carouselSliderController.nextPage();
    }
    //Everything is over
  }

 */

}