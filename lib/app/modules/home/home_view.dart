import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/modules/home/widgets/bottom_nav_bar.dart';
import 'package:news_break/app/modules/home/widgets/home_app_bar.dart';
import 'package:news_break/app/modules/home/widgets/home_tab_bar.dart';
import 'package:news_break/app/modules/home/widgets/tabs/beauty_tab.dart';
import 'package:news_break/app/modules/home/widgets/tabs/entertainment_tab.dart';
import 'package:news_break/app/modules/home/widgets/tabs/food_tab.dart';
import 'package:news_break/app/modules/home/widgets/tabs/for_you_tab.dart';
import 'package:news_break/app/modules/home/widgets/tabs/health_tab.dart';
import 'package:news_break/app/modules/home/widgets/home_week_bar.dart';
import 'package:news_break/app/modules/home/widgets/tabs/local_tab.dart';
import 'package:news_break/app/modules/home/widgets/tabs/local_tv_tab.dart';
import 'package:news_break/app/modules/home/widgets/tabs/reactions_tab.dart';
import 'package:news_break/app/modules/home/widgets/tabs/sports_tab.dart';
import 'package:news_break/app/modules/home/widgets/tabs/weather_tab.dart';
import 'package:news_break/app/modules/trends/trends_view.dart';
import 'package:news_break/app/theme/app_assets.dart';
import '../../theme/app_colors.dart';
import '../me/me_view.dart';
import '../me/widgets/me_app_bar.dart';
import '../notification/notification_view.dart';
import '../../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final navIndex = controller.selectedNavIndex.value;

      if (navIndex == 1) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          body: const TrendsView(),
          bottomNavigationBar: SafeArea(child: const HomeBottomNavBar()),
        );
      }
      if (navIndex == 2) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          appBar: const NotificationAppBar(),
          body: const NotificationBody(),
          bottomNavigationBar: SafeArea(child: const HomeBottomNavBar()),
        );
      }
      if (navIndex == 3) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          appBar: const MeAppBar(),
          body: const MeBody(),
          bottomNavigationBar: SafeArea(child: const HomeBottomNavBar()),
        );
      }

      // Home (default)
      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: const HomeAppBar(),
        body: Column(
          children: [
             SizedBox(height: 6.h),
            const HomeTabBar(),
             SizedBox(height: 24.h),
            const HomeWeekBar(),
             SizedBox(height: 8.h),
            Expanded(
              child: Obx(() {
                final index = controller.selectedTabIndex.value;
                if (index >= controller.tabs.length) return const SizedBox();
                final tabName = controller.tabs[index];
                return _buildTabContentByName(tabName);
              }),
            ),
          ],
        ),

        bottomNavigationBar: SafeArea(child: const HomeBottomNavBar()),

        floatingActionButton: Obx(() {
          if (controller.selectedTabIndex.value == 0 &&
              controller.tabs.isNotEmpty &&
              controller.tabs[0] == 'Reactions') {
            return FloatingActionButton(
              onPressed: controller.onCreatePost,
              backgroundColor:Color(0xFF215C96),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r)),
              child: SvgPicture.asset(AppAssets.featherIcon,width: 24.w, height: 24.h,
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)),
            );
          }
          return const SizedBox.shrink();
        }),
      );
    });
  }

  Widget _buildTabContentByName(String tabName) {
    switch (tabName) {
      case 'Reactions':     return const ReactionsTab();
      case 'For you':       return const ForYouTab();
      case 'Local':         return const LocalTab();
      case 'Local Tv':      return const LocalTvTab();
      case 'Entertainment': return const EntertainmentTab();
      case 'Sports':        return const SportsTab();
      case 'Food':          return const FoodTab();
      case 'Health':        return const HealthTab();
      case 'Beauty':        return const BeautyTab();
      case 'Weather':       return const WeatherTab();
      default:              return const ReactionsTab();
    }
  }
}