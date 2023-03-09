import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:instagramstory2/storygroup.dart';

class AppScreen extends StatelessWidget {

  late AppScreenController appScreenController;

  AppScreen({required List<StoryGroup> storyGroups}) : appScreenController = Get.put(AppScreenController(storyGroups: storyGroups));

  Widget build(BuildContext context) {

    return Scaffold(
      body: GestureDetector(
        child: CarouselSlider(
          slideTransform: const CubeTransform(),
          children: appScreenController.storyGroups,
        ),
        onTapDown: (TapDownDetails details) {
          print("tapped");

          //storyGroupController.storyContents[storyGroupController.currentStoryIndex.value].getStoryController().pause();
        },
        onTapUp: (TapUpDetails details) {
          print("uppp");
          //if(!storyGroupController.storyContents[storyGroupController.currentStoryIndex.value].getStoryController().isStopped) storyGroupController.storyContents[storyGroupController.currentStoryIndex.value].getStoryController().play();
        },
      ),
    );
  }
}

class AppScreenController extends GetxController {

  late List<StoryGroup> storyGroups;


  AppScreenController({required this.storyGroups});


}