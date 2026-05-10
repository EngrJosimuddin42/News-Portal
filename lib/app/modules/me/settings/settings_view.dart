import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/modules/location/choose_location_sheet.dart';
import 'package:news_break/app/modules/me/settings/privacy_view.dart';
import 'package:news_break/app/modules/me/settings/send_feedback_sheet.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../controllers/auth/auth_controller.dart';
import '../../../controllers/me/settings/settings_controller.dart';
import '../../../controllers/notification/notification_controller.dart';
import '../../notification/notification_settings_view.dart';
import 'about/about_view.dart';
import 'discover_app_view.dart';
import 'help_center/help_support_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationController(), permanent: true);

    return Obx(() {
      final isDark = SettingsController.to.isDarkMode.value;
      final bgColor = isDark ? Color(0xFF000000) : Color(0xFFFFFFFF);
      final titleColor = isDark ? Color(0xFFFFFFFF) : Color(0xFF0D0D0D);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          title: Text('Settings', style: AppTextStyles.displaySmall.copyWith(
              color: titleColor)),
          centerTitle: true,
          leading: GestureDetector(
              onTap: () => Get.back(),
              child: Icon(Icons.arrow_back_ios, color: AppColors.textOnDark,
                  size: 20.sp))),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                SizedBox(height: 16.h),

                // Manage Location
                _settingsTile(
                    iconPath: AppAssets.locationIcon,
                    title: 'Manage Location',
                    onTap: () => Get.to(() => const ChooseLocationSheet(),
                      arguments: {'isFromSettings': true},
                    )),

                // Notification
                _settingsTile(
                    iconPath: AppAssets.notificationIcon,
                    title: 'Notification',
                    onTap: () =>
                        Get.to(() => const NotificationSettingsView())),

                // Privacy
                _settingsTile(
                    iconPath: AppAssets.privacyIcon,
                    title: 'Privacy',
                    onTap: () => Get.to(() => const PrivacyView())),

                // Dark mode
                _settingsTile(
                  iconPath: AppAssets.darkIcon,
                  title: 'Dark mode',
                  showArrow: false,
                  trailing: SizedBox(height: 12.h,
                      child: Transform.scale(
                          scale: 0.7,
                          alignment: Alignment.centerRight,
                          child: Switch(
                              value: SettingsController.to.isDarkMode.value,
                              onChanged: (bool newValue) {
                                SettingsController.to.toggleDarkMode(
                                    newValue);
                              },
                              activeThumbColor: AppColors.textGreen,
                              thumbColor: WidgetStatePropertyAll( AppColors.scaffoldBg)))),
                  onTap: () {
                    SettingsController.to.toggleDarkMode(
                        !SettingsController.to.isDarkMode.value);
                  },
                ),

                // Language
                _settingsTile(
                    iconPath: AppAssets.languageIcon,
                    title: 'Language',
                    onTap: () => SettingsController.to.showLanguagePicker()),

                // Text size
                _settingsTile(
                    iconPath: AppAssets.textIcon,
                    title: 'Text size',
                    onTap: () => _showTextSizePicker()),

                SizedBox(height: 8.h),

                // Help center
                _settingsTile(
                    iconPath: AppAssets.helpIcon,
                    title: 'Help center',
                    onTap: () => Get.to(() => const HelpSupportView())),

                // Send feedback — bottom sheet
                _settingsTile(
                    iconPath: AppAssets.feedbackIcon,
                    title: 'Send feedback',
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          constraints: const BoxConstraints(maxWidth: double
                              .infinity),
                          builder: (_) => const SendFeedbackSheet());
                    }),

                // Discover app
                _settingsTile(
                    iconPath: AppAssets.discoveryIcon,
                    title: 'Discover app',
                    onTap: () => Get.to(() => const DiscoverAppView())),

                // About us
                _settingsTile(
                    iconPath: AppAssets.aboutIcon,
                    title: 'About us',
                    onTap: () => Get.to(() => const AboutView())),

              ],
            ),
          ),

          // Log out button
          Obx(() {
            final user = AuthController.to.user.value;
            if (user == null) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 60.h),
              child: GestureDetector(
                onTap: () => _showLogoutDialog(context),
                child: Container(width: 335.w, height: 52.h,
                  decoration: BoxDecoration(
                      color: Color(0xFF7B83EB),
                      borderRadius: BorderRadius.circular(12.r)),
                  child: Center(
                    child: Text('Log out', style: AppTextStyles.button,
                        textAlign: TextAlign.center),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  });
  }

  // Settings tile
  Widget _settingsTile({
    required String iconPath,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {

    return Obx(() {
      final isDark = SettingsController.to.isDarkMode.value;
      final contentColor = isDark ? Color(0xFFFFFFFF) : Color(0xFF0D0D0D);
      final borderColor = isDark ? Color(0xFF26272D) : Color(0xFFEDEDED);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: borderColor)),
        child: Row(
          children: [
            SvgPicture.asset(
                iconPath,
                width: 18.w,
                height: 18.h,
                colorFilter: ColorFilter.mode( contentColor, BlendMode.srcIn)),
            SizedBox(width: 12.h),
            Expanded(
                child: Text(title,
                    style: AppTextStyles.bodyMedium.copyWith( color: contentColor))),
            trailing ?? (showArrow
                ? Icon(
                Icons.arrow_forward_ios, color: contentColor, size: 14.sp)
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  });
  }

  void _showTextSizePicker() {
    showDialog(
      context: context,
      builder: (context) =>
          Dialog(
            backgroundColor: AppColors.surfaceBg,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon( Icons.close, color:AppColors.white, size: 20.sp))),

                  _buildTextSizeOption('Small'),
                   Divider(color: Get.isDarkMode? Color(0xFFDEDEE8) :Color(0xFFEDEDED), height: 1),
                  _buildTextSizeOption('Medium'),
                  Divider(color: Get.isDarkMode? Color(0xFFDEDEE8) :Color(0xFFEDEDED), height: 1),
                  _buildTextSizeOption('Large'),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
    );
  }

  Widget _buildTextSizeOption(String size) {
    return Obx(() {
      bool isSelected = SettingsController.to.selectedTextSize.value == size;
      return ListTile(
        title: Text(size, style: AppTextStyles.caption.copyWith(color: AppColors.white)),
        trailing: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(  color: isSelected ? Color(0xFF257A5D) : Color(0xFFA6A7AC),width: 2)),
            child: isSelected
                ? Icon(Icons.check, size: 14.sp, color: Color(0xFF257A5D))
                : SizedBox(width: 14.w, height: 14.h)),
        onTap: () {
          SettingsController.to.changeTextSize(size);
          Get.back();
        },
      );
    });
  }

  void _showLogoutDialog(BuildContext context) {
    final bool isDark = SettingsController.to.isDarkMode.value;
    showDialog(
      context: context,
      builder: (context) =>
          Dialog(
            backgroundColor: isDark ? const Color(0xFF282828) : Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r)),
            child: Padding(
              padding:  EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(AppAssets.logoutIcon, width: 40.w, height: 40.h),
                   SizedBox(height: 16.h),
                  Text('Are you sure you want to log out?',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.label.copyWith(
                          color: AppColors.white)),
                   SizedBox(height: 32.h),

                  Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(height: 52.h,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                          color: const Color(0xFFE6E6E6),
                                          width: 1)),
                                  alignment: Alignment.center,
                                  child: Text('Cancel', style: AppTextStyles.large.copyWith(
                                      color: Color(0xFF6C6C6C)))))),
                       SizedBox(width: 12.w),

                      // Logout Button
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                Get.back();
                                AuthController.to.logout();
                              },
                              child: Container(
                                  height: 52.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.linkColor,
                                    borderRadius: BorderRadius.circular(8.r)),
                                  alignment: Alignment.center,
                                  child: Text('Log Out', style: AppTextStyles.large.copyWith( color: AppColors.background))))),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}