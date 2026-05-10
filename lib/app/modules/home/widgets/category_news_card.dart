import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/social_interaction_controller.dart';
import '../../../models/comment_source.dart';
import '../../../models/news_model.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/about_profile_sheet.dart';
import '../../../widgets/follow_button.dart';
import '../../../widgets/network_or_file_image.dart';
import '../../../widgets/publisher_avatar.dart';
import '../../trends/comments/write_comment_sheet.dart';
import '../../trends/player/full_screen_video_player.dart';


class CategoryNewsCard extends StatefulWidget {
  final NewsModel news;
  final String tabType;

  const CategoryNewsCard({
    super.key,
    required this.news,
    required this.tabType,
  });

  @override
  State<CategoryNewsCard> createState() => _CategoryNewsCardState();
}

class _CategoryNewsCardState extends State<CategoryNewsCard> {
  late final SocialInteractionController _socialCtrl;
  late final HomeController _controller;
  late final RxInt _commentCount;

  // initState
  @override
  void initState() {
    super.initState();
    _socialCtrl = Get.find<SocialInteractionController>();
    _controller = Get.find<HomeController>();
    _commentCount = _socialCtrl.getCommentCount(widget.news, source: widget.tabType);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _socialCtrl.initFollowerCount(widget.news);
    });
  }

  @override
  Widget build(BuildContext context) {
    final news = widget.news;
    final bool hasVideo = news.videoUrl != null && news.videoUrl!.isNotEmpty;

    return Container(
      color: AppColors.scaffoldBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _buildHeader(context),

          GestureDetector(
            onTap: () {
              if (hasVideo) {
                Get.to(() => FullScreenVideoPlayer(url: news.videoUrl!));
              } else {
                Get.toNamed(Routes.NEWS_DETAIL, arguments: {
                  'news': news,
                  'tabType': widget.tabType,
                });
              }
            },

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _buildMedia(hasVideo),

                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 12.h, 12.w, 4.h),
                  child: Row(
                    children: [

                      SvgPicture.asset(AppAssets.personIcon, height: 18.h, width: 18.w,
                        colorFilter: ColorFilter.mode(AppColors.info, BlendMode.srcIn)),
                       SizedBox(width: 4.w),
                      Flexible(
                          child: Text(news.category, style: AppTextStyles.overline.copyWith(color: AppColors.info),
                              overflow: TextOverflow.ellipsis, maxLines: 1)),
                       SizedBox(width: 18.w),

                      SvgPicture.asset(AppAssets.locationIcon, height: 18.h, width: 18.w,
                        colorFilter: ColorFilter.mode(AppColors.info, BlendMode.srcIn)),
                       SizedBox(width: 4.w),
                      Flexible(
                          child: Text(news.publisherMeta,
                              style: AppTextStyles.overline.copyWith(color: AppColors.info),
                              overflow: TextOverflow.ellipsis, maxLines: 1)),
                       SizedBox(width: 18.w),

                      SvgPicture.asset(AppAssets.timeIcon, height: 18.h, width: 18.w,
                        colorFilter: ColorFilter.mode(AppColors.info, BlendMode.srcIn)),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          news.formattedTime.isNotEmpty
                              ? '${news.formattedTime[0].toUpperCase()}${news.formattedTime.substring(1)}'
                              : '',
                          style: AppTextStyles.overline.copyWith(color: AppColors.info),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1)),
                    ],
                  ),
                ),


                Padding(
                    padding:EdgeInsets.fromLTRB(20.w, 0.h, 12.w, 10.h),
                    child: Text(news.title, style: AppTextStyles.button.copyWith(color: AppColors.white),
                        maxLines: 1, overflow: TextOverflow.ellipsis)),
                Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 0.h, 12.w, 12.h),
                    child: Text(news.subtitle, style: AppTextStyles.labelMedium.copyWith(color: AppColors.white),
                        maxLines: 3, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),

          _buildEngagementRow(context),

           SizedBox(height: 4.h),
          Divider(color:AppColors.divider, height: 2, thickness: 3),
          SizedBox(height: 18.h),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final news = widget.news;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ← Follow + Close
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FollowButton(news: news),
              SizedBox(width: 36.w),
              GestureDetector(
                onTap: () => _controller.hideNews(news),
                child: Icon(Icons.close, color: const Color(0xFF6C6C6C), size: 20.sp),
              ),
            ],
          ),

          // ← Avatar + Name + Followers Row
          Row(
            children: [
              PublisherAvatar.fromNews(news: news),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () => AboutProfileSheet.showFromNews(context, news),
                            child: Text(
                              news.publisherName,
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        if (news.isVerified) ...[
                          SizedBox(width: 6.w),
                          SvgPicture.asset(AppAssets.verifiedIcon,
                              width: 20.w, height: 20.h,
                              colorFilter: ColorFilter.mode(AppColors.verify, BlendMode.srcIn)),
                        ],
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Obx(() {
                      final count = _socialCtrl.followerCounts[news.id]
                          ?? news.totalFollowers
                          ?? '0';
                      return Text(
                        '${news.publisherType ?? ""} · $count followers',
                        style: AppTextStyles.overline.copyWith(color: AppColors.textTertiary),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedia(bool hasVideo) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          NetworkOrFileImage(url: widget.news.imageUrl),
          if (hasVideo)
            Center(
              child: Container(
                width: 45.w, height: 45.h,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.play_arrow_rounded,
                    color: Colors.white, size: 35),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEngagementRow(BuildContext context) {
    final news = widget.news;
    return Padding(
      padding:EdgeInsets.fromLTRB(24.w, 0.h, 12.w, 16.h),
      child: Row(
        children: [

          Expanded(
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) =>
                      WriteCommentSheet(reelId: news, onlyEmoji: true,type: widget.tabType,author: news.author),
                );
              },
              child: Obx(() {
                final int liveReactionCount =
                    _socialCtrl.getReactionCount(news, source: widget.tabType).value;

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(AppAssets.reactionsIcon, width: 50.w, height: 20.h),
                     SizedBox(width: 4.w),
                    Flexible(
                      child: Text(_socialCtrl.formatCount(liveReactionCount),
                          style: AppTextStyles.labelMedium.copyWith(color: AppColors.white),
                          overflow: TextOverflow.ellipsis, maxLines: 1),
                    ),
                  ],
                );
              }),
            ),
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 60.w,
                child: Obx(() {
                  final isLiked = _socialCtrl.isLiked(news, type: widget.tabType);
                  final Color likedColor = Colors.blue;
                  return GestureDetector(
                    onTap: () => _socialCtrl.toggleLike(news, type: widget.tabType),
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(AppAssets.likeIcon, width: 20.w, height: 20.h,
                            colorFilter: ColorFilter.mode( isLiked ? likedColor : AppColors.white,BlendMode.srcIn)),
                         SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            _socialCtrl.getAdjustedNewsLikes(news, type: widget.tabType),
                            style: AppTextStyles.labelMedium.copyWith( color: isLiked ? Colors.blue : AppColors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              SizedBox(width: 16.w),

              SizedBox(
                width: 55.w,
                child: GestureDetector(
                  onTap: () => _socialCtrl.openComments(
                      news.id, CommentSource.news, tabType: widget.tabType, author: news.author, news: news),
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(AppAssets.commentIcon, width: 20.w, height: 20.h,
                          colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn)),
                       SizedBox(width: 4.w),
                      Flexible(
                        child: Obx(() => Text(
                          _socialCtrl.formatCount(_commentCount.value),
                          style: AppTextStyles.labelMedium.copyWith(color: AppColors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )),
                      ),
                    ],
                  ),
                ),
              ),

               SizedBox(width: 16.w),

              GestureDetector(
                onTap: () => _socialCtrl.share(
                    id: news.id, title: news.title, type: 'news'),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(AppAssets.shareIcon, width: 20.w, height: 20.h,
                        colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn)),
                     SizedBox(width: 4.w),
                    Text('Share', style: AppTextStyles.labelMedium.copyWith(color: AppColors.white)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}