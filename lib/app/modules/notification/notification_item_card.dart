import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../controllers/social_interaction_controller.dart';
import '../../models/comment_source.dart';
import '../../models/news_model.dart';
import '../../models/reel_model.dart';
import '../../models/socials_model.dart';
import '../../routes/app_pages.dart';
import '../../theme/app_assets.dart';
import '../../widgets/options_bottom_sheet.dart';
import '../trends/comments/write_comment_sheet.dart';
import '../trends/player/full_screen_video_player.dart';
import 'notification_report_sheet.dart';

class NotificationItemCard extends StatelessWidget {
  final dynamic item;

  const NotificationItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final socialCtrl = SocialInteractionController.to;


    String type = 'news';
    String title = '';
    String category = 'Trending';
    String publisher = 'Unknown';
    String time = '';
    String imageUrl = '';
    String videoUrl = '';
    dynamic id = 0;
    String shares = '0';
    String subtitle = '';

    if (item is NewsModel) {
      type = 'news';
      id = item.id;
      title = item.title;
      category = item.category;
      publisher = item.publisherName;
      time = item.formattedTime;
      imageUrl = item.imageUrl;
      videoUrl = item.videoUrl ?? '';
      shares = item.shares;
      subtitle = item.subtitle;
    } else if (item is ReelModel) {
      type = 'reel';
      id = item.id ?? 0;
      title = item.description;
      category = 'Reel';
      publisher = item.userName;
      time = item.formattedTime;
      imageUrl = item.imageUrl;
      videoUrl = item.videoUrl ?? '';
      shares = item.shares.toString();
    } else if (item is SocialsModel) {
      type = 'post';
      id = item.id;
      title = item.text;
      category = item.category;
      publisher = item.userName;
      time = item.formattedTime;
      imageUrl = item.imageUrls.isNotEmpty ? item.imageUrls[0] : '';
      shares = item.shares;
    }

    final bool hasVideo = videoUrl.isNotEmpty;

    return GestureDetector(
      onTap: () {
        if (hasVideo) {
          Get.to(() => FullScreenVideoPlayer(url: videoUrl));
        } else if (type == 'news') {
          Get.toNamed(Routes.NEWS_DETAIL, arguments: item);
        }
      },
      child: Container(
        color: Get.isDarkMode?Color(0xFF2C3C53):Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category, style: AppTextStyles.labelMedium.copyWith(color:Color(0xFFC2C2C2))),
                   SizedBox(height: 4.h),
                  Text(title, style: AppTextStyles.buttonOutline.copyWith(color: AppColors.white),
                      maxLines: 3, overflow: TextOverflow.ellipsis),
                   SizedBox(height: 6.h),
                  Text(subtitle, style: AppTextStyles.overline.copyWith(color:AppColors.subtitle)),
                   SizedBox(height: 6.h),
                  Row(children: [
                    SvgPicture.asset(AppAssets.typeIcon, width: 18.w, height: 18.h,colorFilter:ColorFilter.mode(AppColors.dot,BlendMode.srcIn)),
                     SizedBox(width: 6.w),
                    Text(publisher, style: AppTextStyles.buttonOutline.copyWith(color: AppColors.dot)),
                     SizedBox(width: 16.w),
                    SvgPicture.asset(AppAssets.timeIcon, width: 18.w, height: 18.h,colorFilter:ColorFilter.mode(AppColors.dot,BlendMode.srcIn)),
                     SizedBox(width: 6.w),
                    Text(time, style: AppTextStyles.buttonOutline.copyWith(color: AppColors.dot)),
                  ]),
                   SizedBox(height: 8.h),

                  _buildEngagementRow(context, socialCtrl, id, type, shares),
                ],
              ),
            ),
             SizedBox(width: 12.w),
            _buildRightSection(context, imageUrl, hasVideo, item),
          ],
        ),
      ),
    );
  }

  Widget _buildRightSection(BuildContext context, String imageUrl, bool hasVideo, dynamic currentItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Widget selectedReportSheet;

            if (currentItem is NewsModel) {
              selectedReportSheet = NotificationReportSheet(
                contentId: currentItem.id,
                contentType: 'news',
              );
            } else if (currentItem is ReelModel) {
              selectedReportSheet = NotificationReportSheet(
                contentId: currentItem.id ?? 0,
                contentType: 'reel',
              );
            } else {
              selectedReportSheet = const NotificationReportSheet();
            }

            OptionsBottomSheet.show(
              context,
              news: currentItem,
              reportSheet: selectedReportSheet,
            );
          },
          child:  Padding(
            padding: EdgeInsets.all(4.w),
            child: Icon(Icons.more_vert, color:AppColors.white, size: 20.sp),
          ),
        ),
        SizedBox(height: 8.h),
        Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: imageUrl.startsWith('http')
                  ? Image.network(imageUrl, width: 100.w, height: 70.h, fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _errorPlaceholder())
                  : _errorPlaceholder()),
            if (hasVideo)
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
                child: Icon(Icons.play_arrow, color: Colors.white, size: 20.sp),
              ),
          ],
        ),
      ],
    );
  }

  Widget _errorPlaceholder() =>
      Container(width: 100.w, height: 70.h, color: Colors.grey[800],
          child:  Icon(Icons.image, color: Colors.grey, size: 20.sp));

  Widget _buildEngagementRow(BuildContext context, SocialInteractionController socialCtrl, dynamic id, String type, String shareCount) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [

          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => WriteCommentSheet(
                  reelId: item,
                  type: type,
                  onlyEmoji: true,
                ),
              );
            },
            child: Obx(() {
              final reactionCount = (item is NewsModel) ? socialCtrl.getReactionCount(item, source: type).value : 0;

              return Row(
                children: [
                  SvgPicture.asset(AppAssets.reactionsIcon, width: 50.w, height: 20.h),
                  SizedBox(width: 6.w),
                  Text(socialCtrl.formatCount(reactionCount), style: AppTextStyles.button.copyWith(color: AppColors.dot)),
                ],
              );
            }),
          ),
           SizedBox(width: 16.w),
          _buildDot(AppColors.dot),
          SizedBox(width: 8.w),


          GestureDetector(
            onTap: () => socialCtrl.openComments(
              id,
              type == 'reel' ? CommentSource.reel : CommentSource.news,
              tabType: type,
              author: (item is NewsModel) ? item.author : null,
            ),
            child: Obx(() {

              final commentCount = (item is NewsModel) ? socialCtrl.getCommentCount(item, source: type).value : 0;
              return Text('${socialCtrl.formatCount(commentCount)} comments', style: AppTextStyles.button.copyWith(color: AppColors.dot));
            }),
          ),
           SizedBox(width: 16.w),
          _buildDot(AppColors.dot),
          SizedBox(width: 8.w),


          GestureDetector(
            onTap: () => socialCtrl.share(id: id, title: 'Check this out!', type: type),
            child: Text('$shareCount shares', style: AppTextStyles.button.copyWith(color: AppColors.dot)),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Text('•', style: AppTextStyles.button.copyWith(color: color));
  }
}