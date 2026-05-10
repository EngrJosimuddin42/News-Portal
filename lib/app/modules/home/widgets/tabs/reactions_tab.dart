import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/home_controller.dart';
import '../ad_video_card.dart';
import '../news_card.dart';

class ReactionsTab extends GetView<HomeController> {
  const ReactionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView.builder(
        itemCount: controller.reactionsNews.length,
        itemBuilder: (context, index) {
          final news = controller.reactionsNews[index];

          if (news.publisherType == 'Ad') {
            return controller.isLoggedIn
                ? AdVideoCard(news: news)
                : const SizedBox.shrink();
          }

          return NewsCard(
              news: news, tabType: 'news_reactions'
          );
        },
      );
    });
  }
}