import 'package:better_player/better_player.dart';

import 'package:flutter/material.dart';

class VideoSequencePlayer extends StatefulWidget {
  @override
  _VideoSequencePlayerState createState() => _VideoSequencePlayerState();
}

class _VideoSequencePlayerState extends State<VideoSequencePlayer> {
  List<String> videoUrls = [
    "https://storage.googleapis.com/upcj-fb059.appspot.com/MentalHealth.mp4",
    "https://storage.googleapis.com/upcj-fb059.appspot.com/BeautyOfNature.mp4",
    "https://storage.googleapis.com/upcj-fb059.appspot.com/Nature.mp4",
    "https://storage.googleapis.com/upcj-fb059.appspot.com/MentalHealth.mp4",
  ]; // Populate with your video URLs
  int currentIndex = 0;
  late BetterPlayerController betterPlayerController;

  @override
  void initState() {
    super.initState();
    initializeAndPlay(currentIndex);
  }

  void initializeAndPlay(int index) {
    print("init and play");
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoUrls[index],
    );
    betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(),
      betterPlayerDataSource: dataSource,
    );

    betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
        print("Video Finsihed");
        if (currentIndex < videoUrls.length - 1) {
          continuePlay(++currentIndex);
        }
      }
    });

    betterPlayerController.setupDataSource(dataSource);
  }

  void continuePlay(int index) {
    print("continue and play");
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoUrls[index],
    );

    betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(autoPlay: true),
      betterPlayerDataSource: dataSource,
    );

    betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
        if (currentIndex < videoUrls.length - 1) {
          continuePlay(++currentIndex);
        }
      }
    });

    betterPlayerController.setupDataSource(dataSource);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Sequence Player POC")),
      body: AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer(controller: betterPlayerController),
      ),
    );
  }

  @override
  void dispose() {
    betterPlayerController.dispose();
    super.dispose();
  }
}
