import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import 'package:news_break/app/widgets/bottom_sheet_handle.dart';
import '../../../controllers/reels/reels_controller.dart';
import '../../../controllers/social_interaction_controller.dart';

class OptionsSheet extends StatelessWidget {
  final dynamic reelId;
  final String authorName;

  const OptionsSheet({
    super.key,
    required this.reelId,
    required this.authorName,
  });

  @override
  Widget build(BuildContext context) {
    final reelsController = Get.find<ReelsController>();
    final socialCtrl = Get.find<SocialInteractionController>();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.sheet,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         BottomSheetHandle(),
          SizedBox(height: 24.h),
          Container(
            margin: EdgeInsets.only(left: 16.w, right: 16.w,
                bottom: MediaQuery.of(context).padding.bottom + 20),
            decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20.r)),
            child: Column(
              children: [
                _optionTile(
                    icon: Icons.copy,
                    iconColor: AppColors.white,
                    label: 'Copy link',
                    labelColor: AppColors.white,
                    onTap: () => reelsController.onShareOptionTap(reelId, 'Copy link')),
                _divider(),
                _optionTile(
                    icon: Icons.share_outlined,
                    iconColor: AppColors.white,
                    label: 'Share this content',
                    labelColor: AppColors.white,
                    onTap: () => reelsController.onShareOptionTap(reelId, 'More')),
                _divider(),
                _optionTile(
                    icon: Icons.block_flipped,
                    iconColor: AppColors.white,
                    label: 'Block : $authorName',
                    labelColor: AppColors.white,
                    onTap: () => socialCtrl.blockUser(authorName)),
                _divider(),
                _optionTile(
                    icon: Icons.report_gmailerrorred_outlined,
                    iconColor: Colors.red,
                    label: 'Report content',
                    labelColor: Colors.red,
                    showChevron: true,
                    onTap: () => reelsController.reportComment(reelId, context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return  Divider(
        color: AppColors.divider, height: 1, indent: 16, endIndent: 16);
  }

  Widget _optionTile({
    required IconData icon,
    Color iconColor = Colors.white,
    required String label,
    Color labelColor = Colors.white,
    bool showChevron = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor, size: 20.sp),
      title: Text(label,
          style: AppTextStyles.caption.copyWith(color:labelColor)),
      trailing: showChevron
          ? Icon(Icons.chevron_right, color:AppColors.white, size: 20.sp)
          : null,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
    );
  }
}