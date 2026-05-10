import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../controllers/me/me_controller.dart';

class CreatorOnboardView extends StatefulWidget {
  const CreatorOnboardView({super.key});

  @override
  State<CreatorOnboardView> createState() => _CreatorOnboardViewState();
}

class _CreatorOnboardViewState extends State<CreatorOnboardView> {
  final PageController _pageController = PageController();
  final controller = Get.find<MeController>();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.scaffoldBg,
      body: Stack(
        children: [
          _buildPageView(),

          _buildBackButton(),

          _buildBottomActions(),
        ],
      ),
    );
  }


  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: controller.onboardSlides.length,
      onPageChanged: (i) => setState(() => _currentPage = i),
      itemBuilder: (_, i) {
        final slide = controller.onboardSlides[i];
        return Stack(
          children: [
            _buildBackgroundImage(slide['imageUrl'] ?? ''),
            _buildDarkOverlay(),
            _buildRightActions(slide),
            _buildBottomContent(slide),
          ],
        );
      },
    );
  }


  Widget _buildBackgroundImage(String url) {
    return Positioned.fill(
      child: url.isNotEmpty
          ? Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : Center(child: CircularProgressIndicator(color:AppColors.white, strokeWidth: 2)),
        errorBuilder: (context, error, stackTrace) =>
            Container(color: Colors.grey[900], child: const Icon(Icons.broken_image, color: Colors.white24)))
          : Container(color: Colors.grey[900]),
    );
  }


  Widget _buildDarkOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black87],
            stops: [0.4, 1.0]))),
    );
  }

  Widget _buildRightActions(Map<String, String> slide) {
    return Positioned( right: 16.w,
      top: MediaQuery.of(context).size.height * 0.43,
      child: Column(
        children: [
          _buildAvatarWithPlus(),
           SizedBox(height: 16.h),
          _buildActionButton(AppAssets.like1Icon, slide['likes'] ?? '0'),
           SizedBox(height: 16.h),
          _buildActionButton(AppAssets.comment2Icon, slide['comments'] ?? '0'),
           SizedBox(height: 16.h),
          _buildActionButton(AppAssets.share1Icon, 'Share'),
           SizedBox(height: 16.h),
           Icon(Icons.more_vert, color: Colors.white, size: 32.sp),
        ],
      ),
    );
  }


  Widget _buildBottomContent(Map<String, String> slide) {
    return Positioned( bottom: 140.h, left: 16.w,  right: 80.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
            children: [
              Text( slide['followers'] ?? '0',
              style: AppTextStyles.displayMedium.copyWith(
                  color:Colors.white,fontWeight: FontWeight.w500)),

              SizedBox(height: 4.h),
              Text('Followers',
                  style: AppTextStyles.displayMedium.copyWith(
                      color:Colors.white,fontWeight: FontWeight.w500)),
            ],
          ),
    ),
           SizedBox(height: 32.h),
          Text( slide['title'] ?? '', style: AppTextStyles.headlineLarge.copyWith(color: Colors.white)),
           SizedBox(height: 8.h),
          Text(slide['subtitle'] ?? '', style: AppTextStyles.display.copyWith(color: Color(0xFFB4B4B4)), maxLines: 3,
            overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }


  Widget _buildBottomActions() {
    return Positioned( bottom: 5, left: 0, right: 0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.onboardSlides.length,
                  (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin:  EdgeInsets.symmetric(horizontal: 3.h),
                width: 8.w, height: 8.h,
                decoration: BoxDecoration(
                  color: _currentPage == i ? Colors.white : Color(0xFF6E6D6D),
                  shape: BoxShape.circle)))),
             SizedBox(height: 10.h),

          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 26.h),
            child: SizedBox(
              width: double.infinity, height: 50.h,
              child: ElevatedButton(
                onPressed: () {
                  controller.completeOnboarding();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
                child: Text('Create Now', style: AppTextStyles.bodyMedium.copyWith(
                    color:Color(0xFF242424)))))),
        ],
      ),
    );
  }


  Widget _buildBackButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10, left: 16.w,
      child: GestureDetector(
      onTap: () => Get.back(),
      child:Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp)),
    );
  }

  Widget _buildAvatarWithPlus() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
         CircleAvatar(
          radius: 22.r,
          backgroundImage: AssetImage('assets/images/timer.png')),
        Positioned( bottom: -5, left: 13.w,
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration:  BoxDecoration(color: AppColors.textGreen, shape: BoxShape.circle),
            child: Icon(Icons.add, color: Colors.white, size: 14.sp))),
      ],
    );
  }

  Widget _buildActionButton(String svgPath, String label) {
    return Column(
      children: [
        SvgPicture.asset(svgPath, width: 35.w, height: 35.h,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
        SizedBox(height: 4.h),
        Text(label, style: AppTextStyles.buttonOutline.copyWith(fontSize: 12.sp,color: Colors.white)),
      ],
    );
  }
}