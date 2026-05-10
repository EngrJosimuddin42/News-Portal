import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import 'package:news_break/app/widgets/bottom_sheet_handle.dart';
import '../../controllers/home_controller.dart';
import 'manage_location_view.dart';

class ChooseLocationSheet extends GetView<HomeController> {
  const ChooseLocationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.80,
        decoration:BoxDecoration(
          color:AppColors.sheet,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
        child: Column(
          children: [
            // Handle bar
            const BottomSheetHandle(),

             SizedBox(height: 24.h),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() => !controller.isSearching.value
                      ? GestureDetector(
                    onTap: () {
                      controller.confirmLocationSelection();
                      Get.back();
                    },
                    child: Text('Done', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGreen)))
                      : const SizedBox.shrink()),
                ],
              ),
            ),

             SizedBox(height: 24.h),

            // Search bar
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16.h),
              child: Row(
                children: [
                  Expanded(
                    child: Container( height: 40.h,
                      decoration: BoxDecoration(
                        color:Get.isDarkMode?Color(0xFF444444):Colors.white,
                        border: Border.all(color:Get.isDarkMode? Color(0xFF6B6B6B):Color(0xFFEDEDED)),
                        borderRadius: BorderRadius.circular(10.r)),
                      child: TextField(
                        controller: controller.searchController,
                        style: AppTextStyles.caption.copyWith(color: Color(0xFFB8B8B8)),
                        onChanged: (val) => controller.searchQuery.value = val,
                        onTap: () => controller.isSearching.value = true,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Search city or zip code',
                          hintStyle: AppTextStyles.caption.copyWith(color: Color(0xFFB8B8B8)),
                          prefixIcon: Icon(Icons.search, color:  Color(0xFFB8B8B8), size: 20.sp),
                          border: InputBorder.none,
                          suffixIconConstraints: BoxConstraints(minHeight: 20.h, minWidth: 20.w),
                          suffixIcon: _ClearButton(
                            controller: controller.searchController,
                            onClear: () => controller.searchQuery.value = ''),
                        isDense: true)))),
                  Obx(() => controller.isSearching.value
                      ? Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: GestureDetector(
                      onTap: () { controller.clearSearch();
                        FocusScope.of(context).unfocus();
                      },
                      child: Text('Cancel', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGreen))))
                      : const SizedBox.shrink()),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Content
            Expanded(
              child: Obx(() => controller.selectedLocation.value != null && !controller.isSearching.value
                  ? _buildSelectedState()
                  : controller.searchQuery.value.isNotEmpty
                  ? _buildSearchResults()
                  : _buildDefaultState()),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildDefaultState() {
    final controller = Get.find<HomeController>();
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => GestureDetector(
            onTap: controller.isLocationLoading.value
                ? null
                : () => controller.detectGPSLocation(),
            child: Row(
              children: [
                controller.isLocationLoading.value
                    ?  SizedBox(width: 32.w, height: 32.h,
                  child: Padding(
                    padding: EdgeInsets.all(6.0),
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textGreen)))
                    : SvgPicture.asset(AppAssets.send1Icon, width: 20.w, height: 20.h,
                  colorFilter:ColorFilter.mode(Get.isDarkMode?Color(0xFF3498FA):Color(0xFF4DA4FB), BlendMode.srcIn)),
                SizedBox(width: 8.w),
                Text(controller.isLocationLoading.value
                      ? 'Detecting Location...'
                      : 'Your GPS location',
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.textGreen)),
              ],
            ),
          )),

           SizedBox(height: 16.h),
          Row(
            children: [
              Text("Couldn't load your location", style: AppTextStyles.caption.copyWith(color: AppColors.textOnDark)),
              const Spacer(),
              GestureDetector(
                onTap: () => controller.detectGPSLocation(),
                child: Text('Try Again', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGreen))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final results = controller.filteredLocations;
    if (results.isEmpty) {
      return  Center(
        child: Text('No results found', style: TextStyle(color:AppColors.textOnDark, fontSize: 14.sp)));
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: results.length,
      itemBuilder: (_, i) {
        final loc = results[i];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(loc['city']!, style: AppTextStyles.caption.copyWith(color: AppColors.white)),
          subtitle: Text(loc['zip']!, style: AppTextStyles.overline),
          onTap: () {
            controller.selectLocationFromSearch(loc);
            FocusScope.of(Get.context!).unfocus();
          },
        );
      },
    );
  }

  Widget _buildSelectedState() {
    final loc = controller.selectedLocation.value;
    if (loc == null) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar (empty)
           SizedBox(height: 8.h),

          // Primary Location
          Text('Primary Location', style:AppTextStyles.overline),
           SizedBox(height: 10.h),

          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Get.isDarkMode
                      ? Color(0xFFD9D9D9)
                      : Color(0XFF333333)),
                child: SvgPicture.asset(
                  Get.isDarkMode ? AppAssets.home4Icon : AppAssets.home5Icon,height: 16.h,width: 16.h)),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(loc['city']!, style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.white,fontWeight: FontWeight.w700)),
                Text(loc['zip']!, style: AppTextStyles.overline),
                    GestureDetector(
                      onTap: () {
                        controller.selectedLocation.value = null;
                        controller.tempLocation.value = null;
                      },
                      child:Text('Change', style: AppTextStyles.overline.copyWith(decoration: TextDecoration.underline,decorationColor: AppTextStyles.overline.color))),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const ManageLocationView(), arguments: loc);
                },
                child: Text('View', style: AppTextStyles.buttonOutline.copyWith(color: AppColors.textGreen))),
            ],
          ),

           SizedBox(height: 24.h),

          // Location You Follow
          Text('Location You Follow', style:AppTextStyles.overline),
          SizedBox(height: 10.h),
          Text("You don't follow any other locations. Add more locations to see news in For you from where your friends or family live, or other places you are interested in.",
            style: AppTextStyles.overline.copyWith(color: Color(0xFFCBCBCB))),
          SizedBox(height: 18.h),
          GestureDetector(
              onTap: () => Get.to(() => const ManageLocationView()),
              child: Text('Add more locations', style:AppTextStyles.bodySmall.copyWith(color: AppColors.textGreen))),
        ],
      ),
    );
  }
}

// Clear button widget
class _ClearButton extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;
  const _ClearButton({required this.controller, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        return value.text.isNotEmpty
            ? GestureDetector(
          onTap: () {
            controller.clear();
            onClear();
          },
          child: Container(
            margin:  EdgeInsets.symmetric(horizontal: 8.h),
            padding:  EdgeInsets.all(2.w),
            decoration: BoxDecoration(
                color:Get.isDarkMode? const Color(0xFF444444):Colors.white,
                border: Border.all(color:Color(0xFF929292)),
                shape: BoxShape.circle),
            child: Icon(Icons.close_rounded, color:Color(0xFF929292), size: 12.sp),
          ),
        )
            : const SizedBox.shrink();
      },
    );
  }
}