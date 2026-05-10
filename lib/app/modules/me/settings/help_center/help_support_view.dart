import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../../controllers/me/settings/help_center_controller.dart';
import '../about/sub_pages/help_widgets.dart';
import 'help_detail_view.dart';

class HelpSupportView extends StatelessWidget {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HelpCenterController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios, color: AppColors.textOnDark, size: 20.sp)),
        title: Text('Help & Support', style: AppTextStyles.displaySmall.copyWith(color: AppColors.white)),
        centerTitle: true),

      body: Column(
        children: [
          // Header bar
          Container(height: 30.h,
              padding:  EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                  border: Border.all(color: Get.isDarkMode?Color(0xFFDDDDDD):Color(0xFFEDEDED)),
                  color:Get.isDarkMode?Colors.white:Color(0xFFEDEDED)),
              child: Center(
                  child:Text('Help Center', style: AppTextStyles.bodyMedium.copyWith(color: Color(0xFF242424))))),

          Expanded(child: _buildBody(controller)),
        ],
      ),
    );
  }

  Widget _buildBody(HelpCenterController controller) {
    return ListView(
      children: [
        _buildHeroBanner(controller),
        _buildCategories(controller),
         SizedBox(height: 16.h),
        _buildPromotedArticlesHeader(),
        _buildPromotedArticles(controller),
        SizedBox(height: 16.h),
        HelpWidgets.helpFooter(),
         SizedBox(height: 24.h),
      ],
    );
  }

  //  Hero Banner with Search
  Widget _buildHeroBanner(HelpCenterController controller) {
    return Stack(
      children: [
        Image.asset('assets/images/banar_bg.png', width: double.infinity, height: 150.h,
          fit: BoxFit.cover),
        Positioned.fill(child: Container(color: Colors.black38)),
        Positioned( left: 20.w, right: 20.w, top: 30.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Hi, How Can We Help You?', textAlign: TextAlign.center,
                style: AppTextStyles.label.copyWith(color: Colors.white)),
               SizedBox(height: 20.h),
              Container(width: 306.w, height: 40.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:Colors.white,
                  borderRadius: BorderRadius.circular(8.r)),
                child: TextField(
                  controller: controller.searchController,
                  onChanged: controller.runSearch,
                  textAlignVertical: TextAlignVertical.center,
                  style: AppTextStyles.caption.copyWith(color: Colors.black),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'search issue keywords',
                    hintStyle: AppTextStyles.overline.copyWith(fontSize: 14.sp),
                    prefixIcon: Icon(Icons.search, color:AppColors.textOnDark, size: 22.sp),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //  Categories
  Widget _buildCategories(HelpCenterController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: [
           SizedBox(height: 32.h),
          Obx(() => Column(
            children: controller.displayCategories.map((cat) {
              return GestureDetector(
                onTap: cat.isClickable
                    ? () => Get.to(() => HelpDetailView(title: cat.name))
                    : null,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x40888787),
                        blurRadius: 32,
                        offset: Offset.zero),
                    ],
                  ),
                  child: Center(
                    child: Text( cat.name, style: AppTextStyles.caption.copyWith(
                        color: AppColors.linkColor)))),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }

  // Promoted Articles Header
  Widget _buildPromotedArticlesHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 8.h),
      child: Text('Promoted Articles', style: AppTextStyles.displaySmall.copyWith(color: Colors.black)),
    );
  }

  // Promoted Articles List
  Widget _buildPromotedArticles(HelpCenterController controller) {
    return Obx(() {
      final articles = controller.displayArticles;
      return Column(
        children: articles.asMap().entries.map((entry) {
          int index = entry.key;
          var article = entry.value;
          bool isLast = index == articles.length - 1;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(article.title,
                    style: AppTextStyles.overline.copyWith(fontSize: 14.sp)))),
              if (!isLast)
                const Divider(height: 1, color: Color(0xFFCCCCCC)),
            ],
          );
        }).toList(),
      );
    });
  }
}