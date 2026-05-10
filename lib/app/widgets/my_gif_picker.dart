import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class MyGifPicker extends StatelessWidget {
  final dynamic controller;

  const MyGifPicker({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery .of(context) .size .height * 0.9,
      decoration:  BoxDecoration(
          color: AppColors.scaffoldBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      child: SafeArea(
        bottom: true,
        child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 16.h, 8.w, 16.h),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      controller.isGifPickerMode.value = false;
                      controller.gifSearchQuery.value = '';
                    },
                    icon:Icon( Icons.close, color: AppColors.textOnDark, size: 20.sp)),
                Expanded(
                    child: Container(height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Get.isDarkMode?Color(0xFF121212):Color(0xFFEDEDED)),
                            color: Get.isDarkMode? const Color(0xFF121212):Colors.white,
                            borderRadius: BorderRadius.circular(8.r)),
                        child: TextField(
                            style: AppTextStyles.caption.copyWith( color: AppColors.textOnDark),
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (val) =>  controller.gifSearchQuery.value = val,
                            decoration: InputDecoration(
                                hintText: 'Search for GIFs',
                                hintStyle: AppTextStyles.caption.copyWith(  color: AppColors.textOnDark),
                                prefixIcon:  Icon( Icons.search, color: AppColors.textOnDark, size: 20.sp),
                                border: InputBorder.none,isDense: true)))),
                TextButton(
                    onPressed: () {
                      controller.isGifPickerMode.value = false;
                      controller.gifSearchQuery.value = '';
                    },
                    child: Text('Cancel', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textOnDark))),
              ],
            ),
          ),

          Expanded(
            child: Obx(() =>
                GridView.builder(
                  padding: EdgeInsets.all(16.w),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12),
                  itemCount: controller.filteredGifImages.length,
                  itemBuilder: (_, i) =>
                      GestureDetector(
                        onTap: () {
                          controller.selectGif(controller.filteredGifImages[i]);
                          controller.isGifPickerMode.value = false;
                          controller.gifSearchQuery.value = '';
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),  child: Image.network(
                          controller.filteredGifImages[i],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: Colors.grey[800]))))))),
        ],
      ),
    ),
    );
  }
}