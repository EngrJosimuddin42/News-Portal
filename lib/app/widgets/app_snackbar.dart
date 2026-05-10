import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppSnackbar {
  AppSnackbar._();

  static void show({
    required String title,
    required String message,
    Color? backgroundColor,
    Color? textColor,
    SnackPosition position = SnackPosition.BOTTOM,
    Duration duration = const Duration(seconds: 3),
    SnackStyle snackStyle = SnackStyle.FLOATING,
    Widget? icon,
  }) {
    Get.snackbar(title, message,
      backgroundColor: backgroundColor ?? AppColors.white,
      colorText: textColor ?? AppColors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: duration,
      snackStyle: snackStyle,
      margin:  EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
      maxWidth: 311.w,
      borderRadius: 12.r,
      titleText: Text(title, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white)),
      messageText: Text(message, style: AppTextStyles.bodySmall.copyWith(color: textColor ?? AppColors.white)),
      icon: icon,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
    );
  }

  //  Preset types

  static void success({ required String message}) {
    show(title: "Success", message: message,
      backgroundColor: Color(0xFF2E7D32),
      icon: Icon(Icons.check_circle_outline, color: Colors.white, size: 28.sp),
    );
  }

  static void error({required String message}) {
    show(title: "Notice", message: message,
      backgroundColor: const Color(0xFFC62828),
      icon: Icon(Icons.error_outline, color: Colors.white, size: 28.sp),
    );
  }

  static void warning({required String title,Widget? mainButton, required String message}) {
    show(title: title, message: message,
      backgroundColor: const Color(0xFFE65100),
      icon: Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28.sp),
    );
  }

  static void facebook({required String message}) {
    show(title: 'Facebook', message: message,
      backgroundColor: const Color(0xFF1877F2),
      icon: Icon(Icons.facebook_rounded, color: Colors.white, size: 28.sp),
    );
  }

  static void google({required String message}) {
    show(title: 'Google', message: message,
      backgroundColor: const Color(0xFF4285F4),
      icon:  Icon(Icons.g_mobiledata_rounded, color: Colors.white, size: 28.sp),
    );
  }

  static void email({required String message}) {
    show(title: 'Email', message: message,
      backgroundColor: const Color(0xFF4285F4),
      icon: Icon(Icons.email_outlined, color: Colors.white, size: 28.sp),
    );
  }
}