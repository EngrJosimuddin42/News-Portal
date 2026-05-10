import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';


class FullScreenVideoPlayer extends StatefulWidget {
  final String url;
  const FullScreenVideoPlayer({super.key, required this.url});

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late FlickManager flickManager;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeManager();
  }

  void _initializeManager() {
    final videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    );

    flickManager = FlickManager(
      videoPlayerController: videoController,
      autoPlay: true,
    );

    videoController.initialize().then((_) {
      videoController.setVolume(1.0);
      if (mounted) {
        setState(() {
          isInitialized = true;
        });
      }
    }).catchError((error) {
      debugPrint("Video Error: $error");
    });
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: FlickVideoPlayer(
          flickManager: flickManager,
        ),
      ),
    );
  }
}