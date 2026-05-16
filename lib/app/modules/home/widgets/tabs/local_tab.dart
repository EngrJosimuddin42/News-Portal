import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../../controllers/home_controller.dart';
import '../../../../theme/app_colors.dart';
import '../ad_video_card.dart';
import '../category_news_card.dart';

class LocalTab extends GetView<HomeController> {
  final String message;

  const LocalTab({
    super.key,
    this.message = 'No relevant articles',
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return _buildLocationAwareContent();
    });
  }

  Widget _buildLocationAwareContent() {
    return Obx(() {
      final hasLocation = controller.selectedLocation.value != null;
      return hasLocation ? _buildWithLocation() : _buildWithoutLocation();
    });
  }

  Widget _buildWithoutLocation() {
    return SingleChildScrollView(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50.h),
          Image.asset('assets/images/socket.png', width: 130.w, height: 130.w),
           SizedBox(height: 16.h),
          Text(message, style: AppTextStyles.caption.copyWith(color: const Color(0xFF9B9B9B))),
          SizedBox(height: 16.h),
          OutlinedButton(
              onPressed: controller.onTryAgain,
              style: OutlinedButton.styleFrom(
                  padding:  EdgeInsets.all(20.w),
                  minimumSize: Size(90.w, 50.h),
                  side: BorderSide(color:Get.isDarkMode?Color(0xFF7B83EB):Color(0xFF7B82EB)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.r))),

              child: Text('Try Again', style: AppTextStyles.caption.copyWith(color:Get.isDarkMode?Color(0xFF7B83EB):Color(0xFF7B82EB)))),
        ],
      ),
    ),
    );
  }

  Widget _buildWithLocation() {
    return ListView(
      padding: EdgeInsets.only(top: 4.h, bottom: 16.h),
      children: [
        _buildWeatherSection(),
         SizedBox(height: 8.h),
         Divider(color:AppColors.border, height: 2, thickness: 3),
         SizedBox(height: 8.h),
        _buildNewsCards(),
      ],
    );
  }

  Widget _buildWeatherSection() {
    return Obx(() {
      final temp = controller.currentTemp.value;
      final condition = controller.weatherCondition.value;
      final days = controller.weatherDays.toList();

      return Container(
        margin:  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        padding:  EdgeInsets.all(12.w),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Get.isDarkMode? Color(0xFF333333):Color(0xFFEDEDED),
                          width: 1)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(temp, style: AppTextStyles.displaySmall.copyWith(color: AppColors.white)),
                       SizedBox(width: 8.w),
                      SvgPicture.asset(controller.weatherIcon.value, height: 30.h, width: 30.w),                    ],
                  ),
                ),
                 SizedBox(width: 24.w),
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: days.map((data) => Padding(
                        padding: EdgeInsets.only(left: 12.w),
                        child: Column(
                          children: [
                            Text(data['day']!, style: AppTextStyles.display.copyWith(color: AppColors.textOnDark)),
                             SizedBox(height: 4.h),
                            SvgPicture.asset(data['icon']!, width: 20.w, height: 20.h),
                             SizedBox(height: 4.h),
                            Text(data['temp']!, style: AppTextStyles.display.copyWith(color: AppColors.textOnDark)),
                          ],
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
             SizedBox(height: 24.h),
            GestureDetector(
              onTap: _showRainForecast,
              child: Container(
                padding:EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                decoration: BoxDecoration(
                    color: AppColors.textGreen,
                    borderRadius: BorderRadius.circular(50)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(controller.weatherIcon.value,height: 20.h, width: 20.w,
                        colorFilter:ColorFilter.mode(Colors.white,BlendMode.srcIn)),
                     SizedBox(width: 6.w),
                    Text('$condition expected', style: AppTextStyles.labelMedium.copyWith(color: Colors.white)),
                     SizedBox(width: 6.w),
                     Icon(Icons.chevron_right, color:Colors.white, size: 20.sp),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNewsCards() {
    return Obx(() => Column(
      children: controller.localNews.map((news) {
        if (news.publisherType == 'Ad') return AdVideoCard(news: news);
        return CategoryNewsCard(news: news, tabType: 'news_local');
      }).toList(),
    ));
  }

  void _showRainForecast() {
    showDialog(
      context: Get.context!,
      builder: (_) => Dialog(
        backgroundColor: AppColors.sheet,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                      onTap: () => Get.back(),
                      child:
                      Icon(Icons.close, color:AppColors.white, size: 20.sp))),
               SizedBox(height: 10.h),
              Text('Rain Forecast', style: AppTextStyles.button.copyWith(color: AppColors.white)),
              SizedBox(height: 6.h),


              Obx(() {
                final probability = controller.rainProbability.value;
                final barData = controller.rainBarData.toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('The probability of precipitation is $probability',
                        style: AppTextStyles.labelMedium.copyWith(color: AppColors.white)),
                     SizedBox(height: 16.h),
                    Container(height: 250.h,
                        padding:EdgeInsets.fromLTRB(20.w, 70.h, 20.w, 50.h),
                        decoration: BoxDecoration(
                            border: Border.all(color:Get.isDarkMode?const Color(0xFFEBEBEB):Color(0xFFEDEDED)),
                            borderRadius: BorderRadius.circular(14)),
                        child: CustomPaint( size: Size.infinite,
                            painter: _RainChartPainter(data: barData))),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _RainChartPainter extends CustomPainter {
  final List<double> data;

  _RainChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final barPaint = Paint()
      ..color = AppColors.chart;
    final gridPaint = Paint()
      ..color = AppColors.stroke
      ..strokeWidth = 1;

// Grid lines
    for (int i = 0; i < 4; i++) {
      final y = size.height * i / 3;
      final double currentMargin = (i == 0) ? 30.0 : 10.0;
      final Offset startPoint = Offset(currentMargin, y);
      final Offset endPoint = Offset(size.width - currentMargin, y);
      if (i == 3) {
        canvas.drawLine(startPoint, endPoint, gridPaint);
      } else {
        _drawDashedLine(canvas, startPoint, endPoint, gridPaint);
      }
    }

    // Bars
    final double spacing = size.width / (data.length);
    const barWidth = 18.0;

    for (int i = 0; i < data.length; i++) {
      final x = (i * spacing) + (spacing / 2) - (barWidth / 2);
      final barHeight = size.height * (data[i] / 0.08);
      final rect = Rect.fromLTWH(
          x, size.height - barHeight, barWidth, barHeight);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect,  Radius.circular(4.r)),
        barPaint,
      );
    }

    // X-axis Labels (Now, 10PM...)
    final labelBarIndices = [0, 2, 4, data.length - 1];
    final labels = ['Now', '10 PM', '04 AM', '10 AM'];
    final labelStyle = TextStyle(color:AppColors.textOnDark, fontSize: 10);

    for (int i = 0; i < labels.length; i++) {
      final barIndex = labelBarIndices[i];

      final double barCenterX = (barIndex * spacing) + (spacing / 2);

      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      double xOffset = barCenterX - (tp.width / 2);

      xOffset = xOffset.clamp(0.0, size.width - tp.width);

      tp.paint(canvas, Offset(xOffset, size.height + 14));
    }


    // Y labels
    final yStyle = AppTextStyles.labelSmall.copyWith( color: const Color(0xFF9291A5));
    final yLabels = {'in': 0.0, '0.07': size.height * (0.08 / 0.08)};
    yLabels.forEach((text, yPos) {
      final tp = TextPainter(
          text: TextSpan(text: text, style: yStyle),
          textDirection: TextDirection.ltr)
        ..layout();

      if (text == 'in') {
        tp.paint(canvas, const Offset(0, -55));
      } else {
        tp.paint(canvas, Offset(0, (size.height - yPos) - (tp.height / 2)));
      }
    });

    // Date label on tallest bar
    final dateLabel = '04/02';
    final dateTp = TextPainter(
        text: TextSpan(text: dateLabel, style: TextStyle(color:Color(0xFF9291A5), fontSize: 9.sp)),
        textDirection: TextDirection.ltr)
      ..layout();
    final tallestIndex = 4; // 0.08 value
    final tallestX = tallestIndex * (size.width / data.length) + barWidth / 2;
    final tallestHeight = size.height * data[tallestIndex] / 0.08;
    dateTp.paint(canvas, Offset(tallestX + (barWidth / 2) - (dateTp.width / 2),
        size.height - tallestHeight - 14));
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double distance = (end - start).distance;
    double drawn = 0;
    final direction = (end - start) / distance;

    while (drawn < distance) {
      final dashEnd = drawn + dashWidth;
      canvas.drawLine(
          start + direction * drawn,
          start + direction * (dashEnd < distance ? dashEnd : distance),
          paint);
      drawn += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _RainChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}