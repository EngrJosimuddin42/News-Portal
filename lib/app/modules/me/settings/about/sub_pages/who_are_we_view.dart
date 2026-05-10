import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../../../controllers/me/settings/who_are_we_controller.dart';
import '../../../../../widgets/custom_network_image.dart';
import 'help_widgets.dart';

class WhoAreWeView extends StatelessWidget {
  WhoAreWeView({super.key});

  final WhoAreWeController controller = Get.put(WhoAreWeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HelpWidgets.helpAppBar('Help Center'),
      body: Column(
        children: [
          const HelpTabBar(),
        Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color:Colors.black));
              }
              if (!controller.isLoading.value && controller.aboutSections.isEmpty) {
                return const Center(child: Text("No information available."));
              }

              return ListView(
              children: [
                // About & Story
                ...controller.aboutSections.map((section) => Padding(
                  padding:  EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HelpWidgets.redChip(section.chip),
                       SizedBox(height: 8.h),
                      Text(section.title, style: AppTextStyles.chart.copyWith(color: Colors.black)),
                       SizedBox(height: 12.h),
                      Text(section.desc, style:AppTextStyles.overline.copyWith(color: Color(0xFF6C6C6C))),
                       SizedBox(height: 12.h),

                       CustomNetworkImage(imageUrl: section.image),

                      SizedBox(height: 16.h),
                    ],
                  ),
                )),

                // Team
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Some people we\'d like\nyou to meet', textAlign: TextAlign.center, style:AppTextStyles.head )),

                ...controller.teamList.map((member) => Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Column(
                    children: [
                      CircleAvatar( radius: 36.r,
                        backgroundImage: NetworkImage(member.imageUrl)),
                      SizedBox(height: 8.h),
                      Text(member.name, style: AppTextStyles.button.copyWith(color: Color(0xFF333333))),
                      Text(member.role, style: AppTextStyles.textSmall.copyWith(color: Color(0xFF6C6C6C))),
                       SizedBox(height: 12.h),
                       Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(member.bio, textAlign: TextAlign.center, style: AppTextStyles.overline)),
                    ],
                  ),
                )),

                HelpWidgets.helpFooter(),
              ],
              );
            }),
        ),
        ],
      ),
    );
  }
}