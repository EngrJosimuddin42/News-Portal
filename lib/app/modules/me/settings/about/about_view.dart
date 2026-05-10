import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/modules/premium/premium_screen.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../../bindings/premium_binding.dart';
import 'legal_view.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.scaffoldBg,
      appBar: AppBar(
          backgroundColor:AppColors.scaffoldBg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios, color:AppColors.textOnDark, size: 20.sp)),
        title:Text('About', style:AppTextStyles.displaySmall.copyWith(color: AppColors.white)),
        centerTitle: true),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
             SizedBox(height: 60.h),
            // Logo
            SvgPicture.asset(AppAssets.logoIcon, width: 60.w, height: 60.h,
              colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),),

             SizedBox(height: 48.h),

            // Buttons
            _actionButton('Terms of Use', () => Get.to(() => const LegalView(type: LegalType.terms))),
             SizedBox(height: 12.h),
            _actionButton('Legal Notices', () => Get.to(() => const LegalView(type: LegalType.notice))),
            SizedBox(height: 12.h),
            _actionButton('Privacy Policy', () => Get.to(() => const LegalView(type: LegalType.privacy))),
            SizedBox(height: 12.h),
            _actionButton('Check for Update', () => Get.to(() => const PremiumScreen(),binding: PremiumBinding())),
          ],
        ),
      ),
    ),
    );
  }

  Widget _actionButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          border: Border.all(color:Get.isDarkMode?Colors.white:Color(0xFFEDEDED)),
          borderRadius: BorderRadius.circular(8.r)),
        child: Center(
          child: Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.white)))),
    );
  }
}