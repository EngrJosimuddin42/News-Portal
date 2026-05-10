import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../controllers/notification/notification_controller.dart';
import '../controllers/social_interaction_controller.dart';
import '../models/news_model.dart';
import '../models/reel_model.dart';
import '../models/socials_model.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import 'bottom_sheet_handle.dart';

class OptionsBottomSheet {
  static void show(BuildContext context, {
    required dynamic news,
    required Widget reportSheet,
    VoidCallback? onReportClick,
  }) {
    final controller = Get.find<NotificationController>();
    final socialCtrl = Get.find<SocialInteractionController>();

    String author = '';
    String category = '';
    String publisher = '';

    if (news is NewsModel) {
      author = news.author;
      category = news.category;
      publisher = news.publisherName;
    } else if (news is ReelModel) {
      author = news.userName;
      category = 'Reels';
      publisher = news.userName;
    } else if (news is SocialsModel) {
      author = news.author;
      category = news.category;
      publisher = news.publisherName;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor:AppColors.sheet,
      isScrollControlled: true,
      shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (_) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BottomSheetHandle(),
             SizedBox(height: 16.h),

            Container(
              margin:  EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                border: Border.all(color:Get.isDarkMode?Color(0xFF444444):Color(0xFFEDEDED)),
                  color:AppColors.card,
                  borderRadius: BorderRadius.circular(12.r)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _optionTile(
                    icon: Icons.thumb_down_alt_outlined,
                    iconColor: AppColors.white,
                    title: 'Show less about: $author',
                    titleColor:AppColors.white,
                    onTap: () {
                      Get.back();
                      socialCtrl.showLessAboutAuthor(author);
                    },
                  ),
                  Divider(color: AppColors.border, height: 1, indent: 16, endIndent: 16),
                  _optionTile(
                    icon: Icons.thumb_up_alt_outlined,
                    iconColor: AppColors.white,
                    title: 'Show less about: $category',
                    titleColor:AppColors.white,
                    onTap: () {
                      Get.back();
                      socialCtrl.showLessAboutTopic(category);
                    },
                  ),

                  Divider(color: AppColors.border, height: 1, indent: 16, endIndent: 16),

                  _optionTile(
                    icon: Icons.block_flipped,
                    iconColor: AppColors.white,
                    title: 'Block source: $publisher',
                    titleColor:AppColors.white,
                    onTap: () {
                      Get.back();
                      socialCtrl.blockSource(publisher);
                    },
                  ),

                  Divider(color: AppColors.border, height: 1, indent: 16, endIndent: 16),

                  _optionTile(
                    icon: Icons.error_outline,
                    iconColor: Colors.red,
                    title: 'Report',
                    titleColor:AppColors.red,
                    onTap: () {
                      Get.back();
                      _showReportSheet(context, reportSheet);
                    },
                  ),
                ],
              ),
            ),
             SizedBox(height: 16.h),

            // Support/AI Request Container
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.h),
              decoration: BoxDecoration(
                  color:AppColors.scaffoldBg,
                  border: Border.all(color: Get.isDarkMode?Colors.black:Color(0xFFEDEDED)),
                  borderRadius: BorderRadius.circular(12.r)),
              child: _optionTile(
                isAiIcon: true,
                title: 'Ask/request/report anything',
                titleColor:AppColors.textOnDark,
                onTap: () {
                  Get.back();
                  controller.openSupportChat();
                },
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  static void _showReportSheet(BuildContext context, Widget reportSheet) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => reportSheet);
  }

  static Widget _optionTile({
    IconData? icon,
    String? svgPath,
    Color iconColor = Colors.white,
    required String title,
    Color titleColor = Colors.white,
    required VoidCallback onTap,
    bool isAiIcon = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            isAiIcon
                ? ShaderMask(
              shaderCallback: (Rect bounds) => AppColors.aiGradient.createShader(bounds),
              child: SvgPicture.asset(AppAssets.starIcon, width: 22.w, height: 22.h,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)))
                : (svgPath != null
                ? SvgPicture.asset( svgPath, width: 20.w, height: 20.h,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn))
                : Icon(icon, color: iconColor, size: 20.sp)),
             SizedBox(width: 12.h),
            Expanded(
              child: Text(title, style: AppTextStyles.caption.copyWith(color: titleColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
