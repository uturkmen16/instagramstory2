
//Interface for story controllers
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

abstract class StoryContent extends StatelessWidget{
  StoryController getStoryController();
}

abstract class StoryController extends GetxController{
  abstract Function onContentFinished;
  abstract String contentUrl;
  abstract bool isStopped;

  Rx<Duration> getElapsedTime();
  Rx<Duration> getContentLength();

  void start();

  void pause();

  void play();

  void stop();
}
