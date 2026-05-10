import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import 'package:news_break/app/widgets/bottom_sheet_handle.dart';
import '../../controllers/reels/reels_controller.dart';
import '../../models/reel_model.dart';
import '../../widgets/publisher_avatar.dart';

class ShareSheet extends GetView<ReelsController> {
  final ReelModel reel;
  final bool isProfileShare;

  const ShareSheet({
    super.key,
    required this.reel,
    this.isProfileShare = false,
  });

  static const List<Map<String, dynamic>> _shareOptions = [
    {'label': 'Instagram', 'icon': Icons.camera_alt, 'isAsset': false},
    {'label': 'Share by Image', 'icon': Icons.image_outlined, 'isAsset': false},
    {'label': 'Copy link', 'icon': Icons.copy_outlined, 'isAsset': false},
    {'label': 'Facebook', 'icon': Icons.facebook, 'isAsset': false},
    {'label': 'Email', 'icon': Icons.email_outlined, 'isAsset': false},
    {'label': 'Text message', 'icon': AppAssets.messageIcon, 'isAsset': true},
    {'label': 'WhatsApp', 'icon': AppAssets.whatsappIcon, 'isAsset': true},
    {'label': 'Facebook messenger', 'icon': AppAssets.messengerIcon, 'isAsset': true},
    {'label': 'X', 'icon': AppAssets.xLogoIcon, 'isAsset': true},
    {'label': 'Facebook groups', 'icon':AppAssets.facebookGroupIcon, 'isAsset': true},
    {'label': 'More', 'icon': Icons.more_horiz, 'isAsset': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration:  BoxDecoration(
          color: AppColors.sheet,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             SizedBox(height: 40.h),
            const BottomSheetHandle(),
            SizedBox(height: 20.h),

            // Header
            Padding(
              padding:  EdgeInsets.fromLTRB(20.w,0.h,20.w,0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(controller.sendStoryLabel, style: AppTextStyles.caption.copyWith(color: AppColors.white)),
                  IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, color:AppColors.white, size: 20.sp)),
                ],
              ),
            ),

            // Preview Card
            Padding(
              padding: EdgeInsets.fromLTRB(20.w,0.h,20.w,20.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PublisherAvatar.fromUrl(
                      imageUrl: isProfileShare
                          ? reel.userProfileImage
                          : reel.imageUrl,
                      name: reel.userName,
                      size: isProfileShare ? 100 : 42,
                      shape: BoxShape.rectangle),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isProfileShare) ...[
                          Text(controller.mediaAccountLabel,
                              style: AppTextStyles.overline),
                           SizedBox(height: 4.h),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: controller.checkOutPrefix,
                                    style: AppTextStyles.small.copyWith(color: AppColors.white)),
                                TextSpan(
                                    text: reel.userName,
                                    style: AppTextStyles.labelMedium.copyWith(color: AppColors.textOnDark)),
                              ],
                            ),
                          ),
                        ] else ...[
                          Row(
                            children: [
                              PublisherAvatar.fromUrl(
                                  imageUrl: reel.userProfileImage,
                                  name: reel.userName,
                                  size: 20.sp),
                               SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  reel.userName,
                                  style: AppTextStyles.labelSmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: 8.h),
                          Text(reel.description,
                              style: AppTextStyles.small,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Share Options
            Flexible(
              child: Container(
                margin:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                    color: AppColors.search,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12.r)),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: _shareOptions.length,
                  separatorBuilder: (context, index) =>
                   Divider( color:AppColors.border,
                      height: 1,
                      indent: 16,
                      endIndent: 16),
                  itemBuilder: (context, index) {
                    final option = _shareOptions[index];
                    return InkWell(
                      borderRadius: index == 0
                          ?  BorderRadius.vertical(top: Radius.circular(12.r))
                          : index == _shareOptions.length - 1
                          ?  BorderRadius.vertical(bottom: Radius.circular(12.r))
                          : BorderRadius.zero,
                      onTap: () {
                        controller.onShareOptionTap(
                          reel.id ?? 0,
                          option['label'],
                          userName: reel.userName,
                          shareUrl: 'https://newsbreak.com/news/${reel.id}',
                        );
                      },
                      child: Padding(
                        padding:EdgeInsets.symmetric( horizontal: 16.w, vertical: 14.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(option['label'], style: AppTextStyles.caption.copyWith(color: AppColors.white)),
                            option['isAsset']
                                ? SvgPicture.asset(option['icon'] as String,
                                width: 20.w, height: 20.h, colorFilter:  ColorFilter.mode(AppColors.white, BlendMode.srcIn))
                                : Icon(option['icon'] as IconData,
                                color: AppColors.white, size: 20.sp),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}