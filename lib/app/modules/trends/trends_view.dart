import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../controllers/reels/trends_controller.dart';
import '../../controllers/search_page_controller.dart';
import '../../modules/search/search_page_view.dart';
import '../home/widgets/home_week_bar.dart';
import '../home/widgets/news_card.dart';

class TrendsView extends GetView<TrendsController> {
  const TrendsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(context),
            const HomeWeekBar(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.filteredNews.isEmpty) {
                  return Center(
                    child: Text('No news found',
                        style: AppTextStyles.bodyMedium.copyWith( color: AppColors.info)),
                  );
                }
                return RefreshIndicator(
                  onRefresh: controller.refresh,
                  child: ListView.builder(
                    itemCount: controller.filteredNews.length,
                    itemBuilder: (_, i) => NewsCard(
                      news: controller.filteredNews[i],
                      tabType: 'trends',
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Obx(() {
      final topic = controller.selectedTopic.value;
      return Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Get.delete<SearchPageController>(force: true);
                  final ctrl = Get.put(SearchPageController());

                  ctrl.source = 'trends';
                  ctrl.loadItems();

                  Get.to(
                        () => const SearchPageView(),
                    transition: Transition.fadeIn,
                    duration: const Duration(milliseconds: 200),
                  );
                },
                child: Container( height: 40.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    color: Get.isDarkMode? Color(0xFF121212):Colors.white,
                    borderRadius: BorderRadius.circular(8.r)),
                  child: Row(
                    children: [
                      SizedBox(width: 12.w),
                       Icon(Icons.search, color:AppColors.textOnDark, size: 20.sp),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          topic.isEmpty ? 'Search' : topic,
                          style: AppTextStyles.caption.copyWith(
                              color: topic.isEmpty ? Colors.grey :AppColors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      if (topic.isNotEmpty)
                        GestureDetector(
                          onTap: controller.clearFilter,
                          child: Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: Icon(Icons.cancel, color: Colors.grey, size: 18.sp),
                          ),
                        )
                      else
                        SizedBox(width: 12.w),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}