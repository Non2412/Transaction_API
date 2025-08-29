import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  // ใช้ Get.find เพื่อดึง AuthController ที่ถูก inject แล้ว
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = authController.currentUser;

      return Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                user?.fullName ?? "Guest",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                user?.email ?? "",
                style: TextStyle(fontSize: 16),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
              decoration: BoxDecoration(color: Colors.blueAccent),
              otherAccountsPictures: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.star, color: Colors.amber),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite, color: Colors.pink),
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.green),
              title: Text("Home"),
              onTap: () {
                Navigator.of(context).pop(); // ปิด drawer
                Get.offNamed(AppRoutes.home); // ไปหน้า Home
              },
            ),
            ListTile(
              leading: Icon(Icons.account_box, color: Colors.green),
              title: Text("About"),
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(AppRoutes.about);
              },
            ),
            ListTile(
              leading: Icon(Icons.grid_3x3_outlined, color: Colors.green),
              title: Text("Products"),
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed('/products'); // หรือ AppRoutes.products ถ้ามี
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_page, color: const Color.fromRGBO(76, 175, 80, 1)),
              title: Text("Contact"),
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(AppRoutes.contact);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.green),
              title: Text("Logout"),
              onTap: () async {
                Navigator.of(context).pop();
                await authController.logout();
                Get.offAllNamed(AppRoutes.login);
              },
            ),
          ],
        ),
      );
    });
  }
}
