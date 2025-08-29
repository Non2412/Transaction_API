// components/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

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
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                user?.email ?? "",
                style: const TextStyle(fontSize: 16),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
              decoration: const BoxDecoration(color: Colors.blueAccent),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.green),
              title: const Text("Home"),
              onTap: () {
                Navigator.of(context).pop();
                Get.offNamed(AppRoutes.home);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_box, color: Colors.green),
              title: const Text("About"),
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(AppRoutes.about);
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_3x3_outlined, color: Colors.green),
              title: const Text("Products"),
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(AppRoutes.products);
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_page, color: Colors.green),
              title: const Text("Contact"),
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(AppRoutes.contact); // ✅ ไปหน้า Contact
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.green),
              title: const Text("Logout"),
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
