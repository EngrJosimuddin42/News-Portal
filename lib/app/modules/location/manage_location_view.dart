import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../controllers/ad_banner_controller.dart';
import '../../controllers/location/manage_location_controller.dart';
import '../../widgets/publisher_avatar.dart';

class ManageLocationView extends StatelessWidget {
  const ManageLocationView({super.key});


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ManageLocationController());
    final adBanner = Get.find<AdBannerController>();
    return Scaffold(
      backgroundColor:Get.isDarkMode? Colors.black :Colors.white,
      body: Stack(
        children: [

          // Map
          Obx(() => FlutterMap(
            mapController: controller.mapController,
            options: MapOptions(
              initialCenter: controller.center,
              initialZoom: 7,
                onTap: (tapPosition, point) => controller.onMapTap(point)),
            children: [
              TileLayer(
                urlTemplate: controller.currentMapUrl.value,
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.news_break.app',
              ),
            ],
          )),

          // Top search bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 8, left: 0, right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child:Icon(Icons.arrow_back_ios, color:Get.isDarkMode?Color(0xFF959595):Color(0xFF242424), size: 20.sp)),

                   SizedBox(width: 8.w),
                  Expanded(
                    child: Container(height: 44.h,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode?Color(0xFF121212):Colors.white,
                        borderRadius: BorderRadius.circular(8.r)),
                      child: TextField(
                        autofocus: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: controller.searchController,
                        style: AppTextStyles.caption.copyWith(color: AppColors.textOnDark),
                        onSubmitted: (_) => controller.searchLocation(),
                        textInputAction: TextInputAction.search,
                        decoration:InputDecoration(
                          hintText: 'Enter an address or zip code',
                          hintStyle: AppTextStyles.overline.copyWith(fontSize: 14.sp),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search, color:AppColors.textOnDark,size: 24.sp),
                            onPressed: controller.searchLocation))))),
                   SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF343434),
                        borderRadius: BorderRadius.circular(20.r)),
                      child:Text('Skip', style:AppTextStyles.bodyMedium.copyWith(color: Colors.white)))),
                ],
              ),
            ),
          ),

          //Right side buttons
          Positioned(right: 12.w, bottom: 95.h,
            child: Column(
              children: [

                _mapButton(Icons.bookmark_border, () => controller.saveBookmark()),

                SizedBox(height: 8.h),

                _mapButton(Icons.info_outline, () {
                  Get.defaultDialog(
                    title: "Map Info",
                    middleText: "Use the search bar to find food points near you.",
                    backgroundColor: Get.isDarkMode? const Color(0xFF2C2C2E):Colors.white,
                    titleStyle:  TextStyle(color:AppColors.white),
                    middleTextStyle: TextStyle(color:AppColors.white));
                }),
                 SizedBox(height: 8.h),

                _mapButton(Icons.my_location, () => controller.resetToCurrentLocation()),

                 SizedBox(height: 8.h),

            _mapButton(Icons.layers_outlined, controller.toggleMapStyle)
              ],
            ),
          ),


          // Bottom Ad banner
          Obx(() => adBanner.isBannerVisible.value
              ? Positioned( bottom: 32.h, left: 16.w, right: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color:Get.isDarkMode? const Color(0xFF444447):Colors.white,
                border: Border.all(color: Get.isDarkMode?Color(0xFF444447):Color(0xFFEDEDED)),
                borderRadius: BorderRadius.circular(12.r)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PublisherAvatar.fromUrl(
                    imageUrl: adBanner.adBanner.value.imageUrl,
                    name: adBanner.adBanner.value.title,
                    size: 48.sp),
                   SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(adBanner.adBanner.value.title,
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white)),
                            GestureDetector(
                              onTap: () => adBanner.isBannerVisible.value = false,
                              child: Icon(Icons.close, color:Color(0xFF6C6C6C), size: 20.sp)),
                          ],
                        ),
                         SizedBox(height: 6.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                adBanner.adBanner.value.body,
                                style: AppTextStyles.overline,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis)),
                             SizedBox(width: 8.w),
                            ElevatedButton(
                              onPressed: () => adBanner.openExternalLink(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:Get.isDarkMode?Colors.white:Color(0xFF242424),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 8.h),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                              child: Text('Open', style: AppTextStyles.bodyMedium.copyWith( color:Get.isDarkMode?const Color(0xFF242424):Colors.white))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
              : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _mapButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container( width: 40.w, height: 40.h,
        decoration: BoxDecoration(
          color:AppColors.scaffoldBg,
          border:Border.all(color:Get.isDarkMode? Colors.black:Color(0xFF232323)),
          borderRadius: BorderRadius.circular(8.r)),
        child: Icon(icon, color:Get.isDarkMode?Colors.white:Color(0xFF242424), size: 20.sp)),
    );
  }
}