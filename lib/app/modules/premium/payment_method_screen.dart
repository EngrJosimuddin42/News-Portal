import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../controllers/me/settings/settings_controller.dart';
import '../../controllers/premium_controller.dart';

class PaymentMethodScreen extends GetView<PremiumController> {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = SettingsController.to.isDarkMode.value;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldBg,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios, color: AppColors.textOnDark, size: 20.sp),
          ),
          title: Text('payment_method'.tr,
              style: AppTextStyles.displaySmall.copyWith(color: AppColors.white)),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              SizedBox(height: 30.h),
              Obx(() => Column(
                children: controller.paymentMethods.map((method) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: GestureDetector(
                    onTap: () => controller.selectPaymentMethod(method),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF333333) : Colors.white,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(method.tr, style: AppTextStyles.caption.copyWith(color: AppColors.white)),
                          Icon(
                            controller.selectedMethod.value == method
                                ? Icons.check_circle_outline
                                : Icons.radio_button_unchecked,
                            color: controller.selectedMethod.value == method
                                ? AppColors.confirm
                                : AppColors.textOnDark,
                            size: 22.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                )).toList(),
              )),
              const Spacer(),

              Obx(() => controller.selectedMethod.value == null
                  ? const SizedBox.shrink()
                  : SizedBox(
                width: 311.w, height: 48.h,
                child: ElevatedButton(
                  onPressed: () => controller.processPayment(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.term,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: controller.isLoading.value
                      ? CircularProgressIndicator(color: AppColors.white, strokeWidth: 2)
                      : Text('continue'.tr,
                      style: AppTextStyles.caption.copyWith(color: AppColors.white)),
                ),
              )),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      );
    });
  }
}