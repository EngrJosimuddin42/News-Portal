import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../controllers/create_post_controller.dart';

class CreatePostView extends GetView<CreatePostController> {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor:AppColors.scaffoldBg,
        elevation: 0,
        leading: IconButton(
          onPressed: controller.onBack,
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textOnDark, size: 18.sp)),
        actions: [
          Padding(
            padding:  EdgeInsets.only(right: 16.w, top: 8.h, bottom: 8.h),
            child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.onPost,
                style: ElevatedButton.styleFrom(
                    backgroundColor:Get.isDarkMode? Color(0xFF333333):Color(0xFFEBEBEB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
                child: controller.isLoading.value
                    ?  SizedBox(width: 20.w, height: 20.h, child: CircularProgressIndicator(strokeWidth: 2, color:AppColors.white))
                    : Text('Post', style: AppTextStyles.bodyMedium.copyWith(color: Get.isDarkMode?Color(0xFFC4C4C4):Color(0xFF242424)))))),
        ],
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 6.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller.textController,
                maxLines: null,
                minLines: 2,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textOnDark),
              decoration: InputDecoration(
                hintText: "Share your thoughts",
                hintStyle: TextStyle(color: AppColors.textOnDark),
                border: InputBorder.none,contentPadding: EdgeInsets.only(bottom: 2.h),)),

            Obx(() {
              final mediaFile = controller.selectedMedia.value;
              final thumbFile = controller.videoThumbnail.value;
              final bool isReel = controller.isReel.value;

              if (mediaFile == null) {
                return GestureDetector(
                  onTap: controller.onAddMedia,
                  child: Container( width: 75.w, height: 67.h,
                    decoration: BoxDecoration(
                        color:Get.isDarkMode? Color(0xFF444444):Color(0xFFEBEBEB),
                        borderRadius: BorderRadius.circular(8.r)),
                    child: Icon(Icons.add, color:AppColors.white, size: 28.sp)),
                );
              }

              return Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Colors.black,
                  image: isReel
                      ? (thumbFile != null
                      ? DecorationImage(image: FileImage(thumbFile), fit: BoxFit.cover)
                      : null)
                      : DecorationImage(image: FileImage(mediaFile), fit: BoxFit.cover)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (isReel && thumbFile == null)
                      SizedBox(width: 20.w, height: 20.h, child: CircularProgressIndicator(color:AppColors.white,strokeWidth: 2)),

                    if (isReel && thumbFile != null)
                       Icon(Icons.play_circle_fill, color: Colors.white, size: 30.sp),
                    Positioned(
                      right: 0, top: 0,
                      child: GestureDetector(
                        onTap: () {
                          controller.selectedMedia.value = null;
                          controller.videoThumbnail.value = null;
                          controller.isReel.value = false;
                        },
                        child: Icon(Icons.cancel, color: Colors.red, size: 20.sp))),
                  ],
                ),
              );
            }),

            SizedBox(height: 32.h),

            // Tag location
            InkWell(
              onTap: controller.onTagLocation,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration:  BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Get.isDarkMode? Color(0xFF333333):Color(0xFFEDEDED)),
                    bottom: BorderSide(color: Get.isDarkMode? Color(0xFF333333):Color(0xFFEDEDED)))),
                child: Row(
                  children: [
                    SvgPicture.asset(AppAssets.locationIcon, width: 20.w, height: 20.h,
                      colorFilter:ColorFilter.mode(AppColors.textOnDark,BlendMode.srcIn)),
                     SizedBox(width: 10.w),
                    Obx(() =>Text(controller.selectedLocation.isEmpty
                            ? 'Tag Location'
                            : controller.selectedLocation.value,
                      style: AppTextStyles.bodyMedium.copyWith( color: controller.selectedLocation.isEmpty
                              ? AppColors.textOnDark
                              : AppColors.textOnDark))),
                    const Spacer(),
                     Icon(Icons.arrow_forward_ios, color: AppColors.textOnDark, size: 14.sp),
                  ],
                ),
              ),
            ),
          ],
        ),
    )
    );
  }
}