import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import 'package:news_break/app/widgets/bottom_sheet_handle.dart';
import '../../controllers/nbot_controller.dart';

class NBotSheet extends GetView<NBotController> {
  const NBotSheet({super.key});

  @override
  Widget build(BuildContext context) {
    
    if (!Get.isRegistered<NBotController>()) {
      Get.put(NBotController());
    }


    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.84,
      decoration: BoxDecoration(
          color: AppColors.sheet,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      child: Column(
        children: [
          const BottomSheetHandle(),

          Expanded(
            child: SingleChildScrollView(
              controller: controller.scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Image.asset('assets/images/nbot.png', width: 80.w, height: 80.h),
                   SizedBox(height: 16.h),
                  Text('nbot_title'.tr, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white)),
                  SizedBox(height:32.h),
                  Obx(() => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.chatMessages.length,
                    itemBuilder: (context, index) {
                      var chat = controller.chatMessages[index];
                      bool isUser = chat['sender'] == 'user';
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                          padding:  EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.blueGrey[700] : const Color(0xFF383838),
                            borderRadius: BorderRadius.circular(15.r)),
                          child: Text(chat['message']!, style: TextStyle(color:AppColors.white))));
                    },
                  )),

                   SizedBox(height: 170.h),

                  // Suggestions Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('people_also_ask'.tr, style: AppTextStyles.overline),
                         SizedBox(height: 16.h),
                        Obx(() => Wrap( spacing: 14,  runSpacing: 14,
                          children: controller.suggestions.map((s) => GestureDetector(
                            onTap: () => controller.onSuggestionTap(s),
                            child: Container(
                                padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                    color: Get.isDarkMode? Color(0xFF383838):Colors.white,
                                    border: Border.all(color: AppColors.border),
                                    borderRadius: BorderRadius.circular(60.r)),
                                child: Text(s, style: AppTextStyles.labelMedium.copyWith(color: AppColors.white,letterSpacing: 0,height: 1.0))),
                          )).toList(),
                        )),
                      ],
                    ),
                  ),
                   SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

          // Input bar
          Padding(
            padding: EdgeInsets.only( left: 16.w, right: 16.w,
                bottom: MediaQuery.of(context).viewInsets.bottom + 30),
            child: Container(
              padding:EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(30.r)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.textController,
                        enableSuggestions: false,
                        autocorrect: false,
                      style: AppTextStyles.overline,
                      decoration: InputDecoration(
                        hintText:  'ask_request_report'.tr,
                        hintStyle: AppTextStyles.overline.copyWith(letterSpacing: 0,height: 1.0),
                        border: InputBorder.none))),
                  Obx(() => GestureDetector(
                    onTap: controller.isResponding.value
                        ? null
                        : () => controller.sendMessage(),
                    child: controller.isResponding.value
                        ?  SizedBox( width: 32.w, height: 32.h,
                      child: Padding(
                        padding: EdgeInsets.all(6.w),
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.green)))
                        : SvgPicture.asset(
                        Get.isDarkMode ? AppAssets.send2Icon : AppAssets.sendIcon,
                          width: 32.w,
                          height: 32.h,
                          colorFilter: ColorFilter.mode( Color(0xFFB8B8B8), BlendMode.srcIn)),
                  )),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h)
        ],
      ),
    );
  }
}