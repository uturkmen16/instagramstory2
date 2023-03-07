

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:instagramstory2/photostory.dart';
import 'package:instagramstory2/story.dart';
import 'package:instagramstory2/videostory.dart';

class StoryGroup extends StatelessWidget{

  late StoryGroupController storyGroupController;
  Rx<Offset> horizontalDragStart = Offset.zero.obs;
  Rx<Offset> horizontalDrag = Offset.zero.obs;

  StoryGroup({required List<String> stories}){
    storyGroupController = Get.put(StoryGroupController(stories: stories));
  }

  @override
  Widget build(BuildContext context) {
    return Text('');
  }

}

class StoryGroupController extends GetxController {
  //This can probably be done by one list instead of two.
  List<String> stories;
  List<StoryContent> storyContents = [];
  RxInt currentStoryNo = 0.obs;

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
    currentStoryNo.value++;
    update();
  }
}