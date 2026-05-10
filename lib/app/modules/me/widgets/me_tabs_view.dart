import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../controllers/auth/auth_controller.dart';
import '../../../controllers/me/me_controller.dart';
import '../../../controllers/reels/reels_controller.dart';
import '../../../controllers/social_interaction_controller.dart';
import '../../../models/news_model.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/network_or_file_image.dart';
import '../../trends/player/full_screen_video_player.dart';
import 'history_item.dart';
import 'package:news_break/app/modules/me/widgets/reactions_tab.dart' as ReelsReactions;

class MeTabsView extends GetView<MeController> {
  final bool isLoggedIn;
  const MeTabsView({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Obx(() {
          final currentTabs = isLoggedIn ? controller.tabs : ['Saved', 'History'];
          return _buildTabBar(context, currentTabs);
        }),

        Obx(() => isLoggedIn
            ? _buildLoggedInTabContent(context)
            : _buildLoggedOutTabContent(context)),
      ],
    );
  }

  Widget _buildLoggedInTabContent(BuildContext context) {
    final tabs = controller.tabs;
    final tab = controller.selectedTab.value;
    final tabName = tab < tabs.length ? tabs[tab] : '';

    switch (tabName) {
      case 'Content':
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
              child: Row(
                children: [
                  _chip('Posts', true, () {}),
                ],
              ),
            ),


            Obx(() {
              final myPosts = Get.find<SocialInteractionController>().userPosts;

              if (myPosts.isEmpty) {
                return Column(
                  children: [
                    SizedBox(height: 60.h),
                    Text('No Content', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white)),
                    SizedBox(height: 8.h),
                    Text("You haven't published any posts yet.", style: AppTextStyles.overline),
                    SizedBox(height: 40.h),
                  ],
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: myPosts.length,
                separatorBuilder: (context, index) =>  Divider(color:AppColors.white),
                itemBuilder: (context, i) {
                  final item = myPosts[i];
                  final imageUrl = item.imageUrl;
                  return ListTile(
                    contentPadding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                    leading: SizedBox(
                        width: 50.w, height: 50.h,
                        child: NetworkOrFileImage(
                            url: imageUrl,
                            width: 50.w, height: 50.h,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(4.r))),
                    title: Text(item.author, style: AppTextStyles.caption.copyWith(color: AppColors.white)),
                    subtitle: Text(item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.overline),
                    onTap: () {
                      Get.toNamed(Routes.NEWS_DETAIL, arguments: {
                        'news': NewsModel(
                          id: item.id,
                          category: item.category,
                          title: item.title,
                          author: item.author,
                          publisherName: item.publisherName,
                          timeAgo: item.timeAgo,
                          imageUrl: imageUrl,
                          body: item.body,
                          publisherMeta: item.publisherName,
                          likes: item.likes,
                          comments: item.comments,
                        ),
                        'tabType': 'post',
                      });
                    },
                  );
                },
              );
            }),
          ],
        );

      case 'Reactions':
        return ReelsReactions.ReactionsTab(
          user: AuthController.to.user.value,
          controller: Get.find<ReelsController>(),
          isFullActivity: true, // news + trends
        );

      case 'Saved':
        return _buildSharedSavedView();

      case 'History':
        return _buildSharedHistoryView(context);
      default:
        return const SizedBox();
    }
  }

  Widget _buildLoggedOutTabContent(BuildContext context) {
    final tab = controller.selectedTab.value;
    return tab == 0 ? _buildSharedSavedView() : _buildSharedHistoryView(context);
  }

  Widget _buildTabBar(BuildContext context, List<String> tabs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(tabs.length, (i) {
              final selected = controller.selectedTab.value == i;
              return GestureDetector(
                onTap: () => controller.selectedTab.value = i,
                child: Padding(
                  padding:  EdgeInsets.only(right: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tabs[i], style: AppTextStyles.caption.copyWith(color: AppColors.white)),
                      SizedBox(height: 4.h),
                      if (selected)
                        Container(height: 2.h, width: 50.h, color: AppColors.white),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: 8.h),
        Divider(color:AppColors.divide, height: 1),
      ],
    );
  }

  Widget _chip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
              color:AppColors.white,
              borderRadius: BorderRadius.circular(60.r)),
          child: Text(label,style: AppTextStyles.labelSmall.copyWith( color:AppColors.background))),
    );
  }

  Widget _buildSharedSavedView() {
    final socialCtrl = Get.find<SocialInteractionController>();

    return Obx(() {
      final reelItems = controller.savedReelsData;
      final newsItems = socialCtrl.savedNewsItems;
      final bool isEmpty = reelItems.isEmpty && newsItems.isEmpty;

      return Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
            child: Row(
              children: [
                _chip('All', controller.selectedChipIndex.value == 0,
                        () => controller.updateChip(0)),
              ],
            ),
          ),

          if (isEmpty) ...[
            SizedBox(height: 40.h),
            Text('No Saved articles', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white)),
            SizedBox(height: 8.h),
            Text("You haven't saved anything. Yet.", style: AppTextStyles.overline),
            SizedBox(height: 40.h),
          ] else ...[

            // Reels
            if (reelItems.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reelItems.length,
                separatorBuilder: (context, index) =>  Divider(color:AppColors.white),
                itemBuilder: (context, index) {
                  final item = reelItems[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                    leading: SizedBox(
                      width: 50.w,
                      height: 50.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          NetworkOrFileImage(
                              url: item.imageUrl,
                              width: 50.w,
                              height: 50.h,
                              fit: BoxFit.cover,
                              borderRadius: BorderRadius.circular(4.r)),
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration:  BoxDecoration(
                                color: Colors.black45,
                                shape: BoxShape.circle),
                            child:  Icon(Icons.play_arrow, color: Colors.white, size: 16.sp),
                          ),
                        ],
                      ),
                    ),
                    title: Text(item.userName, style: AppTextStyles.caption.copyWith(color: AppColors.white)),
                    subtitle: Text(item.description, style: AppTextStyles.overline),
                    onTap: () => Get.to(
                          () => FullScreenVideoPlayer(url: item.videoUrl ?? ''),
                      arguments: item,
                    ),
                  );
                },
              ),

            // News
            if (newsItems.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: newsItems.length,
                separatorBuilder: (context, index) => Divider(color:AppColors.white),
                itemBuilder: (context, index) {
                  final item = newsItems[index];
                  return ListTile(
                    contentPadding:EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                    leading: SizedBox(
                      width: 50.w,
                      height: 50.h,
                      child: NetworkOrFileImage(
                        url: item.imageUrl,
                        width: 50.w,
                        height: 50.h,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    title: Text(item.title, style: AppTextStyles.caption.copyWith(color: AppColors.white)),
                    subtitle: Text(item.publisherName, style: AppTextStyles.overline),
                    onTap: () => Get.toNamed(Routes.NEWS_DETAIL, arguments: item),
                  );
                },
              ),
          ],
        ],
      );
    });
  }


  Widget _buildSharedHistoryView(BuildContext context) {
    return Obx(() => controller.hasHistory.value
        ? Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
          child: Row(
            children: [
              Icon(Icons.visibility_off_outlined,  color: Colors.grey, size: 16.sp),
              SizedBox(width: 6.w),
              Text('Visible only to you', style:AppTextStyles.labelMedium.copyWith(color: AppColors.info)),
              const Spacer(),
              GestureDetector(
                  onTap: () => controller.onClearAll(context),
                  child:Text('Clear All', style:AppTextStyles.small.copyWith(
                      color:Get.isDarkMode? Color(0xFF3498FA):Color(0xFF4DA4FB)))),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Divider(color:AppColors.divide, height: 1),
        SizedBox(height: 16.h),

        ...controller.historyItems.map((item) => Column(
          key: ValueKey(item.id),
          children: [
            HistoryItem(model: item),
            Divider(color:AppColors.divide, height: 1),
          ],
        )),
      ],
    )
        : _buildNoHistoryView());
  }

  Widget _buildNoHistoryView() {
    return Padding(
      padding: EdgeInsets.only(top: 60.w),
      child: Column(
        children: [
          Text('No History', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white)),
          SizedBox(height: 8.h),
          Text('Nothing yet. Start reading!', style:AppTextStyles.overline),
        ],
      ),
    );
  }
}