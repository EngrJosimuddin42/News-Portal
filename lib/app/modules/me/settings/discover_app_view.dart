import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';

import '../../../controllers/me/settings/discover_app_controller.dart';
import '../../../widgets/publisher_avatar.dart';

class DiscoverAppView extends StatelessWidget {
  const DiscoverAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DiscoverAppController());

    return Scaffold(
      backgroundColor:AppColors.scaffoldBg,
      appBar: AppBar(
          backgroundColor:AppColors.scaffoldBg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child:Icon(Icons.arrow_back_ios, color: AppColors.white, size: 20.sp)),
        title:Text('Discover App', style: AppTextStyles.displaySmall.copyWith(color: AppColors.white)),
        centerTitle: true),

        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator(color: AppColors.white));
          }

          return ListView.separated(
            padding:  EdgeInsets.only(top: 8.h),
            itemCount: controller.appsList.length,
            separatorBuilder: (context, index) =>  Divider(color:Get.isDarkMode?Color(0xFF323232):Color(0xFFCDCDCD), height: 1),
            itemBuilder: (_, i) {
              final app = controller.appsList[i];

              return ListTile(
                contentPadding:EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),

                leading: PublisherAvatar.fromUrl(
                  imageUrl: app['imageUrl'] ?? '',
                  name: app['name'] ?? 'App',
                  size: 56.0.sp,
                  shape: BoxShape.rectangle),
               title: Text(app['name']!, style:AppTextStyles.headlineMedium.copyWith(color: AppColors.white)),
            subtitle: Text(app['subtitle']!, style:AppTextStyles.caption.copyWith(color: AppColors.white)),
            onTap: () {},
          );
        },
        );
    }),
  );
}
}