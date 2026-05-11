import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../../controllers/home_controller.dart';
import '../../../../controllers/social_interaction_controller.dart';
import '../../../../models/clip_model.dart';
import '../../../../theme/app_colors.dart';
import '../ad_video_card.dart';
import '../clip_card.dart';
import '../people_card.dart';
import '../category_news_card.dart';

class ForYouTab extends GetView<HomeController> {
  const ForYouTab({super.key});

  @override
  Widget build(BuildContext context) {
    final socialController = Get.find<SocialInteractionController>();
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

    return ListView(
      children: [
        // People section
        _buildSectionHeader('people_you_may_like'),

      Obx(() {
        if (socialController.suggestedPeople.isEmpty) {
      return const SizedBox.shrink();
      }
      return Column(
        children: [
        SizedBox( height: 175.h,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          scrollDirection: Axis.horizontal,
          itemCount: socialController.suggestedPeople.length,
          separatorBuilder: (context, index) => SizedBox(width: 12.w),
          itemBuilder: (_, i) {
            final person = socialController.suggestedPeople[i];

            return PeopleCard(
              name: person['name'],
              subtitle: person['subtitle'],
              isFollowing: person['isFollowing'],
              onDismiss: () => socialController.onDismissPeople(i),
              onFollow: () => socialController.onFollowPeople(i),
            );
          },
        ),
      ),
           SizedBox(height: 24.h),
          Divider(color:AppColors.divider, height: 2, thickness: 3),

        ],
        );
      }),
        SizedBox(height: 6.h),

        // Local clips section
        _buildSectionHeader('local_clips'),
        SizedBox( height: 160.h,
          child: ListView.separated(
            padding:  EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: controller.forYouClips.length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (_, i) {
              final reel = controller.forYouClips[i];
              return GestureDetector(
                  onTap: () {
                    controller.customReelsForNavigation.assignAll(controller.forYouClips);
                    controller.customReelsInitialIndex.value = i;
                    controller.selectedNavIndex.value = 1;
                  },
                child: ClipCard(
                  clip: ClipModel(
                    title: reel.userName,
                    subtitle: reel.description,
                    imageUrl: reel.imageUrl,
                    userProfileImage: reel.userProfileImage,
                  ),
                ),
              );
            },
          ),
        ),
         SizedBox(height: 30.h),
        Divider(color:AppColors.divider, height: 2, thickness: 3),
         SizedBox(height: 12.h),

        // News Section
        ...controller.forYouNews.map((news) {
          if (news.publisherType == 'Ad') {
            return controller.isLoggedIn
                ? AdVideoCard(news: news)
                : const SizedBox.shrink();
          }
          return CategoryNewsCard(news: news, tabType: 'news_foryou');
        }),

        SizedBox(height: 16.h),
      ],
    );
    });
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding:  EdgeInsets.fromLTRB(16.w,8.h, 16.w, 12.h),
      child: Text(  title.tr,
        style:AppTextStyles.headlineMedium.copyWith(color: AppColors.white)),
    );
  }
}