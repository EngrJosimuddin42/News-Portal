import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../controllers/create_post_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/nbot_controller.dart';
import '../../controllers/reels/reels_controller.dart';
import '../../controllers/social_interaction_controller.dart';
import '../../models/news_model.dart';
import '../../models/reel_model.dart';
import '../../routes/app_pages.dart';
import '../../widgets/bottom_sheet_handle.dart';
import '../ai/nbot_sheet.dart';
import '../trends/share_sheet.dart';

class NewsBottomSheets {
  static void showMoreSheet(BuildContext context, NewsModel news) {
    final socialCtrl = Get.find<SocialInteractionController>();
    final controller = Get.find<HomeController>();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.62,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF252525) : const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const BottomSheetHandle(),
                  SizedBox(height: 20.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.h),
                    child: Row(
                      children: [
                        _topActionCard(
                          context: context,
                          icon: Icons.bookmark_border,
                          label: 'save',
                          onTap: () {
                            Get.back();
                            if (controller.isLoggedIn) {
                              socialCtrl.onSaveNews(news);
                            } else {
                              Get.toNamed(Routes.SIGNIN);
                            }
                          },
                        ),
                        SizedBox(width: 10.w),

                        _topActionCard(
                          context: context,
                          assetPath: AppAssets.shareIcon,
                          label: 'share',
                          onTap: () {
                            Get.back();
                            if (!Get.isRegistered<ReelsController>()) {
                              Get.put(ReelsController());
                            }
                            Future.microtask(() {
                              if (!context.mounted) return;
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => ShareSheet(
                                  isProfileShare: true,
                                  reel: ReelModel(
                                    id: news.id,
                                    userName: news.publisherName,
                                    description: news.title,
                                    userProfileImage: news.publisherImageUrl,
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                        SizedBox(width: 10.w),

                        _topActionCard(
                          context: context,
                          assetPath: AppAssets.featherIcon,
                          label: 'short_post',
                          onTap: () {
                            Get.back();
                            if (Get.isRegistered<CreatePostController>()) {
                              Get.find<CreatePostController>().resetAll();
                            }
                            Get.toNamed(Routes.CREATE_POST, arguments: news);
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.h),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(12.r)),
                      child: Column(
                        children: [
                          _optionTile(
                            icon: Icons.block_flipped,
                            iconColor: AppColors.white,
                            label: 'Block source: ${news.publisherName}',
                            labelColor: AppColors.white,
                            onTap: () {
                              controller.hideNews(news);
                              Get.until((route) => route.settings.name == Routes.HOME);
                            },
                          ),
                          Divider(color: AppColors.divider, height: 1, indent: 16, endIndent: 16),
                          _optionTile(icon: Icons.report_gmailerrorred, iconColor: AppColors.red, label: 'Report', labelColor: AppColors.red, onTap: () {}),
                          Divider(color: AppColors.divider, height: 1, indent: 16, endIndent: 16),
                          _optionTile(icon: Icons.report_gmailerrorred, iconColor: AppColors.red, label: 'Report Ad', labelColor: AppColors.red, onTap: () {}),
                          Divider(color: AppColors.divider, height: 1, indent: 16, endIndent: 16),
                          _optionTile(icon: Icons.report_gmailerrorred, iconColor: AppColors.red, label: 'Try Ad-free', labelColor: AppColors.red, onTap: () {}),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.h),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBg,
                        border: Border.all(
                          color: isDark ? Colors.black : const Color(0xFFEDEDED)),
                        borderRadius: BorderRadius.circular(8.r)),
                      child: _optionTile(
                        isAiIcon: true,
                        label: 'ask_request_report',
                        labelColor: AppColors.textOnDark,
                        onTap: () {
                          Get.back();
                          if (!Get.isRegistered<NBotController>()) {
                            Get.lazyPut(() => NBotController());
                          }
                          Future.microtask(() {
                            showModalBottomSheet(
                              context: Get.context!,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(Get.context!).size.width,
                                maxHeight: MediaQuery.of(Get.context!).size.height * 0.84,
                              ),
                              builder: (_) => const NBotSheet(),
                            );
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: bottomPadding > 0 ? bottomPadding + 8.h : 20.h),
                ],
              ),
            ),
        ),
      ),
    );
  }

  static Widget _topActionCard({
    required BuildContext context,
    IconData? icon,
    String? assetPath,
    required String label,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = isDark ? const Color(0xFF444444) : const Color(0xFFFFFFFF);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 70.h,
          decoration: BoxDecoration(
            color: cardColor,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              assetPath != null
                  ? SvgPicture.asset(
                assetPath,
                width: 28.w,
                height: 28.h,
                colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn))
                  : Icon(icon, color: AppColors.white, size: 28.sp),
              SizedBox(height: 8.h),
              Text(label.tr, style: AppTextStyles.labelMedium.copyWith(color: AppColors.white)),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _optionTile({
    IconData? icon,
    String? svgPath,
    Color iconColor = Colors.white,
    required String label,
    Color labelColor = Colors.white,
    required VoidCallback onTap,
    bool isAiIcon = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
      horizontalTitleGap: 10.w,
      leading: isAiIcon
          ? ShaderMask(
        shaderCallback: (Rect bounds) => AppColors.aiGradient.createShader(bounds),
        child: SvgPicture.asset(
          AppAssets.starIcon,
          width: 18.w,
          height: 18.h,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      )
          : (svgPath != null
          ? SvgPicture.asset(
        svgPath,
        width: 20.w,
        height: 20.h,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn))
          : (icon != null ? Icon(icon, color: iconColor, size: 20.sp) : null)),
      title: Text(label.tr, style: AppTextStyles.caption.copyWith(color: labelColor,letterSpacing: 0,height: 1.0,fontSize: 13.sp)),
      onTap: onTap,
      dense: true,
    );
  }
}