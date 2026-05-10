import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../../../controllers/me/settings/blog_controller.dart';
import '../../../../../models/blog_model.dart';
import 'help_widgets.dart';

class BlogView extends StatelessWidget {
  const BlogView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BlogController());
    return Scaffold(
      backgroundColor: const Color(0xFF252F39),
      appBar: HelpWidgets.helpAppBar('Help Center'),
      body: Column(
        children: [
          const HelpTabBar(),
          Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: controller.posts.map((post) => _buildCard(post)).toList())),
                  HelpWidgets.helpFooter(),
                ],
              ),
                );
              }),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BlogPost post) {
    return Container(
      margin:EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.circular(12.r)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
             Image.network( post.imageUrl,
              width: double.infinity,
               fit: BoxFit.fitWidth,
                 errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[200],
              child:Icon(Icons.image, color: Colors.grey, size: 48.sp))),
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag
                Text(post.tag, style:AppTextStyles.overline.copyWith(color:Color(0xFF242424))),
                 SizedBox(height: 6.h),

                // Title
                Text(post.title, style:AppTextStyles.bodySmall.copyWith(color: Color(0xFF242424))),
                 SizedBox(height: 8.h),

                // Body
                Text(post.body, style: AppTextStyles.overline.copyWith(color:Color(0xFF242424))),
                 SizedBox(height: 12.h),

                // Author + date
                Row(
                  children: [
                    Text(post.author, style: AppTextStyles.bodySmall.copyWith(color:Color(0xFF242424))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('|', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textOnDark)),
                    ),
                    Text(post.date, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textOnDark)),
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