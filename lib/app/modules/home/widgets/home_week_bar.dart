import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/me/settings/settings_controller.dart';
import '../../../theme/app_colors.dart';

class HomeWeekBar extends GetView<HomeController> {
  const HomeWeekBar({super.key});

  static const List<String> _days = ['sun', 'mon', 'tues', 'wed', 'thurs', 'fri', 'sat'];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedDay = controller.selectedDayIndex.value;
      final isDark = SettingsController.to.isDarkMode.value;

      return Container(
        color: AppColors.scaffoldBg,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          children: [
            // Day names row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_days.length, (i) {
                final bool isSelected = i == selectedDay;
                final Color unselectedColor = const Color(0xFF6C6C6C);
                final Color selectedColor = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF242424);

                return GestureDetector(
                  onTap: () => controller.selectDay(i),
                  child: Text( _days[i].tr,
                    style: TextStyle(color: isSelected ? selectedColor : unselectedColor, fontSize: 12.sp,
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400)),
                );
              }),
            ),
            SizedBox(height: 6.h),
            // Month & Day
            Text(controller.monthAndDay, style:AppTextStyles.tagline.copyWith(
                color:isDark ? const Color(0xFFD9D9D9) : const Color(0xFF242424))),
             SizedBox(height: 12.h),
            Divider(color:AppColors.divider, height: 1, thickness: 1),
          ],
        ),
      );
    });
  }
}