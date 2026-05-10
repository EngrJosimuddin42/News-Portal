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

    return SizedBox( height: 40.h,
      child:Obx(() => ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        padding:  EdgeInsets.symmetric(horizontal: 16.h),
        itemCount: c.tabs.length + 1,
        separatorBuilder: (context, index) =>  SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          // First item = edit icon
          if (i == 0) {
            return GestureDetector(
              onTap: c.onEditTabs,
              child: Container(width: 32.w, height: 32.h,
                alignment: Alignment.center,
                child: SvgPicture.asset(AppAssets.plusIcon, width: 20.w, height: 20.h,
                    colorFilter:ColorFilter.mode(AppColors.surface,BlendMode.srcIn))),
            );
          }

          final tabIndex = i - 1;

          return Obx(() {
            final isSelected = c.selectedTabIndex.value == tabIndex;
            return GestureDetector(
              onTap: () => c.onTabTap(tabIndex),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r)),
                child: Center(
                child: Text( c.tabs[tabIndex],  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected
                        ? AppColors.background
                        : AppColors.white,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400)))),
            );
          });
        },
      ),
    ),
    );
  }
}