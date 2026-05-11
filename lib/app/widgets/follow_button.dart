import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/social_interaction_controller.dart';
import '../models/news_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class FollowButton extends StatelessWidget {
  final NewsModel news;

  const FollowButton({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    final socialCtrl = Get.find<SocialInteractionController>();

    return ValueListenableBuilder<int>(
      valueListenable: socialCtrl.followNotifier,
      builder: (context, error, stackTrace) {
        final isFollowing = socialCtrl.followedPublishers[news.publisherName] == true;

        return TextButton(
          onPressed: () => socialCtrl.toggleFollow(news),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            isFollowing ? 'following'.tr : 'follow'.tr,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isFollowing ? Colors.grey : AppColors.textGreen,
            ),
          ),
        );
      },
    );
  }
}