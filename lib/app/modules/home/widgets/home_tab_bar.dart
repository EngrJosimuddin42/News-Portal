import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import '../../../controllers/home_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class HomeTabBar extends StatelessWidget {
  const HomeTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();


    // ── Text scale
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final tabBarHeight = textScale >= 1.2 ? 30.h : 28.h;

    return SizedBox( height: tabBarHeight,
      child:Obx(() => ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        padding:  EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: c.tabs.length + 1,
        separatorBuilder: (context, index) =>  SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          // First item = edit icon
          if (i == 0) {
            return GestureDetector(
              onTap: c.onEditTabs,
              child: Container(width: 32.w, height: 27.h,
                  alignment: Alignment.center,
                  child: SvgPicture.asset(AppAssets.plusIcon, width: 20.w, height: 20.h,
                      colorFilter:ColorFilter.mode(AppColors.white,BlendMode.srcIn))),
            );
          }

          final tabIndex = i - 1;

          return Obx(() {
            final isSelected = c.selectedTabIndex.value == tabIndex;
            return GestureDetector(
              onTap: () => c.onTabTap(tabIndex),
              child: Container(
                  height: 27.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                      color: isSelected ? AppColors.surface : Colors.transparent,
                      borderRadius: BorderRadius.circular(60.r)),
                  child: Center(
                      child: Text( c.tabs[tabIndex].tr,  style: AppTextStyles.labelSmall.copyWith(
                          color: isSelected
                              ? AppColors.background
                              : AppColors.white,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          letterSpacing: 0,height: 1.0)))),
            );
          });
        },
      ),
      ),
    );
  }
}