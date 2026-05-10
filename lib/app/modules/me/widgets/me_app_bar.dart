import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../controllers/me/me_controller.dart';
import '../../../controllers/me/settings/settings_controller.dart';
import '../../../theme/app_assets.dart';
import '../../../theme/app_colors.dart';

class MeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      SettingsController.to.isDarkMode.value;

      return AppBar(
        backgroundColor: AppColors.scaffoldBg,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: ShaderMask(
              shaderCallback: (Rect bounds) {
                return AppColors.aiGradient.createShader(bounds);
              },
              child: SvgPicture.asset(
                AppAssets.starIcon,
                width: 22.w,
                height: 22.h,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
            onPressed: () => Get.find<MeController>().onAI(),
          ),

          IconButton(
            icon: Icon(Icons.settings_outlined, color: AppColors.white),
            onPressed: () => Get.find<MeController>().onSettings(),
          ),
        ],
      );
    });
  }
}