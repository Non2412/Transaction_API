// routes/app_routes.dart
abstract class AppRoutes {
  AppRoutes._();

  // กำหนดชื่อ routes ทั้งหมด
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const forgetPassword = '/forget-password';
  static const home = '/home';
  static const profile = '/profile';
  static const contact = '/contact';   // ✅ Contact
  static const about = '/about';
  static const products = '/products';

  // Helper methods
  static String getSplashRoute() => splash;
  static String getLoginRoute() => login;
  static String getRegisterRoute() => register;
  static String getForgetPasswordRoute() => forgetPassword;
  static String getHomeRoute() => home;
  static String getProfileRoute() => profile;
  static String getContactRoute() => contact;
  static String getAboutRoute() => about;
  static String getProductsRoute() => products;
}
