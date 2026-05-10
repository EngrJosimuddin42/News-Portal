import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/modules/me/settings/about/sub_pages/what_we_do_view.dart';
import 'package:news_break/app/modules/me/settings/about/sub_pages/who_are_we_view.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../../../controllers/me/settings/settings_controller.dart';
import '../legal_view.dart';
import 'blog_view.dart';
import 'creator_page_view.dart';

class HelpWidgets {
  // Shared AppBar
  static AppBar helpAppBar(String title, {bool showCloseIcon = true}) {
    return AppBar(
      backgroundColor:AppColors.scaffoldBg,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child:Icon(Icons.arrow_back_ios, color:AppColors.textOnDark, size: 20.sp)),
      title: Text(title, style: AppTextStyles.displaySmall),
      centerTitle: true,
      actions: [
        if (showCloseIcon)
        GestureDetector(
          onTap: () => Get.back(),
          child: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Icon(Icons.close, color:AppColors.textOnDark, size: 20.sp))),
      ],
    );
  }

// Shared Footer
  static Widget helpFooter() {
    final String year = DateTime.now().year.toString();
    if (!Get.isRegistered<SettingsController>()) {
      Get.put(SettingsController());
    }
    final SettingsController controller = Get.find<SettingsController>();
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        children: [
           SizedBox(height: 40.h),
           Divider(height: 1, color: Color(0xFFCCCCCC)),
           SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //  Terms of Use
                GestureDetector(
                  onTap: () => Get.to(() => const LegalView(type: LegalType.terms)),
                  child: Text('Terms of Use', style: AppTextStyles.overline.copyWith(color:Color(0xFF242424)))),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 8.h),
                  child: Text('|', style: AppTextStyles.overline.copyWith(color: Color(0xFF242424)))),

                //  Privacy Policy
                GestureDetector(
                  onTap: () => Get.to(() => const LegalView(type: LegalType.privacy)),
                  child: Text('Privacy Policy', style: AppTextStyles.overline.copyWith(color: Color(0xFF242424)))),
              ],
            ),
          ),
          Text('© $year Particle Media. All Rights Reserved.', style: AppTextStyles.overline),
           SizedBox(height: 8.h),

          //  English (US)
          Obx(() => GestureDetector(
            onTap: () => controller.showLanguagePicker(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.currentLanguageName, style: AppTextStyles.overline.copyWith(color:Color(0xFF242424))),
                 Icon(Icons.keyboard_arrow_down, color:Color(0xFF242424), size: 20.sp),
              ],
            ),
          )),
           SizedBox(height: 32.h),
        ],
      ),
    );
  }

// Red chip
  static Widget redChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E8FE),
        borderRadius: BorderRadius.circular(10)),
      child: Text(label, style:AppTextStyles.buttonOutline.copyWith(color: Color(0xFF7B83EB))),
    );
  }
}

// Shared Tab Bar with Dropdown
class HelpTabBar extends StatefulWidget {
  const HelpTabBar({super.key});

  @override
  State<HelpTabBar> createState() => _HelpTabBarState();
}

class _HelpTabBarState extends State<HelpTabBar> {
  OverlayEntry? _overlayEntry;
  final List<GlobalKey> _tabKeys = List.generate(4, (_) => GlobalKey());

  static const List<String> _tabs = ['Company', 'Partners', 'Solutions', 'Resources'];

  final Map<String, List<String>> _tabItems = {
    'Company': ['What we do', 'Who are we', 'Careers'],
    'Partners': ['Contributors', 'Publishers', 'Advertisers'],
    'Resources': ['Podcast', 'Blog'],
  };

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showDropdown(int tabIndex) {
    _removeOverlay();

    final RenderBox? renderBox = _tabKeys[tabIndex].currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final items = _tabItems[_tabs[tabIndex]] ?? [];

    _overlayEntry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand())),
          Positioned(
            left: position.dx,
            top: position.dy + renderBox.size.height,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8.r),
              child: Container( width: 160.w,
                decoration: BoxDecoration(
                  color: Color(0xFFE7EDED),
                  borderRadius: BorderRadius.circular(8.r)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: items.map((item) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _removeOverlay();
                            switch (item) {
                              case 'What we do':
                                Get.to(() => WhatWeDoView());
                                break;
                              case 'Who are we':
                                Get.to(() => WhoAreWeView());
                                break;
                              case 'Careers':
                                Get.to(() => const CreatorPageView(pageKey: 'careers'),preventDuplicates: false);
                                break;
                              case 'Contributors':
                                Get.to(() => const CreatorPageView(pageKey: 'default'),preventDuplicates: false);
                                break;
                              case 'Publishers':
                                Get.to(() => const CreatorPageView(pageKey: 'default'),preventDuplicates: false);
                                break;
                              case 'Advertisers':
                                Get.to(() => const CreatorPageView(pageKey: 'default'),preventDuplicates: false);
                                break;
                              case 'Podcast':
                                Get.to(() => const CreatorPageView(pageKey: 'default'),preventDuplicates: false);
                                break;
                              case 'Blog':
                               Get.to(() => const BlogView());
                                break;
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                            color: Colors.transparent,
                            child: Text(item, style: AppTextStyles.caption.copyWith(color: Color(0xFF252F39))))),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(  width:double.infinity, height: 48.h,
      color: Color(0xFFE7EDED),
      child: Center(
        child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_tabs.length, (i) {
            return GestureDetector(
              key: _tabKeys[i],
              onTap: () => _showDropdown(i),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Text(_tabs[i],
                    style: TextStyle(color: Colors.black54, fontSize: 13.sp))),
            );
          }),
        ),
      ),
      ),
    );
  }
}