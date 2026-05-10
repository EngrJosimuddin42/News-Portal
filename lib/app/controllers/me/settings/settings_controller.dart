import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import 'package:news_break/app/widgets/app_snackbar.dart';

class SettingsController extends GetxController {
  static SettingsController get to => Get.find();

  final _box = GetStorage();
  final _darkKey = 'isDarkMode';
  final _langKey = 'selectedLanguage';

  var selectedLanguage = 'English'.obs;
  var isDarkMode = true.obs;
  var selectedTextSize = 'Medium'.obs;
  var isLocationVisible = true.obs;
  var isFeedbackLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _loadThemeFromBox();
    final savedLang = _box.read(_langKey) ?? 'English';
    selectedLanguage.value = savedLang;
    _applyLocale(savedLang);
  }

  bool _loadThemeFromBox() => _box.read(_darkKey) ?? true;

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    _box.write(_darkKey, value);
  }

  void toggleLocationVisible(bool value) => isLocationVisible.value = value;

  void changeTextSize(String size) => selectedTextSize.value = size;

  String get currentLanguageName {
    if (selectedLanguage.value == 'English') {
      return '${'english'.tr} (US)';
    } else {
      return '${'bangla'.tr} (BD)';
    }
  }

  void changeLanguage(String lang) {
    selectedLanguage.value = lang;
    _box.write(_langKey, lang);
    _applyLocale(lang);
  }

  void _applyLocale(String lang) {
    if (lang == 'English') {
      Get.updateLocale(const Locale('en', 'US'));
    } else {
      Get.updateLocale(const Locale('bn', 'BD'));
    }
  }

  Future<void> sendFeedback({required String comment, required int rating}) async {
    if (comment.isEmpty) {
      AppSnackbar.error(message: "Please write something first!");
      return;
    }
    try {
      isFeedbackLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));
      Get.back();
      AppSnackbar.success(message: "Thank you for your feedback!");
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Try again.");
    } finally {
      isFeedbackLoading.value = false;
    }
  }

  void showLanguagePicker() {
    showDialog(
      context: Get.context!,
      builder: (context) => Dialog(
        backgroundColor: AppColors.surfaceBg,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 24.w),
                  Text('language'.tr,
                      style: AppTextStyles.displaySmall.copyWith(
                          fontWeight: FontWeight.w500, color: AppColors.white)),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.close, color: AppColors.white, size: 20.sp),
                  ),
                ],
              ),
              SizedBox(height: 50.h),
              _buildLanguageButton('english'),
              SizedBox(height: 12.h),
              _buildLanguageButton('bangla'),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildLanguageButton(String langKey) {
    return Obx(() {
      final isSelected = selectedLanguage.value.toLowerCase() == langKey.toLowerCase();

      return GestureDetector(
        onTap: () {
          String saveName = langKey == 'english' ? 'English' : 'Bangla';
          changeLanguage(saveName);
          Get.back();
        },

        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color:const Color(0xFF7B83EB),
            borderRadius: BorderRadius.circular(8.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(langKey.tr,
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
              if (isSelected) ...[
                SizedBox(width: 8.w),
                const Icon(Icons.check, color: Colors.white, size: 16),
              ],
            ],
          ),
        ),
      );
    });
  }
}