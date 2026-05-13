import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import 'package:news_break/app/widgets/bottom_sheet_handle.dart';
import '../../controllers/me/me_controller.dart';
import '../../controllers/me/settings/settings_controller.dart';

class CreatorDashboardView extends StatefulWidget {
  const CreatorDashboardView({super.key});

  @override
  State<CreatorDashboardView> createState() => _CreatorDashboardViewState();
}

class _CreatorDashboardViewState extends State<CreatorDashboardView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final controller = Get.find<MeController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      controller.selectedDashboardTab.value = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = SettingsController.to.isDarkMode.value;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: AppColors.scaffoldBg,
          elevation: 0,
          leading: GestureDetector(
              onTap: () => Get.back(),
              child: Icon(Icons.arrow_back_ios, color: AppColors.textOnDark,
                  size: 20.sp)),
          title: Text('creator_dashboard'.tr,
              style: AppTextStyles.displaySmall.copyWith(
                  color: AppColors.white)),
          centerTitle: true,
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(48.h),
              child: ColoredBox(
                  color: Colors.white,
                  child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.grey,
                      indicatorWeight: 2,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: AppTextStyles.bodySmall.copyWith(
                          color: isDark? Color(0xFF242424) : Color(0xFFDBDBDB)),
                      unselectedLabelStyle: AppTextStyles.caption.copyWith(
                          color: isDark? Color(0xFF242424) : AppColors.textOnDark),
                    tabs: [
                      Tab(text: 'engagement'.tr),
                      Tab(text: 'followers_tab'.tr),
                    ])))),

      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEngagementTab(),
          _buildFollowersTab(),
        ],
      ),
    );
  });
  }

  // Engagement Tab
  Widget _buildEngagementTab() {
    return Obx(() {
      final selectedStat = controller.engagementStats.firstWhere(
            (element) => element['isSelected'] == true,
        orElse: () => controller.engagementStats[0]);
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDateRow(isDark: SettingsController.to.isDarkMode.value),
          SizedBox(height: 16.h),
          Row(
            children: controller.engagementStats.asMap().entries.map((entry) {
              int idx = entry.key;
              var stat = entry.value;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: idx == controller.engagementStats.length - 1 ? 0 : 12),
                  child: GestureDetector(
                    onTap: () => controller.selectStat(idx, true),
                    child: _statCard(
                      label: stat['label'],
                      value: stat['value'],
                      percent: stat['percent'],
                      isSelected: stat['isSelected'],
                      isDark: SettingsController.to.isDarkMode.value,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

         SizedBox(height: 16.h),
          _buildChart(
            title: selectedStat['label'],
            value: selectedStat['value'],
            isDark: SettingsController.to.isDarkMode.value,
          ),
        ],
      );
    });
  }

  // Followers Tab
  Widget _buildFollowersTab() {
    return Obx(() {
      final selectedFollowerStat = controller.followerStats.firstWhere(
            (element) => element['isSelected'] == true,
        orElse: () => controller.followerStats[0],
      );
      return ListView(
        padding:  EdgeInsets.all(16.h),
        children: [
          _buildDateRow(isDark: SettingsController.to.isDarkMode.value),
          SizedBox(height: 16.h),
          Row(
            children: controller.followerStats.asMap().entries.map((entry) {
              int idx = entry.key;
              var stat = entry.value;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: idx == controller.followerStats.length - 1 ? 0 : 12),
                  child: GestureDetector(
                    onTap: () => controller.selectStat(idx, false),
                    child: _statCard(
                      label: stat['label'],
                      value: stat['value'],
                      percent: stat['percent'],
                      isSelected: stat['isSelected'],
                      isDark: SettingsController.to.isDarkMode.value,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16.h),
          _buildChart(
            title: selectedFollowerStat['label'],
            value: selectedFollowerStat['value'],
            isDark: SettingsController.to.isDarkMode.value,
          ),
        ],
      );
    });
  }

  //  Date row
  Widget _buildDateRow({required bool isDark}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() => Text(
          controller.currentDateRange.value,
          style: AppTextStyles.caption.copyWith(color: AppColors.textOnDark))),
        GestureDetector(
          onTap: _showDateRangePicker,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color:isDark?Color(0xFFF0F0F0):Colors.white,
              border: Border.all(color:isDark?Color(0xFFF0F0F0):Color(0xFFEDEDED)),
              borderRadius: BorderRadius.circular(38.r)),
            child: Row(
              children: [
                Obx(() => Text(controller.currentLabel.value.tr,
                    style: AppTextStyles.caption.copyWith(color: const Color(0xFF606060)))),
                 SizedBox(width: 4.w),
                 Icon(Icons.keyboard_arrow_down, size: 16.sp, color: Color(0xFF636363)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //  Stat card
  Widget _statCard({
    required String label,
    required String value,
    required String percent,
    required bool isSelected,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isSelected
            ? isDark? const Color(0xFFE6F2FE):Colors.white
            : Colors.white,
        border: Border.all(
          color: isSelected
              ? isDark? const Color(0xFF3498FA):Color(0xFFEDEDED)
              : isDark?const Color(0xFFE5E5E5):Color(0xFFEDEDED),
          width: 1),
        borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label.tr,
                style: AppTextStyles.bodySmall.copyWith(color: isSelected?AppColors.textGreen :isDark?Color(0xFF242424):Color(0xFF959595))),
               SizedBox(width: 4.h),
              Icon(Icons.info_outline, size: 16.sp, color: isSelected ? AppColors.textGreen :isDark?Color(0xFF242424):Color(0xFF959595)),
            ],
          ),
          SizedBox(height: 8.h),
          Text(value,
            style: AppTextStyles.headlineLarge.copyWith(color: isSelected ? AppColors.textGreen :isDark?Color(0xFF242424):Color(0xFF959595))),
          Text(percent,
            style: AppTextStyles.caption.copyWith(color: isSelected ? AppColors.textGreen :isDark?Color(0xFF242424):Color(0xFF959595))),
        ],
      ),
    );
  }

  //  Chart
  Widget _buildChart({required String title, required String value,required bool isDark}) {
    return Container(
      padding:  EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        border: Border.all(color:isDark? Color(0xFFE4E4E4):Color(0xFFEDEDED)),
        borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.tr, style: AppTextStyles.caption.copyWith(color:isDark?Color(0xFF242424):Color(0xFF959595))),
           SizedBox(height: 4.h),
          Text(value, style: AppTextStyles.chart.copyWith(color:isDark?Color(0xFF242424):Color(0xFF959595))),
           SizedBox(height: 32.h),
          SizedBox(height: 160.h,
            child: CustomPaint(
              size:  Size(double.infinity, 160.h),
              painter: _ChartPainter())),
           SizedBox(height: 8.h),
          Center(
            child: Obx(() => Text(controller.currentDateRange.value, style: AppTextStyles.overline)),
          ),
        ],
      ),
    );
  }

  // Date range picker
  void _showDateRangePicker() {

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          backgroundColor: AppColors.sheet,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r)),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:  EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                         BottomSheetHandle(),
                           SizedBox(height: 12.h),
                          Text('select_date_range'.tr, style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.white), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.close,color:AppColors.white, size: 20.sp),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Column(
                    children: controller.dateRanges.map((range) {
                      return Obx(() {
                        final isSelected = controller.currentLabel.value == range['label'];
                        return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        decoration: BoxDecoration(
                          color:AppColors.search,
                          border: Border.all(color: SettingsController.to.isDarkMode.value?Color(0xFF333333):Color(0xFFEDEDED)),
                          borderRadius: BorderRadius.circular(8.r)),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.h),
                          onTap: () {
                            controller.updateDateRange(range['label']!, range['sub']!);
                            Get.back();
                          },
                          title: Text( range['label']!.tr,
                            style:AppTextStyles.caption.copyWith(color: AppColors.white)),
                          subtitle: Text(range['sub']!,
                            style:AppTextStyles.caption.copyWith(color: AppColors.white)),
                          trailing: Icon( isSelected ? Icons.check_circle_outline: Icons.radio_button_unchecked,
                            color: isSelected ? AppColors.red: Color(0xFFA6A7AC),
                            size: 20.sp,
                          )
                        )
                        );
                            }
                      );
                    }).toList(),
                  ),
                ),
              ),
               SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}

// Chart painter
class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Color(0xFFCFCFCF)
      ..strokeWidth = 1;

    final axisPaint = Paint()
      ..color = Color(0xFFCFCFCF)
      ..strokeWidth = 1;

    // Y-axis labels
    final labels = ['4', '3', '2', '1', '0'];
    final textStyle = AppTextStyles.overline.copyWith(color: AppColors.textTertiary);

    for (int i = 0; i < labels.length; i++) {
      final y = (size.height / (labels.length - 1)) * i;

      canvas.drawLine(
        Offset(30, y),
        Offset(size.width + 10, y),
        gridPaint,
      );

      // Y-axis
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(5, y - 6));
    }


    double startX = 60;
    double endX = size.width - 30;
    double midX = (startX + endX) / 2;

    List<double> xPositions = [startX, midX, endX];
    for (double x in xPositions) {
      canvas.drawLine(
        Offset(x, -20),
        Offset(x, size.height),
        gridPaint,
      );
    }

    // X-axis
    canvas.drawLine(
      Offset(startX - 10, size.height),
      Offset(size.width + 10, size.height),
      axisPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}