import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../controllers/me/settings/settings_controller.dart';
import '../../theme/app_colors.dart';
import '../../controllers/notification/notification_controller.dart';

class NotificationSettingsView extends StatelessWidget {
  const NotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());
    return Obx(() {
      final isDark = SettingsController.to.isDarkMode.value;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldBg,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios, color: AppColors.textOnDark, size: 20.sp),
          ),
          title: Text('notification_settings'.tr,
              style: AppTextStyles.displaySmall.copyWith(color: AppColors.white,letterSpacing: 0,height: 1.0)),
          centerTitle: true,
        ),
        body: Obx(() => ListView(
          children: [
            _buildRoundedBox(
              isDark: isDark,
              child: _switchTile('allow_notification'.tr, controller.allowNotification.value,
                      (val) => controller.allowNotification.value = val,
                  isDark: isDark, showPadding: false),
            ),

            _buildRoundedBox(
              isDark: isDark,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.w, 8.h, 16.w, 4.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('number_of_notification'.tr,
                        style: AppTextStyles.caption.copyWith(color: AppColors.white,letterSpacing: 0,height: 1.0)),
                    SizedBox(height: 8.h),
                    Text('control_frequency'.tr, style: AppTextStyles.overline.copyWith(letterSpacing: 0,height: 1.0)),
                    SizedBox(height: 8.h),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 1.h,
                        overlayShape: SliderComponentShape.noOverlay,
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                          tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 3.r),
                          activeTickMarkColor: AppColors.textGreen,
                          inactiveTickMarkColor: AppColors.scaffoldBg,
                          activeTrackColor: AppColors.textGreen,
                          inactiveTrackColor: AppColors.scaffoldBg,
                          thumbColor: AppColors.textGreen),
                      child: Slider(
                        value: controller.frequency.value,
                        divisions: 4,
                        onChanged: (val) => controller.frequency.value = val)),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('low'.tr, style: controller.frequency.value == 0.0
                            ? AppTextStyles.small.copyWith(color: AppColors.white)
                            : AppTextStyles.overline),
                        Text('normal'.tr, style: controller.frequency.value == 0.5
                            ? AppTextStyles.small.copyWith(color: AppColors.white)
                            : AppTextStyles.overline),
                        Text('high'.tr, style: controller.frequency.value == 1.0
                            ? AppTextStyles.small.copyWith(color: AppColors.white)
                            : AppTextStyles.overline),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            _buildRoundedBox(
              isDark: isDark,
              child: _switchTile('sound_vibration'.tr, controller.soundVibration.value,
                      (val) => controller.soundVibration.value = val,
                  isDark: isDark, showPadding: false),
            ),

            _sectionLabel('notification_topics'.tr),

            _buildRoundedBox(
              isDark: isDark,
              child: _labelWithToggle(
                'local_news'.tr, 'local_news_desc'.tr,
                controller.localNews.value, (val) => controller.localNews.value = val,
                isDark: isDark, showPadding: false,
              ),
            ),

            _buildRoundedBox(
              isDark: isDark,
              child: _labelWithToggle(
                'breaking_news'.tr, 'breaking_news_desc'.tr,
                controller.breakingNews.value, (val) => controller.breakingNews.value = val,
                isDark: isDark, showPadding: false,
              ),
            ),

            _buildRoundedBox(
              isDark: isDark,
              child: _labelWithToggle(
                'recommended_reactions'.tr, 'recommended_reactions_desc'.tr,
                controller.recommendedReactions.value,
                    (val) => controller.recommendedReactions.value = val,
                isDark: isDark, showPadding: false,
              ),
            ),

            _buildRoundedBox(
              isDark: isDark,
              child: _labelWithToggle(
                'followed_reactions'.tr, 'followed_reactions_desc'.tr,
                controller.followedReactions.value,
                    (val) => controller.followedReactions.value = val,
                isDark: isDark, showPadding: false,
              ),
            ),

            _buildRoundedBox(
              isDark: isDark,
              child: _labelWithToggle(
                'for_you'.tr, 'for_you_notif_desc'.tr,
                controller.forYou.value, (val) => controller.forYou.value = val,
                isDark: isDark, showPadding: false,
              ),
            ),

            _buildRoundedBox(
              isDark: isDark,
              child: _labelWithToggle(
                'local_deals'.tr, 'local_deals_desc'.tr,
                controller.localDeals.value, (val) => controller.localDeals.value = val,
                isDark: isDark, showPadding: false,
              ),
            ),

            _sectionLabel('message'.tr),

            _buildRoundedBox(
              isDark: isDark,
              child: _labelWithToggle(
                'comment_replies'.tr, 'comment_replies_desc'.tr,
                controller.commentReplies.value,
                    (val) => controller.commentReplies.value = val,
                isDark: isDark, showPadding: false,
              ),
            ),

            _sectionLabel('other_settings'.tr),

            _buildRoundedBox(
              isDark: isDark,
              child: _labelWithToggle(
                'do_not_disturb'.tr, 'do_not_disturb_desc'.tr,
                controller.doNotDisturb.value, (val) => controller.doNotDisturb.value = val,
                isDark: isDark, showPadding: false,
              ),
            ),

            _buildRoundedBox(
              isDark: isDark,
              child: _labelWithToggle(
                'lock_screen'.tr, 'lock_screen_desc'.tr,
                controller.isLockScreenEnabled.value,
                    (val) => controller.isLockScreenEnabled.value = val,
                isDark: isDark, showPadding: false,
              ),
            ),

/*
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.w),
              child: Obx(() => Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton(
                  onPressed: () => controller.toggleLockScreen(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(100.w, 50.h),
                    side: BorderSide(
                      color: controller.isLockScreenEnabled.value
                          ? AppColors.textGreen : Colors.red),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h)),
                  child: Text(
                    controller.isLockScreenEnabled.value ? 'enable'.tr : 'disable'.tr,
                    style: AppTextStyles.large.copyWith(
                      color: controller.isLockScreenEnabled.value
                          ? AppColors.textGreen : Colors.red,
                    ),
                  ),
                ),
              )),
            ),
*/
          ],
        )),
      );
    });
  }

  Widget _buildRoundedBox({required Widget child, required bool isDark}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? const Color(0xFF26272D) : const Color(0xFFEDEDED),
          width: 1,
        ),
      ),
      child: child,
    );
  }

  Widget _switchTile(String label, bool value, ValueChanged<bool> onChanged,
      {required bool isDark, bool showLabel = true, bool showPadding = true}) {
    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showLabel)
          Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.white,letterSpacing: 0,height: 1.0)),
        SizedBox(
          height: 24,
          child: Transform.scale(
            scale: 0.5,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: AppColors.textGreen,
              thumbColor: WidgetStatePropertyAll(
                  isDark ? Colors.black : Colors.white),
            ),
          ),
        ),
      ],
    );
    return showPadding
        ? Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        child: content)
        : content;
  }

  Widget _labelWithToggle(String title, String subtitle, bool value,
      ValueChanged<bool> onChanged,
      {required bool isDark, bool showPadding = true}) {
    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.white,letterSpacing: 0,height: 1.0)),
              SizedBox(height: 8.h),
              Text(subtitle, style: AppTextStyles.overline.copyWith(letterSpacing: 0,height: 1.5)),
            ],
          ),
        ),
        Transform.scale(
          scale: 0.5,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.textGreen,
            thumbColor: WidgetStatePropertyAll(
                isDark ? Colors.black : Colors.white),
          ),
        ),
      ],
    );
    return showPadding
        ? Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: content)
        : content;
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 4.h),
      child: Text(label,
          style: AppTextStyles.button.copyWith(color: AppColors.textOnDark,letterSpacing: 0,height: 1.5)),
    );
  }
}