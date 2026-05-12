import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../controllers/signin_controller.dart';

class SignInView extends GetView<SignInController> {
  final bool isSheet;
  const SignInView({super.key, this.isSheet = false});

  @override
  Widget build(BuildContext context) {
    return isSheet ? _buildSheet(context) : _buildFullScreen(context);
  }

  // Full screen
  Widget _buildFullScreen(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    final Color iconColor = isDark ? Colors.white : Colors.black;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            children: [
              // Skip
              Align( alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: controller.onSkip,
                  child: Text('skip'.tr, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white)))),
              const Spacer(),
             SvgPicture.asset(AppAssets.logoIcon,width: 80.w, height: 80.h,
                 colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn)),
              SizedBox(height: 24.h),
              SvgPicture.asset(AppAssets.titleIcon,width: 100.w, height: 30.h,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn)),
               SizedBox(height: 12.h),
              Text('app_tagline'.tr,style: AppTextStyles.bodyLarge.copyWith(
                  color: Get.isDarkMode?Color(0xFFC4C4C4):Color(0xFF242424))),
               SizedBox(height: 52.h),
              _buttons(),
              SizedBox(height: 10.h),
              _terms(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  //Bottom sheet (From news detail)
  Widget _buildSheet(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    final Color iconColor = isDark ? Colors.white : Colors.black;
    return Container(
      decoration:  BoxDecoration(
          color: isDark ? const Color(0xFF252525) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close
          Align(alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Get.back(),
                child: Icon(Icons.close, color: Get.isDarkMode ? Colors.white : Colors.black, size: 20.sp))),
          SizedBox(height: 8.h),

          // Logo
          SvgPicture.asset(AppAssets.logoIcon, width: 60.w, height: 60.h,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn)),
           SizedBox(height: 12.h),

          // Title
          Text('create_account'.tr, style: AppTextStyles.displaySmall.copyWith(color: AppColors.white)),
           SizedBox(height: 12.h),

          // Subtitle
          Text('login_to_comment'.tr, style: AppTextStyles.overline),
          SizedBox(height: 48.h),

          _buttons(),
           SizedBox(height: 10.h),
          _terms(),
        ],
      ),
    );
  }

  // Shared widgets
  Widget _buttons() {
    return Column(
      children: [
        Obx(() => _SocialButton(
          label: 'continue_facebook',
          onTap: controller.continueWithFacebook,
          iconWidget: SvgPicture.asset(AppAssets.facebookIcon, width: 22.w, height: 22.h),
          isLoading: controller.isLoading.value)),
         SizedBox(height: 14.h),
        Obx(() => _SocialButton(
          label: 'continue_google',
          onTap: controller.continueWithGoogle,
          iconWidget: SvgPicture.asset(AppAssets.googleIcon, width: 22.w, height: 22.h),
            isLoading: controller.isLoading.value)),

        Obx(() => AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          child: controller.isExpanded.value
              ? Padding(
            padding:  EdgeInsets.only(top: 14.h),
            child: _SocialButton(
              label: 'continue_email',
              onTap: controller.continueWithEmail,
              iconWidget: SvgPicture.asset(AppAssets.emailIcon,width: 22.w, height: 22.h),
              isLoading: controller.isLoading.value))
              : const SizedBox.shrink())),

         SizedBox(height: 20.h),
        Obx(() => AnimatedOpacity(
          opacity: controller.isExpanded.value ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: GestureDetector(
            onTap: controller.toggleExpand,
            behavior: HitTestBehavior.opaque,
            child: SizedBox( height: 32.h,
              child: Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.surface, size: 30.sp))))),
      ],
    );
  }

  //Reusable Terms
  Widget _terms() {
    return SizedBox(
        width: 335.w,
        child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(style: AppTextStyles.labelMedium.copyWith(height: 1.5,letterSpacing: -0.3,),
        children: [
          TextSpan(text: 'terms_agree'.tr),
          TextSpan(  text: 'terms_of_use'.tr,  style: AppTextStyles.labelMedium.copyWith(color: AppColors.term,decoration: TextDecoration.underline,letterSpacing: -0.3),
            recognizer: TapGestureRecognizer() ..onTap = controller.onTermsTap),
          TextSpan(text: 'and'.tr),
          TextSpan(text: 'privacy_policy'.tr, style:AppTextStyles.labelMedium.copyWith(color: AppColors.term,decoration: TextDecoration.underline,letterSpacing: -0.3),
            recognizer: TapGestureRecognizer()
              ..onTap = controller.onPrivacyTap),
          TextSpan(text: 'terms_end'.tr),
        ],
      ),
    ),
    );
  }
}

// Reusable social button
class _SocialButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Widget iconWidget;
  final bool isLoading;

  const _SocialButton({
    required this.label,
    required this.onTap,
    required this.iconWidget,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 335.w, height: 48.h,
      child: OutlinedButton(
        onPressed: isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
            backgroundColor: Get.isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
            foregroundColor: AppColors.arrow,
          side: BorderSide(color:Get.isDarkMode?Colors.white :Color(0xFFEDEDED), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.r))),
        child:isLoading
            ?  SizedBox(height: 20.h, width: 20.w,
            child: CircularProgressIndicator(strokeWidth: 2, color: Get.isDarkMode ? Colors.white : Colors.black))
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
             SizedBox(width: 10.h),
            Text(label.tr, style: AppTextStyles.caption.copyWith(color: Get.isDarkMode?Colors.white:Color(0xFF242424))),
          ],
        ),
      ),
    );
  }
}