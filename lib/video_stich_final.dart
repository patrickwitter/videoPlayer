import 'package:better_player/better_player.dart';

import 'package:flutter/material.dart';

/// The code below is experm=imental for custom video controls to match the design
///
///
///

class VideoSequencePlayer2 extends StatefulWidget {
  @override
  _VideoSequencePlayer2State createState() => _VideoSequencePlayer2State();
}

class _VideoSequencePlayer2State extends State<VideoSequencePlayer2> {
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
    initializeAndPlay(currentIndex);
    super.initState();
  }

  void initializeAndPlay(int index) {
    print("init and play");
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoUrls[index],
    );
    betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        // autoPlay: true,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          playerTheme: BetterPlayerTheme.custom,
          customControlsBuilder: (controller, onControlsVisibilityChanged) =>
              CustomControlsWidget(
            controller: controller,
            onControlsVisibilityChanged: onControlsVisibilityChanged,
          ),
        ),
      ),
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
      BetterPlayerConfiguration(
        autoPlay: true,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          playerTheme: BetterPlayerTheme.custom,
          customControlsBuilder: (controller, onControlsVisibilityChanged) =>
              CustomControlsWidget(
            controller: controller,
            onControlsVisibilityChanged: onControlsVisibilityChanged,
          ),
        ),
      ),
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
    setState(() {
      print("setstae called");
    });
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

class CustomControlsWidget extends StatefulWidget {
  final BetterPlayerController? controller;
  final Function(bool visbility)? onControlsVisibilityChanged;

  const CustomControlsWidget({
    Key? key,
    this.controller,
    this.onControlsVisibilityChanged,
  }) : super(key: key);

  @override
  _CustomControlsWidgetState createState() => _CustomControlsWidgetState();
}

class _CustomControlsWidgetState extends State<CustomControlsWidget> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    widget.controller?.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("${widget.controller!.isVideoInitialized()!}");
    return Positioned.fill(
      child: widget.controller!.isVideoInitialized()!
          ? Stack(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            widget.controller!.isFullScreen
                                ? Icons.fullscreen_exit
                                : Icons.fullscreen,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      onTap: () => setState(() {
                        if (widget.controller!.isFullScreen)
                          widget.controller!.exitFullScreen();
                        else
                          widget.controller!.enterFullScreen();
                      }),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () async {
                                  Duration? videoDuration = await widget
                                      .controller!
                                      .videoPlayerController!
                                      .position;
                                  setState(() {
                                    if (widget.controller!.isPlaying()!) {
                                      Duration rewindDuration = Duration(
                                          seconds:
                                              (videoDuration!.inSeconds - 2));
                                      if (rewindDuration <
                                          widget
                                              .controller!
                                              .videoPlayerController!
                                              .value
                                              .duration!) {
                                        widget.controller!
                                            .seekTo(Duration(seconds: 0));
                                      } else {
                                        widget.controller!
                                            .seekTo(rewindDuration);
                                      }
                                    }
                                  });
                                },
                                child: Icon(
                                  Icons.fast_rewind,
                                  color: Colors.white,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (widget.controller!.isPlaying()!)
                                      widget.controller!.pause();
                                    else
                                      widget.controller!.play();
                                  });
                                },
                                child: Icon(
                                  widget.controller!.isPlaying()!
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  Duration? videoDuration = await widget
                                      .controller!
                                      .videoPlayerController!
                                      .position;
                                  setState(() {
                                    if (widget.controller!.isPlaying()!) {
                                      Duration forwardDuration = Duration(
                                          seconds:
                                              (videoDuration!.inSeconds + 2));
                                      if (forwardDuration >
                                          widget
                                              .controller!
                                              .videoPlayerController!
                                              .value
                                              .duration!) {
                                        widget.controller!
                                            .seekTo(Duration(seconds: 0));
                                        widget.controller!.pause();
                                      } else {
                                        widget.controller!
                                            .seekTo(forwardDuration);
                                      }
                                    }
                                  });
                                },
                                child: Icon(
                                  Icons.fast_forward,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomProgressBar(controller: widget.controller!),
                )
              ],
            )
          : SizedBox.shrink(),
    );
  }
}

class CustomProgressBar extends StatefulWidget {
  final BetterPlayerController controller;
  const CustomProgressBar({Key? key, required this.controller})
      : super(key: key);

  @override
  _CustomProgressBarState createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar> {
  late double _progress;
  Duration? _remainingDuration;

  @override
  void initState() {
    super.initState();
    _progress = widget
        .controller.videoPlayerController!.value.position.inSeconds
        .toDouble();
    _remainingDuration =
        widget.controller.videoPlayerController!.value.duration! -
            widget.controller.videoPlayerController!.value.position;
    widget.controller.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
        setState(() {
          _progress = widget
              .controller.videoPlayerController!.value.position.inSeconds
              .toDouble();
          _remainingDuration =
              widget.controller.videoPlayerController!.value.duration! -
                  widget.controller.videoPlayerController!.value.position;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.controller.isVideoInitialized()!
        ? Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * .88,
                height: 30,
                child: Slider(
                  activeColor: Colors.orange,
                  inactiveColor: Colors.grey,
                  value: _progress,
                  min: 0.0,
                  max: widget.controller.videoPlayerController!.value.duration!
                      .inSeconds
                      .toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _progress = value;
                      widget.controller
                          .seekTo(Duration(seconds: _progress.toInt()));
                      _remainingDuration = widget.controller
                              .videoPlayerController!.value.duration! -
                          widget
                              .controller.videoPlayerController!.value.position;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(
                  "${_remainingDuration!.inMinutes}:${_remainingDuration!.inSeconds.remainder(60)}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}
