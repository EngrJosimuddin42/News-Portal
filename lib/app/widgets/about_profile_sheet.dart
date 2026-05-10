import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:news_break/app/theme/app_colors.dart';
import '../models/news_model.dart';
import '../theme/app_text_styles.dart';

class AboutProfileSheet extends StatelessWidget {
  final String publisherName;
  final String publisherType;
  final String publisherMeta;

  const AboutProfileSheet({
    super.key,
    required this.publisherName,
    required this.publisherType,
    required this.publisherMeta,
  });

  static void show(BuildContext context, {
    required String publisherName,
    required String publisherType,
    required String publisherMeta,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      isScrollControlled: true,
      builder: (_) => AboutProfileSheet(
        publisherName: publisherName,
        publisherType: publisherType,
        publisherMeta: publisherMeta),
    );
  }

  static void showFromNews(BuildContext context, NewsModel news) {
    show(context,
      publisherName: news.publisherName,
      publisherType: news.publisherType ?? '',
      publisherMeta: news.publisherMeta);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.search,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text('About this profile',
                style: AppTextStyles.headlineMedium.copyWith(color: AppColors.white), textAlign: TextAlign.center)),
           SizedBox(height: 24.h),

          // Publisher Name
          Text(publisherName, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white)),
           SizedBox(height: 16.h),
           Divider(color:Get.isDarkMode? Color(0xFF3D3C3C):Color(0xFFEDEDED), height: 1),
          SizedBox(height: 16.h),

          // Publisher Type + Meta
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Joined', style: AppTextStyles.caption.copyWith(color: AppColors.white)),

              if (publisherType.isNotEmpty && publisherMeta.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  publisherMeta,
                  style: AppTextStyles.caption.copyWith(color: const Color(0xFFC4C4C4)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ],
          ),

          SizedBox(height: 16.h),
          Divider(color:Get.isDarkMode? Color(0xFF3D3C3C):Color(0xFFEDEDED), height: 1),
          SizedBox(height: 12.h),

          RichText(
            text: TextSpan( style: AppTextStyles.overline,
              children: [
                const TextSpan(text: 'All content is required to comply with our '),
                TextSpan(text: 'Community Standards', style: AppTextStyles.overline.copyWith(
                  color: const Color(0xFF56CCF2),decoration: TextDecoration.underline,decorationColor: const Color(0xFF56CCF2))),
                const TextSpan(text: '. Please help us keep our socials safe by reporting any violations.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}