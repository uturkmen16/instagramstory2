import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramstory2/photostory.dart';
import 'package:instagramstory2/storygroup.dart';
import 'package:instagramstory2/videostory.dart';

import 'appscreen.dart';

void main() => runApp(GetMaterialApp(home: Home()));

class Home extends StatelessWidget {

  @override
  Widget build(context) {
    List<String> stories1 = [
      "https://wallpapercave.com/wp/wp11388966.jpg",
      "https://wallpapercave.com/wp/wp11388993.jpg",
    "https://img.freepik.com/free-photo/wide-angle-shot-single-tree-growing-clouded-sky-during-sunset-surrounded-by-grass_181624-22807.jpg",
    ];
    List<String> stories2 = [
      "https://images.squarespace-cdn.com/content/60f1a490a90ed8713c41c36c/1628879792098-0VS11XI9AWY4QASNI3ZH/36-design-powers-image-file-format.jpg?content-type=image%2Fjpeg",
      "https://images.all-free-download.com/footage_preview/mp4/tiny_wild_bird_searching_for_food_in_nature_6892037.mp4",
      "https://itkv.tmgrup.com.tr/album/2022/10/06/benim-adim-cafer-boyum-110-sozleriyle-ilk-fenomenlerdendi-yenimahalleli-cafer-evlendi-barklandi-coluk-cocuga-k-1665038881907.jpg",
      "https://i.ytimg.com/vi/CA73SVqNDSI/mqdefault.jpg",
    ];
    List<String> stories3 = [
      "https://seyyahdefteri.com/wp-content/uploads/2018/12/G%C3%B6ksu-Park%C4%B1-Nerede-5.jpg"
    ];
    List<StoryGroup> storyGroups = [
      StoryGroup(stories: stories1, userName: 'UmutJohn',storyGroupFinished: storyGroupFinished, profilePictureUrl: "https://siberci.com/wp-content/uploads/2020/03/hacker-ve-programci-1024x576.png",),
      StoryGroup(stories: stories2, userName: 'DORAEXPLORA',storyGroupFinished: storyGroupFinished ,profilePictureUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCumtO5MnRJWTtdw6-7RVWBi298qT4btvPTEcF0HMMx-OatsCFj2RtfVKxmTx1sGCgYmU&usqp=CAU",),
      StoryGroup(stories: stories3, userName: 'Goks',storyGroupFinished: storyGroupFinished, profilePictureUrl: "https://upload.wikimedia.org/wikipedia/commons/1/19/Ankara_by_night_2013.jpg",)
    ];
    return AppScreen(storyGroups: storyGroups);
  }

  storyGroupFinished() {
    AppScreenController appScreenController = Get.find<AppScreenController>();
    if (appScreenController.currentStoryGroupIndex.value < appScreenController.storyGroups.length - 1) {
      appScreenController.storyGroups[appScreenController.currentStoryGroupIndex.value].storyGroupController.resetCurrentStory();
      appScreenController.carouselSliderController.nextPage();
    }

   // storyContents[currentStoryIndex.value].getStoryController().reset();
  }

}
