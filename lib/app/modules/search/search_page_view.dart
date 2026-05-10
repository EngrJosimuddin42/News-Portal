import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../controllers/search_page_controller.dart';

class SearchPageView extends GetView<SearchPageController> {
  const SearchPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchPageController controller = Get.isRegistered<SearchPageController>()
        ? Get.find<SearchPageController>()
        : Get.put(SearchPageController());

    return Scaffold(
      backgroundColor:AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopSearchBar(controller),

            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
              child: Text('Trending', style: AppTextStyles.button.copyWith(color: AppColors.white))),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 16.h),
                  child: Container(
                    decoration: BoxDecoration(
                      color:Get.isDarkMode? Color(0xFF0B0B0B):Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Get.isDarkMode? Color(0xFF737373):Color(0xFFEDEDED))),
                    padding:  EdgeInsets.all(8.w),
                    child: Column(
                      children: [
                        _buildInternalFilterField(controller),
                         SizedBox(height: 8.h),

                        Obx(() {
                          final items = controller.filteredResult;
                          if (items.isEmpty) {
                            return  Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: Center(
                                child: Text("No results found", style: TextStyle(color:AppColors.textOnDark))),
                            );
                          }
                          return Column(
                            children: items.map((item) => _buildItemCard(controller, item)).toList(),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSearchBar(SearchPageController controller) {
    return Padding(
      padding:  EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios, color: AppColors.textOnDark, size: 20.sp)),
           SizedBox(width: 8.w),
          Expanded(
            child: Container( height: 40.h,
              decoration: BoxDecoration(
                border: Border.all(color: Get.isDarkMode?Color(0xFF121212):Color(0xFFEDEDED)),
                color: Get.isDarkMode? Color(0xFF121212):Colors.white,
                borderRadius: BorderRadius.circular(8.r)),
              child: TextField(
                controller: controller.searchController,
                autofocus: true,
                textAlignVertical: TextAlignVertical.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.textOnDark),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textOnDark),
                  prefixIcon: Icon(Icons.search, color: AppColors.textOnDark, size: 20.sp),
                  suffixIcon: Obx(() => controller.query.isNotEmpty
                      ? GestureDetector(
                    onTap: controller.clearSearch,
                    child:  Icon(Icons.cancel, color:AppColors.textOnDark, size: 20.sp))
                      : const SizedBox.shrink()),
                  border: InputBorder.none,
                  isDense: true)))),
        ],
      ),
    );
  }

  Widget _buildInternalFilterField(SearchPageController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Get.isDarkMode?Color(0xFF0B0B0B):Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Color(0xFFE6E6E6))),
      child: TextField(
        controller: controller.filterController,
        style: AppTextStyles.caption.copyWith(color: AppColors.textOnDark),
        decoration:  InputDecoration(
          hintText: 'Find an item',
          hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textOnDark),
          contentPadding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
          border: InputBorder.none)),
    );
  }

  Widget _buildItemCard(SearchPageController controller, String item) {
    return Obx(() {
      final isSelected = controller.selectedItem.value == item;
      return GestureDetector(
        onTap: () => controller.selectItem(item),
        child: Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
          decoration: BoxDecoration(
            color: Get.isDarkMode? Color(0xFF121212):Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all( color: Get.isDarkMode? const Color(0xFF121212):Color(0xFFEDEDED))),
          child: Row(
            children: [
              Expanded(child: Text(item, style: AppTextStyles.caption.copyWith(color: AppColors.textOnDark))),
              if (isSelected)
                Icon(Icons.check, color: AppColors.textGreen, size: 20.sp),
            ],
          ),
        ),
      );
    });
  }
}