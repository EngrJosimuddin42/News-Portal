import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/modules/notification/notification_item_card.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../controllers/social_interaction_controller.dart';
import '../../models/news_model.dart';
import '../../models/user_model.dart';
import '../../theme/app_assets.dart';
import '../premium/widgets/premium_banner.dart';
import '../../controllers/notification/notification_controller.dart';
import 'notification_settings_view.dart';

// AppBar
class NotificationAppBar extends GetView<NotificationController>
    implements PreferredSizeWidget {
  const NotificationAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:AppColors.scaffoldBg,
      title:  Text('notifications'.tr, style: AppTextStyles.displaySmall.copyWith(color: AppColors.white)),
      centerTitle: true,
      actions: [
        IconButton(
            icon:Icon(Icons.settings_outlined, color:AppColors.white),
            onPressed: () => Get.to(() => const NotificationSettingsView())),
      ],
      bottom: TabBar(
          controller: controller.tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          indicatorColor: AppColors.white,
          indicatorWeight: 2,
          indicatorPadding: EdgeInsets.only(bottom: 10.h),
          dividerColor: Colors.transparent,
          labelColor: AppColors.white,
          unselectedLabelColor:AppColors.textOnDark,
          labelStyle: AppTextStyles.caption.copyWith(color: AppColors.white),
          unselectedLabelStyle:TextStyle(fontSize: 14.sp),
          tabs: NotificationController.tabs.map((t) => Tab(text: t)).toList()),
    );
  }
}

// Body
class NotificationBody extends GetView<NotificationController> {
  const NotificationBody({super.key});

  List<NewsModel> _filteredItems() {
    final socialCtrl = Get.find<SocialInteractionController>();
    return controller.newsItems.where((news) {
      if (socialCtrl.blockedSources.contains(news.publisherName)) return false;
      if (socialCtrl.blockedTopics.contains(news.category)) return false;
      if (socialCtrl.blockedAuthors.contains(news.author)) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller.tabController,
      children: [
        _buildNewsTab(),
        _buildEmptyTab(),
        _buildEmptyTab(),
        _buildFollowsTab(),
        _buildEmptyTab(),
      ],
    );
  }

  Widget _buildFollowsTab() {
    return Obx(() {
      if (controller.followItems.isEmpty) return _buildEmptyTab();
      return ListView.separated(
        itemCount: controller.followItems.length,
        separatorBuilder: (context, index) =>
         Divider(color:Get.isDarkMode?Color(0xFF272626):Color(0xFFEDEDED), height: 1),
        itemBuilder: (context, index) {
          final user = controller.followItems[index];
          return FollowNotificationItem(user: user);
        },
      );
    });
  }

  Widget _buildNewsTab() {
    final socialCtrl = Get.find<SocialInteractionController>();

    return Obx(() {
      socialCtrl.blockedSources.length;
      socialCtrl.blockedTopics.length;
      socialCtrl.blockedAuthors.length;

      final items = _filteredItems();

      if (items.isEmpty) return _buildEmptyTab();

      return ListView(
        children: [
           SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: PremiumBanner()),
           SizedBox(height: 16.h),

          if (items.isNotEmpty) ...[
            _sectionLabel('today'),
            ...items.take(2).map((model) => Column(
              children: [
                NotificationItemCard(item: model),
                Divider(color:Get.isDarkMode?Color(0xFF2C3C53):Color(0xFFEDEDED), height: 1),
              ],
            )),
          ],

          if (items.length > 2) ...[
            _sectionLabel('earlier'),
            ...items.skip(2).map((model) => Column(
              children: [
                NotificationItemCard(item: model),
                Divider(color:Get.isDarkMode?Color(0xFF2C3C53):Color(0xFFEDEDED), height: 1),
              ],
            )),
          ],
        ],
      );
    });
  }

  Widget _buildEmptyTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/message.png',
              width: 90.w, height: 90.h, fit: BoxFit.contain),
           SizedBox(height: 16.h),
          Text('No messages yet', style: AppTextStyles.overline),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Container(
      padding:EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration:BoxDecoration(color:Get.isDarkMode? Color(0xFF212121):Colors.white),
      child: Text(label.tr, style: AppTextStyles.textSmall),
    );
  }
}

// Follow Notification Item
class FollowNotificationItem extends StatelessWidget {
  final UserModel user;
  const FollowNotificationItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: user.isHighlighted ? Get.isDarkMode?const Color(0xFF2C3C53) :Colors.white: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          CircleAvatar(radius: 24,
              backgroundColor: Colors.grey[800],
              backgroundImage:
              (user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty)
                  ? NetworkImage(user.profileImageUrl!)
                  : null,
              child: (user.profileImageUrl == null || user.profileImageUrl!.isEmpty)
                  ? Image.asset('assets/images/publisher.png')
                  : null),
           SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: AppTextStyles.caption.copyWith(color: AppColors.white)),
                 SizedBox(height: 2),
                Text('Started following you',
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.light)),
                 SizedBox(height: 8.h),

                Row(
                  children: [
                    SvgPicture.asset(AppAssets.locationIcon, height: 18.h, width: 18.w,
                        colorFilter: ColorFilter.mode(AppColors.follow, BlendMode.srcIn)),
                     SizedBox(width: 4.w),
                    Flexible(
                        flex: 2,
                        child: Text(user.publisherMeta ?? '',
                            style: AppTextStyles.labelSmall.copyWith(color: AppColors.follow),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1)),

                     SizedBox(width: 18.w),

                    SvgPicture.asset(AppAssets.timeIcon, width: 18.w, height: 18.h,
                        colorFilter:ColorFilter.mode(AppColors.follow,BlendMode.srcIn)),
                     SizedBox(width: 4.w),
                    Flexible(
                        flex: 2,
                        child: Text(user.formattedTime,
                            style: AppTextStyles.labelSmall
                                .copyWith(color: AppColors.follow),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}