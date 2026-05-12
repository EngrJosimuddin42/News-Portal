import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import '../../../controllers/home_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../premium/premium_screen.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize =>  Size.fromHeight(48.h);

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HomeController>();
    return AppBar(
      backgroundColor: AppColors.scaffoldBg,
      elevation: 0,
      titleSpacing: 0,
      title:Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: GestureDetector(
        onTap: c.onChooseLocation,
        child: Obx(() => Row(
          children: [
            Flexible(
              child: Text(c.locationTitle,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white,height: 1.0,letterSpacing: 0),
                  overflow: TextOverflow.visible,
             maxLines: 1)),
             SizedBox(width: 6.w),
            Container(width: 18.w, height: 18.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle),
              child: Center(
                child: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.arrow, size: 15.sp))),
          ],
        )),
      )),

      actions: [
        IconButton(
          onPressed: c.onAI,
          icon: ShaderMask(
            shaderCallback: (Rect bounds) {
              return AppColors.aiGradient.createShader(bounds);
            },
            child: SvgPicture.asset( AppAssets.starIcon, width: 22.w, height: 22.h,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)))),
        IconButton(
          onPressed: c.onSearch,
          icon: SvgPicture.asset(AppAssets.searchIcon, width: 22.w, height: 22.h,
            colorFilter: ColorFilter.mode(AppColors.surface, BlendMode.srcIn))),

        Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
            child: GestureDetector(
                onTap: () => Get.to(() => const PremiumScreen()),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFB4BAFF), Color(0xFF7B83EB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Text('upgrade'.tr,
                        style: AppTextStyles.textSmall.copyWith( color:Colors.white))))),
      ],
    );
  }
}