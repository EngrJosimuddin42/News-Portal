import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'dart:io';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../controllers/auth/auth_controller.dart';
import 'package:image_picker/image_picker.dart' as img_picker;

import '../../controllers/me/edit_profile_controller.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());

    return Scaffold(
      backgroundColor:AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor:AppColors.scaffoldBg,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios,color:AppColors.textOnDark, size: 20.sp)),
        title: Text('edit_profile'.tr, style: AppTextStyles.displaySmall.copyWith(color: AppColors.white)),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.more_vert, color:AppColors.white),
              onPressed: () => _showMoreOptions(context, controller)),
        ],
      ),
      body: Obx(() => controller.isLoading.value
          ?  Center(child: CircularProgressIndicator(color: AppColors.white))
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  // Avatar
                  GestureDetector(
                    onTap: () => _showPhotoOptions(context, controller),
                    child: Column(
                      children: [
                        Obx(() {
                        final String? profileUrl = AuthController.to.user.value?.profileImageUrl;
                        return CircleAvatar(
                          radius: 24.r,
                          backgroundColor: Colors.grey[800],
                          backgroundImage: profileUrl != null && profileUrl.isNotEmpty
                              ? (profileUrl.startsWith('http') || profileUrl.startsWith('https')
                              ? NetworkImage(profileUrl) as ImageProvider
                              : FileImage(File(profileUrl)))
                              : null,
                          child: (profileUrl == null || profileUrl.isEmpty)
                              ? SvgPicture.asset(AppAssets.personIcon)
                              : null,
                        );
                        }),
                         SizedBox(height: 8.r),
                        Text('edit_photo'.tr, style: AppTextStyles.caption.copyWith(color: AppColors.white)),
                      ],
                    ),
                  ),

                   SizedBox(height: 32.h),

                  // Name
                  _inputField('name'.tr, controller.nameController),
                   SizedBox(height: 12.h),

              Row(
                children: [
                  // User Name
                 Expanded(child: _inputField('user_name'.tr, controller.userNameController)),
                  SizedBox(width: 20.w),
                  // Email
                 Expanded(child: _inputField('email'.tr, controller.emailController,
                      keyboardType: TextInputType.emailAddress)),
                    ]
                  ),

                   SizedBox(height: 20.h),
                  // Bio
                  _inputField('bio'.tr, controller.bioController),
                   SizedBox(height: 20.h),

                   // Website
                  _inputField('website'.tr, controller.websiteController),
                   SizedBox(height: 20.h),

                  Row(
                    children: [
                      Obx(() => _dropdownField(
                          label: 'birth_year'.tr,
                          value: DateFormat('dd/MM/yyyy').format(controller.selectedBirthDate.value),
                          onTap: () => controller.chooseBirthDate(context),
                          isDate: true)),

                   SizedBox(width: 20.h),

                  // Gender
                      Obx(() =>_dropdownField(
                      label: 'gender'.tr,
                      value: controller.selectedGender.value,
                    onTap: () => _showGenderPicker(context, controller))),
                  ],
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),

          // Save button
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 32.h),
            child: SizedBox( width: 335.w, height: 48.h,
              child: ElevatedButton(
                  onPressed: () => controller.saveProfile(),
                style: ElevatedButton.styleFrom(
                  backgroundColor:AppColors.confirm,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r))),
                child: Text('save'.tr, style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,fontWeight: FontWeight.w600))))),
        ],
      ),
    ),
    );
  }

  // Input field
  Widget _inputField(
      String label,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: Color(0xFF626262))),
         SizedBox(height: 12.h),
        Container( height: 52.h,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textOnDark),
            borderRadius: BorderRadius.circular(6.r)),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textOnDark),
            decoration:  InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.h)))),
      ],
    );
  }

  //  Dropdown field
  Widget _dropdownField({
    required String label,
    required String value,
    required VoidCallback onTap,
    bool isDate = false,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.labelSmall.copyWith(color:AppColors.textOnDark)),
           SizedBox(height: 12.h),
          GestureDetector(
            onTap: onTap,
            child: Container(height: 52.h,
              padding:  EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.textOnDark),
                borderRadius: BorderRadius.circular(6.r)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textOnDark)),
                  Icon( isDate ? Icons.calendar_month_outlined : Icons.keyboard_arrow_down,
                      color: AppColors.info,
                      size: 20.sp),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  // Gender picker
  void _showGenderPicker(BuildContext context, EditProfileController controller) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.arrow,
        title: Text('gender'.tr, style: AppTextStyles.displaySmall.copyWith(
            color: AppColors.white), textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: controller.genders.map((gender) {
            bool isLast = gender == controller.genders.last;
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.updateGender(gender);
                    Get.back();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Text(gender, style: AppTextStyles.caption.copyWith(color: AppColors.white)),
                  ),
                ),
                if (isLast)
                  Divider(color: AppColors.textOnDark, height: 1),
              ],
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr, style: AppTextStyles.caption.copyWith(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  // Photo options
  void _showPhotoOptions(BuildContext context, EditProfileController controller) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.arrow,
        title: Text('choose_photo'.tr, style: AppTextStyles.displaySmall.copyWith(
            color: AppColors.white), textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                  Get.back();
                  AuthController.to.pickAndUploadImage(img_picker.ImageSource.camera);
              },
              child:  Padding(
                padding: EdgeInsets.symmetric(vertical: 12.w),
                child: Text('take_picture'.tr,
                    style:AppTextStyles.caption.copyWith(color: AppColors.white)))),
            GestureDetector(
              onTap: () {
                Get.back();
                AuthController.to.pickAndUploadImage(img_picker.ImageSource.gallery);              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text('choose_gallery'.tr,
                    style:AppTextStyles.caption.copyWith(color: AppColors.white)))),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child:Text('cancel'.tr, style:AppTextStyles.caption.copyWith(color: AppColors.white))),
        ],
      ),
    );
  }

  //  More options (3-dot)
  void _showMoreOptions(BuildContext context, EditProfileController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor:AppColors.surfaceBg,
      constraints: const BoxConstraints(
        maxWidth: double.infinity),
      isScrollControlled: true,
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container( width: 36.w, height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2.r))),
             SizedBox(height: 12.h),
            Container(
              height: 42.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: AppColors.card,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12.r)),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                  _showDeleteConfirm(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppAssets.deleteIcon, width: 20.w, height: 20.h,
                      colorFilter: ColorFilter.mode(AppColors.linkColor, BlendMode.srcIn)),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text('delete_account'.tr,
                        style: AppTextStyles.caption.copyWith(color: AppColors.red))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  //Delete confirm dialog
  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor:AppColors.search,
        title:Text('delete_account_confirm'.tr,
            style:AppTextStyles.caption.copyWith(color: AppColors.white), textAlign: TextAlign.center),
        content: Text('delete_account_desc'.tr,
          style:AppTextStyles.caption.copyWith(color: AppColors.white), textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child:Text('cancel'.tr, style:AppTextStyles.headlineMedium.copyWith(color: AppColors.white))),
          TextButton(
            onPressed: () {
              Get.back();
              AuthController.to.deleteAccount();
            },
            child: Text('delete'.tr, style: AppTextStyles.headlineMedium.copyWith(color: AppColors.red))),
        ],
      ),
    );
  }
}