import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramstory2/photostory.dart';
import 'package:instagramstory2/storygroup.dart';
import 'package:instagramstory2/videostory.dart';

void main() => runApp(GetMaterialApp(home: Home()));

class Home extends StatelessWidget {

  void sa() {
    print("saasd");
  }

  @override
  Widget build(context) {
    List<String> stories = [
    "https://images.squarespace-cdn.com/content/60f1a490a90ed8713c41c36c/1628879792098-0VS11XI9AWY4QASNI3ZH/36-design-powers-image-file-format.jpg?content-type=image%2Fjpeg",
    "https://images.all-free-download.com/footage_preview/mp4/tiny_wild_bird_searching_for_food_in_nature_6892037.mp4"];
    return StoryGroup(stories: stories);
  }
}
