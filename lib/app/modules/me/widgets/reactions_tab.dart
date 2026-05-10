import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../controllers/reels/reels_controller.dart';
import '../../../controllers/auth/auth_controller.dart';
import '../../../controllers/social_interaction_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/network_or_file_image.dart';
import '../../trends/player/full_screen_video_player.dart';

class ReactionsTab extends StatelessWidget {
  final dynamic user;
  final ReelsController controller;
  final bool isFullActivity;

  const ReactionsTab({
    super.key,
    required this.user,
    required this.controller,
    this.isFullActivity = false,
  });

  @override
  Widget build(BuildContext context) {
    final String profileOwnerName = user?.userName ?? '';
    final authCtrl = Get.find<AuthController>();
    final String loginUserName = authCtrl.user.value?.userName ?? '';
    final String loginName = authCtrl.user.value?.name ?? '';

    final bool isMyProfile = profileOwnerName == loginUserName;
    final socialCtrl = Get.find<SocialInteractionController>();
    String currentTime = DateFormat('EEEE h:mm a').format(DateTime.now());

    return Obx(() {
      //  Reels Filter Logic
      final reactedReels = controller.reelsList.where((reel) {
        final String effectiveKey = (reel.userName == loginUserName || reel.userName == loginName || reel.userName == 'Me')
            ? 'user_post_${reel.id}'
            : 'reel_${reel.id}';

        if (isMyProfile) {
          if (reel.userName == loginUserName || reel.userName == loginName || reel.userName == 'Me') return false;
          final bool isLikedByMe = socialCtrl.likedIds.contains(effectiveKey);
          final bool hasCommentedByMe = socialCtrl.commentList.any((c) =>
          c.reelId == reel.id && (c.userName == loginUserName || c.userName == loginName));
          return isLikedByMe || hasCommentedByMe;
        } else {
          if (reel.userName == profileOwnerName) return false;
          final bool isLikedByOwner = socialCtrl.likedIds.contains(effectiveKey);
          final bool commentedByOwner = socialCtrl.commentList.any((c) =>
          c.reelId == reel.id && c.userName == profileOwnerName);
          return isLikedByOwner || commentedByOwner;
        }
      }).toList();

      // News Filter Logic
      List reactedNews = [];
      if (isFullActivity || isMyProfile) {
        final allRelatedNews = [ ...socialCtrl.likedNewsMap.values, ...socialCtrl.commentedNewsItems];
        final uniqueNewsIds = <int>{};
        final uniqueNewsList = <dynamic>[];

        for (var n in allRelatedNews) {
          if (uniqueNewsIds.add(n.id)) {
            uniqueNewsList.add(n);
          }
        }

        reactedNews = uniqueNewsList.where((news) {
          final String newsKey = (news.author == loginUserName || news.author == loginName || news.author == 'Me')
              ? 'user_post_${news.id}'
              : 'news_${news.id}';

          if (isMyProfile) {
            if (news.author == loginUserName || news.author == loginName || news.author == 'Me') return false;
            final bool isLikedByMe = socialCtrl.likedIds.any((key) => key.endsWith('_${news.id}'));
            final bool hasCommentedByMe = socialCtrl.commentList.any((c) =>
            c.newsId == news.id && (c.userName == loginUserName || c.userName == loginName));
            return isLikedByMe || hasCommentedByMe;
          } else {
            final bool isLikedByOwner = socialCtrl.likedIds.contains(newsKey);
            final bool commentedByOwner = socialCtrl.commentList.any((c) =>
            c.newsId == news.id && c.userName == profileOwnerName);
            return isLikedByOwner || commentedByOwner;
          }
        }).toList();
      }

      final staticReactions = user?.userReactions ?? [];
      if (reactedReels.isEmpty && reactedNews.isEmpty && staticReactions.isEmpty) {
        return _buildEmptyState();
      }

      return SingleChildScrollView(
        child: Column(
          children: [

            // Reels UI
            ...reactedReels.map((reel) {
              final String uiKey = (reel.userName == loginUserName || reel.userName == loginName || reel.userName == 'Me')
                  ? 'user_post_${reel.id}'
                  : 'reel_${reel.id}';
              final bool isLiked = socialCtrl.likedIds.contains(uiKey);
              final String targetUser = isMyProfile ? loginUserName : profileOwnerName;
              final bool hasComment = socialCtrl.commentList.any((c) =>
              c.reelId == reel.id && (c.userName == targetUser || (isMyProfile && (c.userName == loginName || c.userName == loginUserName))));

              return _buildItemFromData(
                isLiked: isLiked,
                hasComment: hasComment,
                userName: profileOwnerName,
                time: currentTime,
                title: reel.description,
                imageUrl: reel.imageUrl,
                isVideo: true,
                onTap: () => Get.to(() => FullScreenVideoPlayer(url: reel.videoUrl ?? ''), arguments: reel),
              );
            }),

            // News UI
            ...reactedNews.map((news) {
              final bool isLiked = socialCtrl.likedIds.any((key) => key.endsWith('_${news.id}'));
              final String targetUser = isMyProfile ? loginUserName : profileOwnerName;
              final bool hasComment = socialCtrl.commentList.any((c) =>
              c.newsId == news.id && (c.userName == targetUser || (isMyProfile && (c.userName == loginName || c.userName == loginUserName))));

              final bool newsHasVideo = news.videoUrl != null && news.videoUrl!.isNotEmpty;

              return _buildItemFromData(
                isLiked: isLiked,
                hasComment: hasComment,
                userName: profileOwnerName,
                time: currentTime,
                title: news.title,
                imageUrl: news.imageUrl,
                isVideo: newsHasVideo,
                onTap: () {
                  if (newsHasVideo) {
                    Get.to(() => FullScreenVideoPlayer(url: news.videoUrl!));
                  } else {
                    Get.toNamed(
                      Routes.NEWS_DETAIL,
                      arguments: {
                        'news': news,
                        'tabType': 'news',
                      },
                    );
                  }
                },
              );
            }),

            // Static Reactions
            ...staticReactions.map<Widget>((res) {
              final bool staticHasVideo = res['videoUrl'] != null && res['videoUrl'].toString().isNotEmpty;
              return _buildReactionItem(
                userName: profileOwnerName,
                reactionText: 'reacted',
                reactionIcon: _buildSingleIcon(Icons.thumb_up, Colors.blue),
                time: res['time'] ?? '',
                title: res['title'] ?? '',
                imageUrl: res['imageUrl'] ?? '',
                isVideo: staticHasVideo,
                onTap: () {
                  if(staticHasVideo) {
                    Get.to(() => FullScreenVideoPlayer(url: res['videoUrl']));
                  }
                },
              );
            }),
          ],
        ),
      );
    });
  }

