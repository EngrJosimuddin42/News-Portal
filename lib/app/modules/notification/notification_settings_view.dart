import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../theme/app_colors.dart';
import '../../controllers/notification/notification_controller.dart';

class NotificationSettingsView extends StatelessWidget {
  const NotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());
    return Scaffold(
      backgroundColor:AppColors.scaffoldBg,
      appBar: AppBar(
          backgroundColor:AppColors.scaffoldBg,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child:Icon(Icons.arrow_back_ios, color:AppColors.textOnDark, size: 20.sp)),
        title:Text('Notification Settings',
            style:AppTextStyles.displaySmall.copyWith(color: AppColors.white)),
        centerTitle: true),

        body: Obx(() => ListView(
        children: [

          // Allow Notification
        _buildRoundedBox(
        child:_switchTile('Allow Notification', controller.allowNotification.value,
                (val) => controller.allowNotification.value = val,
            showPadding: false )),

          // Frequency slider
      _buildRoundedBox(
         child:  Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text('Number of Notification',
                     style: AppTextStyles.large.copyWith(color: AppColors.white)),
                 SizedBox(height: 2.h),
                Text('Control the frequency of notifications', style: AppTextStyles.overline),
                Slider(
                  value: controller.frequency.value,
                  divisions: 2,
                  onChanged: (val) => controller.frequency.value = val,
                  activeColor: Colors.blue,
                  inactiveColor: AppColors.textOnDark),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Low Text
                    Text('Low', style: controller.frequency.value == 0.0
                          ? AppTextStyles.small.copyWith(color: AppColors.white)
                          : AppTextStyles.overline),

                    // Normal Text
                    Text('Normal', style: controller.frequency.value == 0.5
                          ? AppTextStyles.small.copyWith(color: AppColors.white)
                          : AppTextStyles.overline),

                    // High Text
                    Text('High', style: controller.frequency.value == 1.0
                          ? AppTextStyles.small.copyWith(color: AppColors.white)
                          : AppTextStyles.overline),
                  ],
                ),
              ],
            ),
          ),
      ),

     // Sound & Vibration
      _buildRoundedBox(
        child:
          _switchTile('Sound & Vibration', controller.soundVibration.value,
                (val) => controller.soundVibration.value = val,
              showPadding: false)),

          _sectionLabel('Notification Topics'),

          _buildRoundedBox(
           child:_labelWithToggle(
            'Local News',
            'Stay informed of local alerts, weather updates, news stories easily.',
            controller.localNews.value,
                (val) => controller.localNews.value = val,
            showPadding: false)),

           _buildRoundedBox(
            child: _labelWithToggle(
            'Breaking News',
            'Get notified when a major story breaks out',
            controller.breakingNews.value,
                (val) => controller.breakingNews.value = val,
            showPadding: false)),

             _buildRoundedBox(
             child: _labelWithToggle(
            'Recommended Reactions',
            'Reaction notifications from real people, based on your interests.',
            controller.recommendedReactions.value,
                (val) => controller.recommendedReactions.value = val,
              showPadding: false)),

           _buildRoundedBox(
              child: _labelWithToggle(
            'Followed Reactions',
            'Reaction notifications from people you follow.',
            controller.followedReactions.value,
                (val) => controller.followedReactions.value = val,
              showPadding: false)),

             _buildRoundedBox(
              child: _labelWithToggle(
            'For You',
            'Stories based on your interests and topics you follow.',
            controller.forYou.value,
                (val) => controller.forYou.value = val,
              showPadding: false)),

         _buildRoundedBox(
          child:_labelWithToggle(
            'Local Deals and Events',
            'Promotions and upcoming events.',
            controller.localDeals.value,
                (val) => controller.localDeals.value = val,
              showPadding: false)),

          _sectionLabel('Message'),

      _buildRoundedBox(
        child: _labelWithToggle(
            'Comment Replies',
            'Get notified when someone replied to comments you left.',
            controller.commentReplies.value,
                (val) => controller.commentReplies.value = val,
            showPadding: false)),

          _sectionLabel('Other Settings'),

          _buildRoundedBox(
              child: _labelWithToggle(
            'Do Not Disturb',
            'Notifications will be silenced during the selected time.',
            controller.doNotDisturb.value,
                (val) => controller.doNotDisturb.value = val,
              showPadding: false)),

          _buildRoundedBox(
            child: _labelWithToggle(
              'Lock Screen Notifications',
              'Enable to display latest news stories on lock screen',
              controller.isLockScreenEnabled.value,
                  (val) => controller.isLockScreenEnabled.value = val,
              showPadding: false,
            ),
          ),

        // Enable/Disable Button Section
           Padding(
               padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.w),
            child: Obx(() => Align(
                alignment: Alignment.centerLeft,
                child:OutlinedButton(
                  onPressed: () {
                    controller.toggleLockScreen();
                  },
                  style: OutlinedButton.styleFrom(
                      minimumSize: Size(100.w, 50.h),
                      side: BorderSide(
                          color: controller.isLockScreenEnabled.value
                              ? AppColors.textGreen
                              : Colors.red),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h)),
                  child: Text( controller.isLockScreenEnabled.value ? 'Enable' : 'Disable',
                    style: AppTextStyles.large.copyWith(color: controller.isLockScreenEnabled.value
                            ? AppColors.textGreen
                            : Colors.red)))))),
             ],
            ),
          ),
    );
  }

  Widget _buildRoundedBox({required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color:Get.isDarkMode?Color(0XFF26272D):Color(0xFFEDEDED), width: 1)),
      child: child,
    );
  }

  Widget _switchTile(String label, bool value, ValueChanged<bool> onChanged, {bool showLabel = true, bool showPadding = true}) {
    Widget content = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        if (showLabel) Text(label, style: AppTextStyles.large.copyWith(color: AppColors.white)),
        SizedBox( height: 24,
          child: Transform.scale(
            scale: 0.7,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.textGreen,
            thumbColor:WidgetStatePropertyAll(Get.isDarkMode?Colors.black:Colors.white)))),
        ],
    );

    return showPadding ?
    Padding(padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h), child: content) : content;
  }


  Widget _labelWithToggle(String title, String subtitle, bool value, ValueChanged<bool> onChanged,
      {bool showPadding = true}) {
    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.large.copyWith(color: AppColors.white)),
               SizedBox(height: 4.h),
              Text(subtitle, style: AppTextStyles.overline.copyWith(color: Colors.grey)),
            ],
          ),
        ),
          Transform.scale(
            scale: 0.7,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.textGreen,
              thumbColor:WidgetStatePropertyAll(Get.isDarkMode?Colors.black:Colors.white))),
      ],
    );

    return showPadding ?
    Padding(padding:EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: content) : content;
  }

  Widget _sectionLabel(String label) {
    return Padding( padding:  EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 4.h),
      child: Text(label, style: AppTextStyles.button.copyWith(color:AppColors.textOnDark)),
    );
  }
}