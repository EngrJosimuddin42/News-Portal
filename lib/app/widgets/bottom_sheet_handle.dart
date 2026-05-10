import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
         SizedBox(height: 12.h),
        Container(width: 40.w, height: 5.h,
          decoration: BoxDecoration(
            color:Color(0xFF444444),
            borderRadius: BorderRadius.circular(20.r))),
      ],
    );
  }
}