  //  Helper Methods
  Widget _buildItemFromData({
    required bool isLiked,
    required bool hasComment,
    required String userName,
    required String time,
    required String title,
    required String imageUrl,
    required bool isVideo,
    required VoidCallback onTap,
  }) {
    String text = 'reacted';
    Widget icon = const SizedBox.shrink();

    if (isLiked && hasComment) {
      text = 'liked & commented';
      icon = _buildDualIcon(Icons.thumb_up, Icons.comment, Colors.blue, Colors.green);
    } else if (isLiked) {
      text = 'liked';
      icon = _buildSingleIcon(Icons.thumb_up, Colors.blue);
    } else if (hasComment) {
      text = 'commented';
      icon = _buildSingleIcon(Icons.comment, Colors.green);
    }

    return _buildReactionItem(
      userName: userName,
      reactionText: text,
      reactionIcon: icon,
      time: time,
      title: title,
      imageUrl: imageUrl,
      isVideo: isVideo,
      onTap: onTap,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Column(
          children: [
            Text('No Reactions', style: AppTextStyles.bodyMedium),
             SizedBox(height: 8.h),
            Text("This user hasn't reacted to anything yet.",
                textAlign: TextAlign.center, style: AppTextStyles.overline),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionItem({
    required String userName,
    required String reactionText,
    required Widget reactionIcon,
    required String time,
    required String title,
    required String imageUrl,
    required bool isVideo,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 16.r, backgroundImage: NetworkImage(user?.userProfileImage ?? "")),
           SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(userName, style: AppTextStyles.textSmall.copyWith(color: AppColors.secondary)),
                     SizedBox(width: 6.w),
                    Text(reactionText, style: AppTextStyles.display.copyWith(color: AppColors.secondary)),
                    SizedBox(width: 6.w),
                    reactionIcon,
                  ],
                ),
                Text(time, style: AppTextStyles.display.copyWith(color: AppColors.textOnDark)),
                 SizedBox(height: 8.h),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Get.isDarkMode?const Color(0xFF333333):Color(0xFFEDEDED)),
                        color:Get.isDarkMode?const Color(0xFF333333):Colors.white, borderRadius: BorderRadius.circular(6.r)),
                    child: Row(
                      children: [
                        Expanded(child: Padding(padding:  EdgeInsets.all(12.w),
                            child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.textSmall))),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            NetworkOrFileImage(
                                url: imageUrl, width: 64.w, height: 48.h,
                                fit: BoxFit.cover,
                                borderRadius:  BorderRadius.only(topRight: Radius.circular(6.r), bottomRight: Radius.circular(6.r))),
                            if (isVideo)
                              Container(
                                padding:  EdgeInsets.all(2.w),
                                decoration: const BoxDecoration(
                                  color: Colors.black26,
                                  shape: BoxShape.circle,
                                ),
                                child:  Icon(Icons.play_arrow, color: Colors.white, size: 20.sp),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleIcon(IconData icon, Color color) {
    return Container(
      width: 16.w, height: 16.h,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 10.sp),
    );
  }

  Widget _buildDualIcon(IconData i1, IconData i2, Color c1, Color c2) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      _buildSingleIcon(i1, c1),
      const SizedBox(width: 2),
      _buildSingleIcon(i2, c2),
    ]);
  }
}