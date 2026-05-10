import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/me/settings/settings_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();

    final items = [
      {
        'label': 'Home',
        'darkSelected': AppAssets.homeIcon,
        'darkUnselected': AppAssets.home1Icon,
        'lightSelected': AppAssets.home2Icon,
        'lightUnselected': AppAssets.home3Icon,
      },
      {
        'label': 'Trends',
        'darkSelected': AppAssets.trendIcon,
        'darkUnselected': AppAssets.trend1Icon,
        'lightSelected': AppAssets.trend2Icon,
        'lightUnselected': AppAssets.trend3Icon,
      },
      {
        'label': 'Notification',
        'darkSelected': AppAssets.notificationIcon,
        'darkUnselected': AppAssets.notification1Icon,
        'lightSelected': AppAssets.notification2Icon,
        'lightUnselected': AppAssets.notification3Icon,
      },
      {
        'label': 'Me',
        'darkSelected': AppAssets.person1Icon,
        'darkUnselected': AppAssets.personIcon,
        'lightSelected': AppAssets.person2Icon,
        'lightUnselected': AppAssets.person3Icon,
      },
    ];

    return Obx(() {
      final isDark = SettingsController.to.isDarkMode.value;

      return Container(
        height: 70.h,
        decoration: BoxDecoration(color: AppColors.surfaceBg),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final isSelected = c.selectedNavIndex.value == i;

              String iconPath;
              if (isDark) {
                iconPath = isSelected
                    ? items[i]['darkSelected']!
                    : items[i]['darkUnselected']!;
              } else {
                iconPath = isSelected
                    ? items[i]['lightSelected']!
                    : items[i]['lightUnselected']!;
              }

              final iconColor = isSelected
                  ? (isDark ? Colors.white : const Color(0xFF242424))
                  : (isDark ? const Color(0xBFFFFFFF) : const Color(0x80242424));

              return Expanded(
                child: GestureDetector(
                  onTap: () => c.onNavTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        iconPath,
                        width: 24.0.w,
                        height: 24.0.h,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        items[i]['label']!,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10.sp,
                          color: iconColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      );
    });
  }
}