import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../controllers/reels/comment_controller.dart';
import '../../../controllers/social_interaction_controller.dart';
import '../../../widgets/report_success.dart';

class ReportCommentSheet extends StatefulWidget {
  const ReportCommentSheet({super.key});

  @override
  State<ReportCommentSheet> createState() => _ReportCommentSheetState();
}

class _ReportCommentSheetState extends State<ReportCommentSheet> {
  String? _selectedReason;
  int _step = 0;

  final socialCtrl = Get.find<SocialInteractionController>();
  final commentController = Get.find<CommentController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.sheet,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      child: _step == 0
          ? _buildReportBody()
          : ReportSuccess(onDone: () => Get.back()),
    );
  }

  Widget _buildReportBody() {
    final commentController = Get.find<CommentController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.fromLTRB(28.w, 24.h, 16.w, 16.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(Icons.arrow_back_ios, color: AppColors.surface, size: 20)),
              Expanded(
                child: Text('Report Comment', textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(color: AppColors.white))),
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(Icons.close, color: AppColors.white, size: 20.sp)),
            ],
          ),
        ),
        Divider(color:AppColors.border, height: 1),

        // Reasons
        Column(
          children: commentController.reportReasons.map((reason) {
            return RadioListTile<String>(
              value: reason,
              groupValue: _selectedReason,
              onChanged: (val) => setState(() => _selectedReason = val),
              title: Text(reason, style: AppTextStyles.caption.copyWith(color: AppColors.white)),
              activeColor:AppColors.white,
              dense: true,
            );
          }).toList(),
        ),

        // Submit button
        Padding(
          padding:EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          child: SizedBox(width: 311.w, height: 48.h,
            child: ElevatedButton(
                onPressed: () {
                  if (_selectedReason != null) {
                    socialCtrl.selectedReason.value = _selectedReason;
                    socialCtrl.reportContentId.value = 0;
                    socialCtrl.reportContentType.value = 'comment';
                    socialCtrl.submitReport();
                    setState(() => _step = 1);
                  }
                },
              style: ElevatedButton.styleFrom(
                backgroundColor:AppColors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
                padding: EdgeInsets.symmetric(vertical: 14.h)),
              child: Text('Submit', style: AppTextStyles.buttonOutline.copyWith(
                  color:Get.isDarkMode?Color(0xFF242424):Color(0xFFDBDBDB)))))),
        SizedBox(height: 6.h)
      ],
    );
  }
}