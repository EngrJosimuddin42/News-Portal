import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import 'package:news_break/app/widgets/bottom_sheet_handle.dart';

import '../../../controllers/me/settings/settings_controller.dart';

class SendFeedbackSheet extends StatefulWidget {
  const SendFeedbackSheet({super.key});

  @override
  State<SendFeedbackSheet> createState() => _SendFeedbackSheetState();
}

class _SendFeedbackSheetState extends State<SendFeedbackSheet> {
  final TextEditingController _feedbackController = TextEditingController();
  int _rating = 3;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();
    return Container(
      decoration:BoxDecoration(
        color: AppColors.surfaceBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 30, top: 10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Handle
          const BottomSheetHandle(),
           SizedBox(height: 16.h),

          // Title
          Center(
            child: Text('Share your feedback',style: AppTextStyles.displaySmall
                .copyWith(fontWeight: FontWeight.w700))),
           SizedBox(height: 16.h),

          // Star rating
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () => setState(() => _rating = i + 1),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: SvgPicture.asset(
                      i < _rating
                          ? AppAssets.star1Icon
                          : AppAssets.star2Icon,
                      width: 32.w,
                      height: 32.h)),
                );
              }),
            ),
          ),

           SizedBox(height: 20.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                Text('Write your feedback', style: AppTextStyles.overline.copyWith(fontSize: 14.sp)),
                SizedBox(height: 12.h),

                // Text area
                Container( height: 130.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFEDEDED)),
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.white),
                  child: TextField(
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _feedbackController,
                    maxLines: null,
                    expands: true,
                    style:AppTextStyles.overline.copyWith(color: Colors.black,fontSize: 14.sp),
                    decoration: InputDecoration(
                      hintText: 'Write your feedback here...',
                      hintStyle: AppTextStyles.overline.copyWith(color: Color(0xFFB7B7B7)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12.w)))),
              ],
            ),
          ),
           SizedBox(height: 16.h),

          // Send button
          Center(
            child: SizedBox( width: 335.w, height: 48.h,
                child: Obx(() => ElevatedButton(
                onPressed: settingsController.isFeedbackLoading.value
                    ? null
                    : () {
                  settingsController.sendFeedback(
                    comment: _feedbackController.text,
                    rating: _rating);
                },
              style: ElevatedButton.styleFrom(
                backgroundColor:Color(0xFF7B83EB),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r))),
              child: Text('Send Feedback', style:AppTextStyles.bodySmall.copyWith(color:Colors.white)))))),
          SizedBox(height: 16.h)
        ],
      ),
    );
  }
}