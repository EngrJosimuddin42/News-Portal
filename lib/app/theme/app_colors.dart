import 'package:flutter/material.dart';
import '../controllers/me/settings/settings_controller.dart';

class AppColors {
  AppColors._();

  static bool get _dark => SettingsController.to.isDarkMode.value;

  static Color get scaffoldBg => _dark ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  static Color get surfaceBg => _dark ? const Color(0xFF282828) : const Color(0xFFFFFFFF);
  static Color get textSecondary => _dark ? const Color(0xFF9E9E9E) : const Color(0xFF7A1CA4);
  static Color get info => _dark ? const Color(0xFFA0A0A0) : const Color(0xFFA0A0A0);
  static Color get background => _dark ? const Color(0xFF242424) : const Color(0xFFEDEDED);
  static Color get surface => _dark ? const Color(0xFFFFFFFF) : const Color(0xFF242424);
  static Color get textOnDark => _dark ? const Color(0xFF959595) : const Color(0xFF959595);
  static Color get black => _dark ? const Color(0xFF000000) : const Color(0xFF666666);
  static Color get overlay => _dark ? const Color(0xFFA6A6A6) : const Color(0xFF959595);
  static Color get textPrimary1 => _dark ? const Color(0xFFC4C4C4) : const Color(0xFF959595);
  static Color get primary => _dark ? const Color(0xFF9C9C9C) : const Color(0xFF626262);
  static Color get success => _dark ? const Color(0xFFF0F0F0) : const Color(0xFF1C1C1C);
  static Color get gray => _dark ? const Color(0xFFA6A7AC) : const Color(0xFF707175);
  static Color get backgroundAss => _dark ? const Color(0xFF215C96) : const Color(0xFFE3F2FD);
  static Color get light => _dark ? const Color(0xFFD9D9D9) : const Color(0xFF333333);
  static Color get secondary => _dark ? const Color(0xFFEAEAEA) : const Color(0xFF333333);
  static Color get textGreen => _dark ? const Color(0xFF3498FA) : const Color(0xFF4DA4FB);
  static Color get textTertiary => _dark ? const Color(0xFF929292) : const Color(0xFF929292);
  static Color get chart => _dark ? const Color(0xFF68B1FD) : const Color(0xFF68B0FD);
  static Color get stroke => _dark ? const Color(0xFFE5E5EF) : const Color(0xFFBDBDBD);
  static Color get dot => _dark ? const Color(0xFFAAB6C6) : const Color(0xFFAAB6C6);
  static Color get unselectIcon => _dark ? const Color(0xBFFFFFFF) : const Color(0xBF000000);
  static Color get divider => _dark ? const Color(0xFF26272D) : const Color(0xFFEDEDED);
  static Color get arrow => _dark ? const Color(0xFF242424) : const Color(0xFFFFFFFF);
  static Color get search => _dark ? const Color(0xFF333333) : const Color(0xFFFFFFFF);
  static Color get white => _dark ? const Color(0xFFFFFFFF) : const Color(0xFF0D0D0D);
  static Color get verify => _dark ? const Color(0xFFECC434) : const Color(0xFFEECB4B);
  static Color get body => _dark ? const Color(0xFFEBEBEB) : const Color(0xFF212121);
  static Color get border => _dark ? const Color(0xFF333333) : const Color(0xFFEDEDED);
  static Color get red => _dark ? const Color(0xFFFE5C5A) : const Color(0xFFFE7673);
  static Color get card => _dark ? const Color(0xFF444444) : const Color(0xFFFFFFFF);
  static Color get sheet => _dark ? const Color(0xFF252525) : const Color(0xFFFFFFFF);
  static Color get subtitle => _dark ? const Color(0xFF8EA0BC) : const Color(0xFF8EA1BC);
  static Color get follow => _dark ? const Color(0xFFD9D9D9) : const Color(0xFF333333);
  static Color get button => _dark ? const Color(0xFF1D1D1D) : const Color(0xFFFFFFFF);
  static Color get divide => _dark ? const Color(0xFF262530) : const Color(0xFFD0CFDA);
  static Color get price => _dark ? const Color(0xFF7B83EB) : const Color(0xFFFE7673);
  static Color get confirm => _dark ? const Color(0xFF7B83EB) : const Color(0xFF7B82EB);
  static Color get dropDown => _dark ? const Color(0xFF0D0D0D) : const Color(0xFFFFFFFF);

  static const Color linkColor = Color(0xFFFE5C5A);
  static const Color term = Color(0xFF7B83EB);

  static Gradient get aiGradient => const LinearGradient(
    colors: [Color(0xFF96E89C), Color(0xFF8FBFFA)],
    stops: [0.2897, 0.4674],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    transform: GradientRotation(233.13 * (3.14159 / 180)),
  );

  static Gradient get customGradient => const LinearGradient(
    colors: [Color(0xFFB4BAFF), Color(0xFF7B83EB)],
    stops: [0.1708, 0.7516],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    transform: GradientRotation(123.66 * (3.141592653589793 / 180)),
  );
}