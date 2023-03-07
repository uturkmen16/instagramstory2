import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramstory2/photostory.dart';
import 'package:instagramstory2/videostory.dart';

void main() => runApp(GetMaterialApp(home: Home()));

class Home extends StatelessWidget {

  void sa() {
    print("saasd");
  }

  @override
  Widget build(context) {
    return VideoStory("https://images.all-free-download.com/footage_preview/mp4/tiny_wild_bird_searching_for_food_in_nature_6892037.mp4", sa);
  }
}
