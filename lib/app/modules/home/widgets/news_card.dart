
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import '../../../controllers/social_interaction_controller.dart';
import '../../../models/comment_source.dart';
import '../../../models/news_model.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/about_profile_sheet.dart';
import '../../../widgets/follow_button.dart';
import '../../../widgets/network_or_file_image.dart';
import '../../../widgets/publisher_avatar.dart';
import '../../trends/player/full_screen_video_player.dart';

class NewsCard extends StatefulWidget {
  final NewsModel news;
  final VoidCallback? onFollow;
  final VoidCallback? onDismiss;
  final String tabType;

  const NewsCard({
    super.key,
    required this.news,
    required this.tabType,
    this.onFollow,
    this.onDismiss,
  });

  @override
  State<NewsCard> createState() => _NewsCardState();
}
class _NewsCardState extends State<NewsCard> {
  bool _isExpanded = false;
  late final SocialInteractionController _socialCtrl;
  late final RxInt _commentCount;

  @override
  void initState() {
    super.initState();
    _socialCtrl = Get.find<SocialInteractionController>();
    _commentCount = _socialCtrl.getCommentCount(widget.news, source: widget.tabType);
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
          _buildPublisherRow(news),
           SizedBox(height: 24.h),

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
                _buildMediaSection(news, hasVideo),
                SizedBox(height: 16.h),
                _buildTitleSection(news),
              ],
            ),
          ),
          _buildActionRow(news),
           SizedBox(height: 16.h),
           Divider(color:AppColors.divider, height: 2, thickness: 3),
           SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildPublisherRow(NewsModel news) {
    final Color infoColor = AppColors.info;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PublisherAvatar.fromNews(news: news),
           SizedBox(width: 10.w),
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
                          style: AppTextStyles.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                 SizedBox(height: 8.h),
                Row(
                  children: [
                    SvgPicture.asset(AppAssets.locationIcon, height: 18.h, width: 18.w,
                        colorFilter: ColorFilter.mode(infoColor, BlendMode.srcIn)),
                     SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        news.publisherMeta,
                        style: AppTextStyles.overline.copyWith(color: AppColors.info),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1)),

                     SizedBox(width: 8.w),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(AppAssets.timeIcon, height: 18.h, width: 18.w,
                            colorFilter: ColorFilter.mode(infoColor, BlendMode.srcIn)),
                         SizedBox(width: 3.w),
                        Text( news.formattedTime.isNotEmpty
                                ? '${news.formattedTime[0].toUpperCase()}${news.formattedTime.substring(1)}'
                                : '',
                          style: AppTextStyles.overline.copyWith(color: AppColors.info))
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
           SizedBox(width: 8.w),

          FollowButton(news: news),

        ],
      ),
    );
  }

  Widget _buildTitleSection(NewsModel news) {
    return Padding(
      padding:  EdgeInsets.fromLTRB(20.w, 10.h, 16.w, 10.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textStyle = AppTextStyles.bodyMedium;
          final textPainter = TextPainter(
            text: TextSpan(text: news.title, style: textStyle),
            maxLines: 1,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: constraints.maxWidth);

          if (!textPainter.didExceedMaxLines) {
            return Text(news.title, style: textStyle);
          }

          return GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: _isExpanded
                ? Text(
              news.title,
              style: textStyle,
              softWrap: true,
              overflow: TextOverflow.visible)
                : RichText(
              text: TextSpan(
                style: textStyle,
                children: [
                  TextSpan(text: news.title),
                  TextSpan(
                    text: ' See more', style: textStyle.copyWith(color:Color(0xFFC4C4C4)),
                  ),
                ],
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMediaSection(NewsModel news, bool hasVideo) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 20.w),
      child: Stack(
        alignment: Alignment.center,
        children: [
          NetworkOrFileImage(
              url: news.imageUrl, height: 220.h, width: double.infinity),
          if (hasVideo)
            Container(
              padding:  EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                  color: Colors.black45, shape: BoxShape.circle),
              child:  Icon(Icons.play_arrow_rounded,
                  color: Colors.white, size: 40.sp),
            ),
        ],
      ),
    );
  }

  Widget _buildActionRow(NewsModel news) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: [
          _buildLikeButton(news),
           SizedBox(width: 24.w),
          _buildCommentButton(news),
        ],
      ),
    );
  }

  Widget _buildLikeButton(NewsModel news) {
    return Obx(() {
      final isLiked = _socialCtrl.isLiked(news, type: widget.tabType);
      final label = _socialCtrl.getAdjustedNewsLikes(news, type: widget.tabType);
      final Color unlikedColor = AppColors.white;
      final Color likedColor = Colors.blue;

      return GestureDetector(
        onTap: () => _socialCtrl.toggleLike(news, type: widget.tabType),
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AppAssets.likeIcon, width: 20.w, height: 20.h,
              colorFilter: ColorFilter.mode( isLiked ? likedColor : unlikedColor,BlendMode.srcIn)),
             SizedBox(width: 6.w),
            Text(label,
              style: AppTextStyles.bodySmall.copyWith(color: isLiked ? likedColor : AppColors.white),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCommentButton(NewsModel news) {
    final Color iconColor = AppColors.white;

    return GestureDetector(
      onTap: () => _socialCtrl.openComments(
          news.id, CommentSource.news, tabType: widget.tabType, author: news.author, news: news),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(AppAssets.commentIcon, width: 20.w, height: 20.h,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn)),
           SizedBox(width: 6.w),
          Obx(() => Text(
            _socialCtrl.formatCount(_commentCount.value),
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
          )),
        ],
      ),
    );
  }
}