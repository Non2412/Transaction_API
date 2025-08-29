// routes/app_pages.dart
import 'package:get/get.dart';
import 'app_routes.dart';

import '../screens/splash_screen.dart';
import '../screens/login.dart';
import '../screens/regis.dart';
import '../screens/forget_pass.dart';
import '../screens/home.dart';
import '../screens/about_screen.dart';
import '../screens/products_screen.dart';
import '../screens/contact_screen.dart'; // ✅ import Contact

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),
    GetPage(name: AppRoutes.forgetPassword, page: () => const ForgetPasswordScreen()),
    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
    GetPage(name: AppRoutes.about, page: () => const AboutScreen()),
    GetPage(name: AppRoutes.products, page: () => const ProductsScreen()),
    GetPage(name: AppRoutes.contact, page: () => const ContactScreen()), // ✅ Contact route
  ];
}
