import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/bindings/app_binding.dart';
import 'app/controllers/me/settings/settings_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_colors.dart';
import 'app/theme/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
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
        return Obx(() {
          final scale = SettingsController.to.selectedTextSize.value == 'Small'
              ? 0.85
              : SettingsController.to.selectedTextSize.value == 'Large'
              ? 1.2
              : 1.0;

          final currentLocale = settingsController.selectedLanguage.value == 'English'
              ? const Locale('en', 'US')
              : const Locale('bn', 'BD');

          return GetMaterialApp(
            title: 'Newsbreak',
            debugShowCheckedModeBanner: false,

            translations: AppTranslations(),
            locale: currentLocale,
            fallbackLocale: const Locale('en', 'US'),

            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('bn', 'BD'),
            ],

            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(
                    MediaQuery.of(context).textScaler.scale(1.0) * scale,
                  ),
                ),
                child: child!,
              );
            },

            // Light Theme
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: AppColors.scaffoldBg,
              fontFamily: GoogleFonts.hindSiliguri().fontFamily,
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.scaffoldBg,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.black),
              ),
            ),

            // Dark Theme
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: AppColors.scaffoldBg,
              fontFamily: GoogleFonts.hindSiliguri().fontFamily,
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.scaffoldBg,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
            ),

            themeMode: settingsController.isDarkMode.value
                ? ThemeMode.dark
                : ThemeMode.light,

            initialBinding: AppBinding(),
            initialRoute: AppPages.initial,
            getPages: AppPages.routes,
          );
        });
      },
    );
  }
}