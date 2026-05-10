import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../controllers/home_controller.dart';
import '../ad_video_card.dart';
import '../category_news_card.dart';

class FoodTab extends GetView<HomeController> {
  const FoodTab({super.key});


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
    return ListView.builder(
      padding: EdgeInsets.only(top: 4.h, bottom: 16.h),
      itemCount: controller.foodNews.length,
      itemBuilder: (context, index) {
        final news = controller.foodNews[index];
        if (news.publisherType == 'Ad') {
          return controller.isLoggedIn
              ? AdVideoCard(news: news)
              : const SizedBox.shrink();
        }
    return CategoryNewsCard(news: news, tabType: 'news_food');
    },
    );
  });
}
}