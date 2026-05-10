import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class AdVideoController extends GetxController {
  late VideoPlayerController videoController;
  var isInitialized = false.obs;
  var isPlaying = false.obs;
  var isMuted = false.obs;

  void initializeVideo(String url) {
    if (isInitialized.value) return;
    videoController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        isInitialized.value = true;
        videoController.setLooping(false);
        videoController.addListener(() {
          if (videoController.value.position >= videoController.value.duration) {
            isPlaying.value = false;
          } else {
            isPlaying.value = videoController.value.isPlaying;
          }
        });
        update();
      });
  }

  void togglePlay() {
    if (!videoController.value.isInitialized) return;
    if (videoController.value.position >= videoController.value.duration) {
      videoController.seekTo(Duration.zero);
    }
    if (videoController.value.isPlaying) {
      videoController.pause();
      isPlaying.value = false;
    } else {
      videoController.play();
      isPlaying.value = true;
    }
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
    videoController.setVolume(isMuted.value ? 0 : 1);
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void onClose() {
    videoController.dispose();
    super.onClose();
  }
}