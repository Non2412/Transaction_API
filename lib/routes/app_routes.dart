// ignore: unused_import
import '../screens/contact_screen.dart';
abstract class AppRoutes {
  AppRoutes._();

  // กำหนดชื่อ routes ทั้งหมด
  static const splash = '/'; // เปลี่ยนให้ splash เป็น initial route
  static const login = '/login';
  static const register = '/register';
  static const forgetPassword = '/forget-password';
  static const home = '/home'; // สำหรับในอนาคต
  static const profile = '/profile'; // สำหรับในอนาคต
  static const contact = '/contact'; // เพิ่ม route สำหรับ Contact Screen
  static const about = '/about';
  static const products = '/products';

  // Helper methods สำหรับการนำทาง
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
