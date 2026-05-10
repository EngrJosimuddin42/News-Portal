import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../controllers/edit_tabs_controller.dart';

class EditTabsView extends GetView<EditTabsController> {
  const EditTabsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        leading: TextButton(
          onPressed: controller.onCancel,
          child: Text('Cancel', style: AppTextStyles.caption.copyWith(color:AppColors.white))),
        leadingWidth: 80.w,
        title: Text('Edit Top Tabs', style: AppTextStyles.headlineSmall.copyWith(color: AppColors.white)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: controller.onSave,
            child: Text('Save', style: AppTextStyles.caption.copyWith(color: AppColors.white))),
        ],
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You can add or remove your top tabs here. These changes will not affect your main feed.',
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.white)),
             SizedBox(height: 24.h),

            Text('Select Topics', style: AppTextStyles.labelMedium.copyWith(color: AppColors.white)),
             SizedBox(height: 12.h),

            Obx(() => Column(
              children: controller.selectedTopics.map((topic) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: GestureDetector(
                    onTap: () => controller.removeFromSelected(topic),
                    child: SvgPicture.asset(Get.isDarkMode ? AppAssets.removeIcon : AppAssets.remove1Icon,width: 24.w, height: 24.h)),
                  title: Text(topic, style: AppTextStyles.bodyMedium),
                );
              }).toList(),
            )),

             SizedBox(height: 16.h),
            Text('All Topics', style: AppTextStyles.labelMedium.copyWith(color: AppColors.white)),
            SizedBox(height: 12.h),

            Obx(() => Column(
              children: controller.allTopics.map((topic) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: GestureDetector(
                    onTap: () => controller.addToSelected(topic),
                      child: SvgPicture.asset(Get.isDarkMode ? AppAssets.addIcon : AppAssets.add1Icon,width: 24.w, height: 24.h)),
                  title: Text(topic, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white)),
                );
              }).toList(),
            )),
          ],
        ),
    ),
      bottomNavigationBar: Container(
        height: 25.h,
        color: AppColors.surfaceBg,
        child: SafeArea(
          top: false,
          child: const SizedBox.shrink(),
        ),
      ),
    );
  }
}