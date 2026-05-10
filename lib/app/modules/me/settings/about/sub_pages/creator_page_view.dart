import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../../../controllers/me/settings/creator_page_controller.dart';
import '../../../../../models/creator_page_model.dart';
import 'help_widgets.dart';
import 'open_positions_view.dart';


class CreatorPageView extends StatelessWidget {
  final String pageKey;

  const CreatorPageView({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreatorPageController(), tag: pageKey);
    controller.loadPageData(pageKey);

    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(backgroundColor: Colors.white,
          body: Center(
              child: CircularProgressIndicator(color:Colors.black)),
        );
      }
      final data = controller.currentPageData.value;

      if (data == null) return const SizedBox.shrink();

      return _buildCreatorPage(
        context: context,
        data: data,
        primaryOnTap: () {
          switch (pageKey) {
            case 'careers':
              Get.to(() => const OpenPositionsView());
              break;
          }
        },
        secondaryOnTap: () {},
      );
    });
  }

  Widget _buildCreatorPage({
    required BuildContext context,
    required HelpPageData data,
    required VoidCallback primaryOnTap,
    VoidCallback? secondaryOnTap,
  }) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HelpWidgets.helpAppBar('Help Center'),
      body: Column(
        children: [
          const HelpTabBar(),
          Expanded(
            child: ListView(
              children: [
                // Hero Section
                Padding(
                  padding:  EdgeInsets.all(16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.heroTitle, style: AppTextStyles.chart.copyWith(color: Colors.black)),
                       SizedBox(height: 8.h),
                      Text(data.heroDesc, style: AppTextStyles.overline.copyWith(color: Color(0xFF6C6C6C))),

                      // Primary Button Logic
                      if (data.primaryBtn != null) ...[
                        SizedBox(height: 24.h),
                        Center(child: _customButton(data.primaryBtn!,
                            primaryOnTap, isPrimary: true)),
                      ],

                      // Secondary Button Logic
                      if (data.secondaryBtn != null) ...[
                         SizedBox(height: 10.h),
                        Center(child: _customButton(data.secondaryBtn!,
                            secondaryOnTap ?? () {}, isPrimary: false)),
                      ],
                    ],
                  ),
                ),

                // Mission Section
                _buildMissionSection(data),

                // Stats Section
                Center(child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                    child: Text(data.statsTitle, style: AppTextStyles.head))),
                ...data.stats.map((stat) => _buildStatTile(stat)),

                 SizedBox(height: 8.h),
                HelpWidgets.helpFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customButton(String label, VoidCallback onTap,
      {required bool isPrimary}) {
    return SizedBox( width: 335.w, height: 48.h,
      child: isPrimary
          ? ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor:Color(0xFF7B83EB),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r))),
        child: Text(label, style: AppTextStyles.buttonOutline.copyWith(color: Colors.white)))
          : OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Color(0xFFEDEDED),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r))),
        child: Text(label, style: AppTextStyles.buttonOutline.copyWith(color:Color(0xFF7B83EB)))),
    );
  }

  Widget _buildMissionSection(HelpPageData data) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HelpWidgets.redChip(data.chip),
           SizedBox(height: 8.h),
          Text(data.missionTitle, style: AppTextStyles.chart.copyWith(color: Colors.black)),
           SizedBox(height: 8.h),
          Text(data.missionDesc, style: AppTextStyles.overline.copyWith(color: Color(0xFF6C6C6C))),
           SizedBox(height: 16.h),
          Center(
              child: SizedBox(
              width: double.infinity, height: 180.h,
              child: SvgPicture.asset(AppAssets.helpPeopleIcon))),
        ],
      ),
    );
  }

  Widget _buildStatTile(Map<String, String> stat) {
    return Padding(
      padding:  EdgeInsets.fromLTRB(16.w, 8.h, 16.h, 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(stat['number']!, style: AppTextStyles.headlineLarge.copyWith(color: Colors.black)),
           SizedBox(height: 4.h),
          Text(stat['label']!, style: AppTextStyles.label),
           SizedBox(height: 8.h),
           Divider(color: Color(0xFFEDEDED), height: 1),
           SizedBox(height: 8.h),
          Text(stat['desc']!, style: AppTextStyles.caption.copyWith(color: Colors.black)),
           SizedBox(height: 8.h),
        ],
      ),
    );
  }
}