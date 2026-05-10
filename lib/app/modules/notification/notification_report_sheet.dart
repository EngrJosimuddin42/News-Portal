import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import 'package:news_break/app/widgets/report_success.dart';
import '../../controllers/notification/notification_controller.dart';
import '../../controllers/social_interaction_controller.dart';

class NotificationReportSheet extends StatefulWidget {
  final int contentId;
  final String contentType;

  const NotificationReportSheet({
    super.key,
    this.contentId = 0,
    this.contentType = 'news',
  });

  @override
  State<NotificationReportSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<NotificationReportSheet> {
  final controller = Get.find<NotificationController>();
  final socialCtrl = Get.find<SocialInteractionController>();

  int _step = 0;
  String? _selectedReason;
  String? _selectedSubReason;

  @override
  void initState() {
    super.initState();
    socialCtrl.openReport(widget.contentId, widget.contentType);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.sheet,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r))),
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: _buildStep(),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _buildSelectReason();
      case 1:
        return _buildSubReason();
      case 2:
        return _buildConfirm();
      case 3:
        return ReportSuccess();
      default:
        return _buildSelectReason();
    }
  }

  Widget _buildSelectReason() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader('Select a reason'),
         Divider(color:Get.isDarkMode? Color(0xFF3D3C3C):Color(0xFFEDEDED), height: 1),

        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: Color(0xFF6C6C6C)),

          child: Obx(() => RadioGroup<String>(
            groupValue: _selectedReason,
            onChanged: (val) => setState(() => _selectedReason = val),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.reportReasons.length,
              itemBuilder: (_, i) {
                final reason = controller.reportReasons[i];
                return RadioListTile<String>(
                  value: reason,
                  title: Text(reason, style: AppTextStyles.caption.copyWith(color: AppColors.white)),
                  activeColor: AppColors.white,
                  dense: true,
                );
              },
            ),
          )),
        ),

        _buildButtons(
          onCancel: () => Navigator.pop(context),
          onNext: () {
            if (_selectedReason != null) {
              socialCtrl.selectReason(_selectedReason!);
              setState(() => _step = 1);
            }
          },
          nextLabel: 'Submit',
        ),
         SizedBox(height: 30.h),
      ],
    );
  }

  Widget _buildSubReason() {
    final subs = controller.reportSubReasons[_selectedReason] ?? ['Other'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader('How is it $_selectedReason',
            onBack: () => setState(() => _step = 0)),
        Divider(color:Get.isDarkMode? Color(0xFF3D3C3C):Color(0xFFEDEDED), height: 1),

        Theme(
          data: Theme.of(context).copyWith(
          unselectedWidgetColor: Color(0xFF6C6C6C)),

          child: RadioGroup<String>(
            groupValue: _selectedSubReason,
            onChanged: (val) => setState(() => _selectedSubReason = val),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: subs.length,
              itemBuilder: (_, i) => RadioListTile<String>(
                value: subs[i],
                title: Text(subs[i], style: AppTextStyles.caption.copyWith(color: AppColors.white)),
                activeColor: AppColors.white,
                dense: true,
              ),
            ),
          ),
        ),

        _buildButtons(
          onCancel: () => Navigator.pop(context),
          onNext: () {
            if (_selectedSubReason != null) setState(() => _step = 2);
          },
          nextLabel: 'Next',
        ),
         SizedBox(height: 30.h),
      ],
    );
  }

  Widget _buildConfirm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader('You are about to submit a report',
            onBack: () => setState(() => _step = 1)),
        Divider(color:Get.isDarkMode? Color(0xFF3D3C3C):Color(0xFFEDEDED), height: 1),
        Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('We only remove content that goes against our socials standard. Review your report details below.',
                style: AppTextStyles.caption.copyWith(color: AppColors.white)),
               SizedBox(height: 16.h),
              _infoField('Why are you reporting this?', _selectedReason ?? ''),
               SizedBox(height: 12.h),
              Divider(color:Get.isDarkMode? Color(0xFF3D3C3C):Color(0xFFEDEDED), height: 1),
               SizedBox(height: 12.h),
              _infoField( 'How is it $_selectedReason?', _selectedSubReason ?? ''),
            ],
          ),
        ),
        Padding(
          padding:EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 16.h),
          child: SizedBox( width: 311.w, height: 48.h,
            child: ElevatedButton(
              onPressed: () {
                socialCtrl.selectReason(_selectedReason!);
                socialCtrl.submitReport();
                setState(() => _step = 3);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
                padding:EdgeInsets.symmetric(vertical: 8.r)),
              child: Text('Submit', style: AppTextStyles.bodySmall.copyWith(
                  color: Get.isDarkMode?Color(0xFF242424):Color(0xFFDBDBDB))),
            ),
          ),
        ),
         SizedBox(height: 12.h),
      ],
    );
  }

  Widget _buildHeader(String title, {VoidCallback? onBack}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack ?? () => Navigator.pop(context),
            child:Icon(Icons.arrow_back_ios, color:AppColors.white, size: 20.sp)),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(title,
                style: AppTextStyles.caption.copyWith(color: AppColors.white), textAlign: TextAlign.center)),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child:Icon(Icons.close, color:AppColors.white, size: 20.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons({
    required VoidCallback onCancel,
    required VoidCallback onNext,
    required String nextLabel,
  }) {
    return Padding(
      padding:  EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0.h),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                side:BorderSide(color: Get.isDarkMode?Color(0xFF959595):Color(0xFFEDEDED)),
                minimumSize:Size(140.w, 60.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
                padding: EdgeInsets.symmetric(vertical: 20.h)),
              child: Text('Cancel', style: AppTextStyles.bodySmall
                      .copyWith(color:Get.isDarkMode?Color(0xFFC4C4C4):AppColors.textOnDark)))),
           SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                minimumSize: Size(140.w, 60.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.h)),
                padding: EdgeInsets.symmetric(vertical: 20.h)),
              child: Text(nextLabel, style: AppTextStyles.bodySmall.copyWith(
                  color:Get.isDarkMode?Color(0xFF242424):Color(0xFFDBDBDB))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.labelSmall
                .copyWith(color: Color(0xFF6C6C6C))),
        SizedBox(height: 6.h),
        Text(value,
            style: AppTextStyles.textSmall
                .copyWith(color: Get.isDarkMode?Color(0xFFD9D9D9):Color(0xFF333333))),
      ],
    );
  }
}