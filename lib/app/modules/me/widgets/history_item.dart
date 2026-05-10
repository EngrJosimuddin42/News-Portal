import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_break/app/theme/app_assets.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import 'package:news_break/app/widgets/bottom_sheet_handle.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controllers/me/me_controller.dart';
import '../../../models/history_model.dart';
import '../../../theme/app_colors.dart';


class HistoryItem extends StatelessWidget {
  final HistoryModel model;
  const HistoryItem({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(model.title, style: AppTextStyles.buttonOutline.copyWith(color: AppColors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
                    SizedBox(height: 6.h),
                    Text(model.subtitle,style: AppTextStyles.overline.copyWith(color:AppColors.subtitle),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis),
                    SizedBox(height: 10.h),
                    Row(children: [
                      SvgPicture.asset(AppAssets.typeIcon, width: 18.w, height: 18.h,colorFilter:ColorFilter.mode(AppColors.dot,BlendMode.srcIn)),
                      SizedBox(width: 6.w),
                      Text(model.source, style: AppTextStyles.buttonOutline.copyWith(color: AppColors.dot)),
                      SizedBox(width: 16.w),
                      SvgPicture.asset(AppAssets.timeIcon, width: 18.w, height: 18.h,colorFilter:ColorFilter.mode(AppColors.dot,BlendMode.srcIn)),
                      SizedBox(width: 6.w),
                      Text(model.timeAgo, style: AppTextStyles.buttonOutline.copyWith(color: AppColors.dot)),
                    ]),
                   ],
                  ),
                ),
                 SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => _showRemoveBottomSheet(context),
                      child:  Icon(Icons.more_vert, color:AppColors.white, size: 20.sp)),
                SizedBox( height: 12.h),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                       model.thumbnailUrl, width: 100.w, height: 80.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container( width: 100.w, height: 80.h,
                          color: Colors.grey[800]))),

                    // Play icon overlay
                    Positioned.fill(
                      child: Center(
                        child: GestureDetector(
                          onTap: () async {
                            final Uri url = Uri.parse(model.videoUrl);
                            if (!await launchUrl(url)) {

                            }
                          },
                          child: Container( width: 30.w, height: 30.h,
                            decoration: const BoxDecoration(
                              color: Colors.white, 
                              shape: BoxShape.circle),
                            child: Icon(Icons.play_arrow_rounded, color: Colors.black, size: 30.sp

                            ))))),
                        ],
                  ),
                  ],
              ),
             ],
                )
        ],
      ),
    );
  }

  void _showRemoveBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor:Get.isDarkMode? Color(0xFF282828):Colors.white,
      constraints: BoxConstraints( maxWidth: MediaQuery.of(context).size.width),
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (context) {
        return Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

             BottomSheetHandle(),

               SizedBox(height: 20.h),
              InkWell(
                onTap: () {
                  Get.back();
                  Get.find<MeController>().deleteSingleHistoryItem(model.id);
                },
                child: Container(
                  width: double.infinity,
                  padding:  EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Get.isDarkMode? Color(0xFF444444):Colors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12.r)),
                  child: Row(
                    children: [
                      SvgPicture.asset(AppAssets.deleteIcon, width: 20.w, height: 20.h,colorFilter: ColorFilter.mode(AppColors.linkColor,BlendMode.srcIn)),
                       SizedBox(width: 12.w),
                      Text( 'Remove from history', style: AppTextStyles.caption.copyWith(color: AppColors.linkColor)),
                    ],
                  ),
                ),
              ),
               SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }
}