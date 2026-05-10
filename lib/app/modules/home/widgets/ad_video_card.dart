import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import 'package:news_break/app/widgets/publisher_avatar.dart';
import 'package:video_player/video_player.dart';
import '../../../controllers/ad_video_controller.dart';
import '../../../controllers/home_controller.dart';
import '../../../models/news_model.dart';
import '../../../widgets/about_profile_sheet.dart';

class AdVideoCard extends StatelessWidget {
  final NewsModel news;
  const AdVideoCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final adController = Get.put(AdVideoController(), tag: news.id.toString());

    if (!adController.isInitialized.value) {
      adController.initializeVideo(news.videoUrl ?? 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
    }
    return Container(
      margin:EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color:AppColors.scaffoldBg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildVideoPlayer(adController),
          SizedBox(height: 24.h),
          Divider(color:AppColors.divider, height: 2, thickness: 3),
          SizedBox(height: 18.h),
        ],
      ),
    );
  }

  // Header Section
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 8.h),
      child: Row(
        children: [
          PublisherAvatar.fromNews(news: news),
           SizedBox(width: 10.w),
          _buildPublisherInfo(),
          _buildCloseButton(),
        ],
      ),
    );
  }

  Widget _buildPublisherInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => AboutProfileSheet.showFromNews(Get.context!, news),
            child: Text( news.publisherName,  style: AppTextStyles.bodyMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 1)),
          Text('Ad', style: AppTextStyles.overline.copyWith(color: Color(0xFF929292))),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return GestureDetector(
      onTap: () => Get.find<HomeController>().hideNews(news),
      child:Icon(Icons.close, color: Color(0xFF6C6C6C), size: 20.sp),
    );
  }

  // Video Section
  Widget _buildVideoPlayer(AdVideoController adController) {
    return Obx(() => Stack(
      children: [
        ClipRRect(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: adController.isInitialized.value
                ? VideoPlayer(adController.videoController)
                :  Center(child: CircularProgressIndicator(color: Get.isDarkMode ? Colors.white : const Color(0xFF242424))))),
        if (adController.isInitialized.value) ...[
          _buildDurationTag(adController),
          _buildControls(adController),
        ]
      ],
    ));
  }

  Widget _buildDurationTag(AdVideoController adController) {
    return Positioned( top: 8,  right: 8,
        child: ValueListenableBuilder(
          valueListenable: adController.videoController,
          builder: (context, value, stackTrace) => Text(
            adController.formatDuration(value.duration - value.position),
            style:AppTextStyles.labelMedium)),
    );
  }

  Widget _buildControls(AdVideoController adController) {
    return Positioned( bottom: 8, left: 8,
      child: Row(
        children: [
          // Play/Pause Button
          GestureDetector(
            onTap: adController.togglePlay,
            child: Icon(
              adController.isPlaying.value ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 20.sp)),
          SizedBox(width: 12.w),
          // Mute/Unmute Button
          GestureDetector(
            onTap: adController.toggleMute,
            child: Icon(
              adController.isMuted.value ? Icons.volume_off : Icons.volume_up, color: Colors.white, size: 20.sp)),
        ],
      ),
    );
  }
}