import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../../controllers/home_controller.dart';
import '../ad_video_card.dart';
import '../category_news_card.dart';

class WeatherTab extends GetView<HomeController> {
  const WeatherTab({super.key});
  bool get _showAds => controller.isLoggedIn;


  @override
  Widget build(BuildContext context) {

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final hasLocation = controller.selectedLocation.value != null;
      return hasLocation ? _buildWithLocation() : _buildWithoutLocation();
    });
  }

  Widget _buildWithoutLocation() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 4.h, bottom: 16.h),
      itemCount: controller.weatherNews.length,
      itemBuilder: (context, index) {
        final news = controller.weatherNews[index];
        if (news.publisherType == 'Ad') {
          return _showAds ? AdVideoCard(news: news) : const SizedBox.shrink();
        }
        return CategoryNewsCard(news: news, tabType: 'news_weather');
      },
    );
  }

  Widget _buildWithLocation() {
    return ListView(
      padding: EdgeInsets.only(bottom: 16.h),
      children: [
        _buildWeatherWidget(),
        SizedBox(height: 16.h),
         Divider(color:AppColors.border, height: 2, thickness: 3),
         SizedBox(height: 16.h),

        ...controller.weatherNews.map((news) {
          if (news.publisherType == 'Ad') {
            return _showAds ? AdVideoCard(news: news) : const SizedBox.shrink();
          }
          return CategoryNewsCard(news: news, tabType: 'news_weather');
        }),
      ],
    );
  }

  Widget _buildWeatherWidget() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Temperature + icon
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Obx(() =>  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(controller.currentTemp.value, style: AppTextStyles.tagline.copyWith(
                          color:AppColors.white )),
                       SizedBox(width: 6.w),
                      SvgPicture.asset(controller.weatherIcon.value, width: 32.w, height: 32.h),
                    ],
                  ),
                   SizedBox(height: 12.h),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: controller.lowHighTemp.value, style: AppTextStyles.overline),
                         WidgetSpan(child: SizedBox(width: 6.w)),
                        TextSpan(text: controller.weatherCondition.value,style: AppTextStyles.small.copyWith(color: const Color(0xFFC4C4C4)))
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
    ),
    ),

           SizedBox(height: 16.h),

          // Activities
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child:   Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _activityItem(AppAssets.emojiIcon, AppAssets.mountainIcon, 'Hiking'),
               SizedBox(width: 16.w),
              _activityItem(AppAssets.emojiIcon, AppAssets.leavesIcon, 'Gardening'),
            ],
          ),
    ),

           SizedBox(height: 16.h),
           Divider(color:AppColors.border, height: 2, thickness: 3),
           SizedBox(height: 16.h),

          // Forecasts header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Obx(() => Row(
            children: [
              Text('Forecasts', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white)),
              const Spacer(),
              SvgPicture.asset(AppAssets.sunriseIcon),
               SizedBox(width: 6.w),
              Text(controller.sunriseTime.value, style: AppTextStyles.display.copyWith(color: const Color(0xFFC4C4C4))),
               SizedBox(width: 24.w),
              SvgPicture.asset(AppAssets.sunsetIcon),
               SizedBox(width: 6.w),
              Text(controller.sunsetTime.value, style: AppTextStyles.display.copyWith(color: const Color(0xFFC4C4C4)))
            ],
          ),
        ),
          ),

           SizedBox(height: 12.h),

          // Hourly / Daily toggle
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child:  Obx(() => Row(
            children: [
              _toggleChip('Hourly', controller.isHourly.value),
              SizedBox(width: 8.w),
              _toggleChip('Daily', !controller.isHourly.value),
            ],
          ))),

           SizedBox(height: 12.h),

          // Forecast scroll
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Obx(() => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: (controller.isHourly.value
                  ? controller.hourlyForecast
                  : controller.dailyForecast)
                  .map((item) => _forecastItem(item))
                  .toList(),
            ),
          ))),
        ],
      );
  }


  Widget _activityItem(String topIcon, String bottomIcon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container( width: 70.w,  height: 100.h,
          padding:  EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF4C4C4C), width: 1),
            borderRadius: BorderRadius.circular(10.r)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(topIcon, width: 24.w, height: 24.h),
              SizedBox(height: 12.h),
              SvgPicture.asset(bottomIcon, width: 24.w, height: 24.h),
            ],
          ),
        ),
         SizedBox(height: 12.h),
        Text(label, style: AppTextStyles.overline),
      ],
    );
  }


  Widget _toggleChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.isHourly.value = (label == 'Hourly'),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ?AppColors.white: const Color(0xFF424242),
          borderRadius: BorderRadius.circular(20.r)),
        child: Text(label, style: AppTextStyles.caption.copyWith(
              color: isSelected ?Get.isDarkMode?Color(0xFF242424):Color(0xFFDBDBDB): AppColors.white))),
    );
  }

  Widget _forecastItem(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        border: Border.all(color: Color(0xFF333333)),
        borderRadius: BorderRadius.circular(10.r)),
      child: Column(
        children: [
          Text(item['time']!, style: AppTextStyles.display.copyWith(color: AppColors.textOnDark)),
           SizedBox(height: 6.h),
          SvgPicture.asset(item['icon']!, width: 24.w, height: 24.h),
           SizedBox(height: 6.h),
          Text(item['temp']!, style:AppTextStyles.display.copyWith(color: AppColors.white)),
        ],
      ),
    );
  }
}