import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../controllers/me/settings/help_center_controller.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../about/sub_pages/help_widgets.dart';

class HelpDetailView extends StatelessWidget {
  final String title;
  const HelpDetailView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HelpCenterController>();
    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
          backgroundColor:AppColors.scaffoldBg,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child:Icon(Icons.arrow_back_ios,color:AppColors.textOnDark, size: 20.sp)),
          title: Text('Help & Support', style: AppTextStyles.displaySmall.copyWith(color: AppColors.white)),
          centerTitle: true),
      body: Column(
        children: [
          Container(height: 30.h,
            padding:  EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              border: Border.all(color: Get.isDarkMode?Color(0xFFDDDDDD):Color(0xFFEDEDED)),
                color:Get.isDarkMode?Colors.white:Color(0xFFEDEDED)),
            child: Center(
               child:Text('Help Center', style: AppTextStyles.bodyMedium.copyWith(color: Color(0xFF242424))))),
          
          Expanded(
            child: ListView(
              children: [
                // Breadcrumb
                Padding(
                  padding:  EdgeInsets.fromLTRB(16.w, 30.h, 16.w, 8.w),
                  child: Row(
                    children: [
                      Text('NewsBreak Help Center', style: AppTextStyles.caption.copyWith(color: AppColors.linkColor)),
                     Flexible(
                         child:Text(' > $title', style:AppTextStyles.caption.copyWith(color: AppColors.textOnDark),
                       overflow: TextOverflow.ellipsis,
                           maxLines: 1)),
                    ],
                  ),
                ),

                // Search
                Padding(
                  padding: EdgeInsets.symmetric( horizontal: 16.w, vertical:16.h),
                  child: Container( height: 40.h,
                    decoration: BoxDecoration(
                        border: Border.all(color: Get.isDarkMode?Color(0xFFDDDDDD):Color(0xFFEDEDED)),
                      borderRadius: BorderRadius.circular(8.r)),
                    child:TextField(
                        controller: controller.searchController,
                        onChanged: (value) => controller.runSearch(value),
                        textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'search',
                        hintStyle:AppTextStyles.caption.copyWith(color: AppColors.textOnDark),
                        prefixIcon: Icon(Icons.search, color: AppColors.textOnDark, size: 20.sp),
                        border: InputBorder.none,isDense: true)))),

                // Title
                Padding(
                  padding:EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                  child: Text(title, style: AppTextStyles.tagline.copyWith(color: Colors.black))),

                // Sections
        Obx(() {
          if (controller.isLoading.value) {
            return  Center(
              child: Padding( padding: EdgeInsets.all(20.w),
                child: CircularProgressIndicator(color: AppColors.white)),
            );
          }

          return Column(
            children: controller.sections.map((section) =>
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(section['title']!, style: AppTextStyles.button.copyWith(color: Get.isDarkMode?Color(0xFF242424):Color(0xFFDBDBDB))),
                       SizedBox(height: 6.h),
                      Text(section['body']!, style: AppTextStyles.large.copyWith(color: Color(0xFF6C6C6C))),
                    ],
                  ),
                )).toList(),
          );
        }),
                 SizedBox(height: 120.h),
                HelpWidgets.helpFooter(),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}