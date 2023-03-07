
//Interface for story controllers
import 'package:get/get.dart';

abstract class StoryContent {
  StoryController getStoryController();
}

abstract class StoryController {
  Function onContentFinished;
  String contentUrl;
  Rx<Duration> elapsedTime = Rx<Duration>(Duration.zero);
  Rx<Duration> contentLength = Rx<Duration>(Duration.zero);

  StoryController({required this.contentUrl, required this.onContentFinished});

  void start();

  void pause();

  void play();

  void stop();
}
