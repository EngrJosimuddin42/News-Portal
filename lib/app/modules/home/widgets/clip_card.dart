import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_break/app/theme/app_colors.dart';
import 'package:news_break/app/theme/app_text_styles.dart';
import '../../../models/clip_model.dart';

class ClipCard extends StatelessWidget {
  final ClipModel clip;

  const ClipCard({
    super.key,
    required this.clip,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox( width: 140.w, height: 160.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
                child: Image.network(clip.imageUrl, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[900]))),

            // Dark gradient at bottom
            Positioned( bottom: 0, left: 0, right: 0,
                child: Container( height: 70.h,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black87, Colors.transparent])))),

            // Avatar + subtitle + title
            Positioned( bottom: 8.h, left: 8.w, right: 8.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar( radius: 10.r,
                          backgroundColor: Colors.grey[700],
                        backgroundImage: clip.userProfileImage.isNotEmpty
                            ? NetworkImage(clip.userProfileImage)
                            : const AssetImage('assets/images/clip_person.png') as ImageProvider),
                       SizedBox(width: 6.w),
                      Expanded(
                          child: Text(clip.subtitle, style:AppTextStyles.display.copyWith(color: AppColors.white),
                              overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                   SizedBox(height: 4.h),
                  Text(clip.title,
                    style:AppTextStyles.overline.copyWith(color: AppColors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}