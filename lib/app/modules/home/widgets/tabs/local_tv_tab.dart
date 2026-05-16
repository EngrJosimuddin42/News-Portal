import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../../controllers/home_controller.dart';
import '../ad_video_card.dart';
import '../category_news_card.dart';

class LocalTvTab extends GetView<HomeController> {
  final String message;

  const LocalTvTab({
    super.key,
    this.message = 'No relevant articles',
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final hasLocation = controller.selectedLocation.value != null;
      return hasLocation ? _buildWithLocation() : _buildWithoutLocation();
    });
  }

  Widget _buildWithoutLocation() {
    return SingleChildScrollView(
      child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50.h),
          Image.asset( 'assets/images/socket.png', width: 130.w, height: 130.w),
           SizedBox(height: 16.h),
          Text(message, style:AppTextStyles.caption.copyWith(color: Color(0xFF9B9B9B))),
           SizedBox(height: 16.h),
          OutlinedButton(
            onPressed: controller.onTryAgain,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.all(20.w),
              minimumSize: Size(90.w, 50.h),
                side: BorderSide(color:Get.isDarkMode?Color(0xFF7B83EB):Color(0xFF7B82EB)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60.r))),
              child: Text('Try Again', style: AppTextStyles.caption.copyWith(color:Get.isDarkMode?Color(0xFF7B83EB):Color(0xFF7B82EB)))),
        ],
      ),
    ),
    );
  }

  Widget _buildWithLocation() {
      return ListView.builder(
        padding: EdgeInsets.only(top: 4.h, bottom: 16.h),
        itemCount: controller.localTvNews.length,
        itemBuilder: (context, index) {
          final news = controller.localTvNews[index];
          if (news.publisherType == 'Ad') {
            return AdVideoCard(news: news);
          }
          return CategoryNewsCard(news: news, tabType: 'news_localtv');
        },
      );
  }
}