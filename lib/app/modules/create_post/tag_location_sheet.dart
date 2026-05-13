import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/widgets/bottom_sheet_handle.dart';
import '../../theme/app_text_styles.dart';
import '../../controllers/create_post_controller.dart';

class TagLocationSheet extends GetView<CreatePostController> {
  const TagLocationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color:AppColors.sheet,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
      child: Column(
        children: [
          const BottomSheetHandle(),

          // Search bar
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Expanded(
                  child: Container(height: 40.h,
                    decoration: BoxDecoration(
                        color:AppColors.card,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(10.r)),
                    child: TextField(
                      autofocus: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: controller.locationSearchController,
                      style:AppTextStyles.caption.copyWith(color: AppColors.textOnDark),
                      onChanged: (val) => controller.filterLocations(val),
                      decoration:InputDecoration(
                        hintText: 'Find Location',
                        hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textOnDark),
                        prefixIcon: Icon(Icons.search, color:AppColors.textOnDark, size: 18.sp),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10.h))))),
                 SizedBox(width: 12.w),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Text('Cancel', style:AppTextStyles.caption.copyWith(
                      color: Get.isDarkMode?Color(0xFF3498FA):Color(0xFF4DA4FB)))),
              ],
            ),
          ),

          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.filteredLocations.length,
              itemBuilder: (_, i) {
                final loc = controller.filteredLocations[i];
                return ListTile(
                  onTap: () => Get.back(result: loc),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
                  title: Text(loc['city']!, style: AppTextStyles.caption.copyWith(color:AppColors.white)),
                  subtitle: Text(loc['zip']!, style: AppTextStyles.overline),
                );
              },
            )),
          ),
        ],
      ),
    );
  }
}