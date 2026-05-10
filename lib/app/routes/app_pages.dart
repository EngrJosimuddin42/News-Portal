import 'package:get/get.dart';
import '../bindings/create_post_binding.dart';
import '../bindings/edit_tabs_binding.dart';
import '../bindings/fullscreen_binding.dart';
import '../bindings/signin_binding.dart';
import '../bindings/splash_binding.dart';
import '../modules/create_post/create_post_view.dart';
import '../modules/edit_tabs/edit_tabs_view.dart';
import '../modules/fullscreen/fullscreen_view.dart';
import '../modules/home/home_view.dart';
import '../modules/news/news_detail_view.dart';
import '../modules/signin/signin_view.dart';
import '../modules/splash/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.FULLSCREEN,
      page: () => const FullscreenView(),
      binding: FullscreenBinding(),
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => const SignInView(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
    ),
    GetPage(
      name: _Paths.EDIT_TABS,
      page: () => const EditTabsView(),
      binding: EditTabsBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_POST,
      page: () => const CreatePostView(),
      binding: CreatePostBinding(),
    ),
    GetPage(
      name: _Paths.NEWS_DETAIL,
      page: () => const NewsDetailView(),
    ),
  ];
}