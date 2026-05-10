import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class SingleReelPlayer extends StatefulWidget {
  final String videoUrl;
  final String? thumbnail;

  const SingleReelPlayer({super.key, required this.videoUrl, this.thumbnail});

  @override
  State<SingleReelPlayer> createState() => _SingleReelPlayerState();
}

class _SingleReelPlayerState extends State<SingleReelPlayer> {
  late FlickManager flickManager;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeManager();
  }

  void _initializeManager() {
    final videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    flickManager = FlickManager(
      videoPlayerController: videoController,
      autoPlay: true,
      autoInitialize: true,
    );

    videoController.addListener(() {
      if (videoController.value.isInitialized) {
        if (videoController.value.volume == 0) {
          videoController.setVolume(1.0);
        }
        if (!videoController.value.isLooping) {
          videoController.setLooping(true);
        }
      }

      if (videoController.value.hasError) {
        if (mounted) setState(() => _hasError = true);
      }
    });
  }

  void _onVideoError() {
    final controller = flickManager.flickVideoManager?.videoPlayerController;
    if (controller != null && controller.value.hasError) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    flickManager.flickVideoManager?.videoPlayerController?.removeListener(_onVideoError);
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videoUrl.isEmpty || _hasError) {
      return _buildThumbnail();
    }

    return FlickVideoPlayer(
      flickManager: flickManager,
      flickVideoWithControls: FlickVideoWithControls(
        videoFit: BoxFit.cover,
        controls: null,
        playerLoadingFallback: _buildThumbnail(),
        playerErrorFallback: _buildThumbnail(),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (widget.thumbnail != null && widget.thumbnail!.isNotEmpty) {
      return Image.network(
        widget.thumbnail!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.black,
          child:  Icon(Icons.error_outline, color: Colors.white24, size: 40.sp)),
      );
    }
    return Container(
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white24),
      ),
    );
  }
}