import 'package:better_player/better_player.dart';

import 'package:flutter/material.dart';

/// The code below is experm=imental for custom video controls to match the design
///
///
///

class VideoSequencePlayer3 extends StatefulWidget {
  @override
  _VideoSequencePlayer3State createState() => _VideoSequencePlayer3State();
}

class _VideoSequencePlayer3State extends State<VideoSequencePlayer3> {
  List<String> videoUrls = [
    "https://storage.googleapis.com/staging.elite-firefly-403919.appspot.com/10sec1.mp4",
    "https://storage.googleapis.com/staging.elite-firefly-403919.appspot.com/10sec2.mp4",
  ]; // Populate with your video URLs
  int currentIndex = 0;
  late BetterPlayerController activeBetterPlayerController;
  late List<BetterPlayerController> betterPlayerControllers;
  Key refreshKey = UniqueKey();
  @override
  void initState() {
    print("initState");
    initializeAndPlay(currentIndex, videoUrls);
    super.initState();
  }

  List<BetterPlayerController> initControllers(List<String> videoUrls) {
    List<BetterPlayerController> ctrls = [];
    BetterPlayerDataSource dataSource;
    BetterPlayerController target;
    for (int index = 0; index < videoUrls.length; index++) {
      dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        videoUrls[index],
      );
      if (index == 0) {
        target = BetterPlayerController(
          BetterPlayerConfiguration(
            // autoPlay: true,
            controlsConfiguration: BetterPlayerControlsConfiguration(
              playerTheme: BetterPlayerTheme.custom,
              customControlsBuilder:
                  (controller, onControlsVisibilityChanged) =>
                      CustomControlsWidget(
                controller: controller,
                onControlsVisibilityChanged: onControlsVisibilityChanged,
              ),
            ),
          ),
          betterPlayerDataSource: dataSource,
        );

        target.addEventsListener((event) {
          if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
            print("Video Finsihed");
            if (currentIndex < videoUrls.length - 1) {
              playVideo(++currentIndex);
            }
          }
        });

        target.setupDataSource(dataSource);

        ctrls.add(target);
      } else {
        target = BetterPlayerController(
          BetterPlayerConfiguration(
            autoPlay: false,
            controlsConfiguration: BetterPlayerControlsConfiguration(
              playerTheme: BetterPlayerTheme.custom,
              customControlsBuilder:
                  (controller, onControlsVisibilityChanged) =>
                      CustomControlsWidget(
                controller: controller,
                onControlsVisibilityChanged: onControlsVisibilityChanged,
              ),
            ),
          ),
          betterPlayerDataSource: dataSource,
        );

        target.addEventsListener((event) {
          if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
            if (currentIndex < videoUrls.length - 1) {
              playVideo(++currentIndex);
            }
          }
        });

        target.setupDataSource(dataSource);
        ctrls.add(target);
      }
    }
    return ctrls;
  }

  /// Preconditon all better player controllers must be initalized
  void playVideo(int index) {
    setState(() {
      print("------------------------fired------------------------");
      activeBetterPlayerController = betterPlayerControllers[index];
      activeBetterPlayerController.play();
    });
  }

  void initializeAndPlay(int initIndex, List<String> video) {
    print("LENGTH VIDEO ${video.length}  ");
    betterPlayerControllers = initControllers(videoUrls);
    print("LENGTH ${betterPlayerControllers.length}");
    activeBetterPlayerController = betterPlayerControllers[initIndex];
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     " AUTOPLAY ${activeBetterPlayerController.betterPlayerConfiguration.autoPlay}");
    return Scaffold(
      appBar: AppBar(title: Text("Video Sequence Player POC")),
      body: AspectRatio(
        key: refreshKey,
        aspectRatio: 16 / 9,
        child: BetterPlayer(
          controller: activeBetterPlayerController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (BetterPlayerController i in betterPlayerControllers) {
      i.dispose();
    }
    super.dispose();
  }
}

//----------------------------------- CUSTOM CONTROLS
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
        if (mounted) {
          setState(() {});
        }
      }
      if (event.betterPlayerEventType == BetterPlayerEventType.exception) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    print("ISVIDEO INIT ${widget.controller!.isVideoInitialized()!}");
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
    print("-------Called Dispose------");
    widget.controller.dispose();
    super.dispose();
  }
}
