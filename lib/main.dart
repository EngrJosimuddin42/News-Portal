import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/bindings/app_binding.dart';
import 'app/controllers/me/settings/settings_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_colors.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.put(SettingsController(), permanent: true);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(() => GetMaterialApp(
          title: 'Newsbreak',
          debugShowCheckedModeBanner: false,

          // Light Theme
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppColors.scaffoldBg,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.scaffoldBg,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
            ),
          ),

         // Dark Theme
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.scaffoldBg,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.scaffoldBg,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
            ),
          ),

          // them mode
          themeMode: settingsController.isDarkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,

          initialBinding: AppBinding(),
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
        ));
      },
    );
  }
}