import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form_validate/components/drawer.dart';
import '../controllers/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      drawer: Drawer(
        backgroundColor: Colors.white, // เปลี่ยนพื้นหลัง Drawer เป็นขาว
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green, // เปลี่ยน header เป็นเขียว
              ),
              accountName: Text(
                'sup asdf',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                'supp@gmail.com',
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.green, size: 40),
              ),
              otherAccountsPictures: const [
                Icon(Icons.star, color: Colors.yellow, size: 28),
                Icon(Icons.favorite, color: Colors.pink, size: 28),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.green),
              title: const Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.green),
              title: const Text('About'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.tag, color: Colors.green),
              title: const Text('Products'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail, color: Colors.green),
              title: const Text('Contact'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.green),
              title: const Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Obx(() {
        final user = authController.currentUser;
        
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue[100],
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'สวัสดี ${user?.fullName ?? "ผู้ใช้"}!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                user?.email ?? "",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'ยินดีต้อนรับสู่หน้าหลัก!',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.snackbar(
                    'สำเร็จ',
                    'คุณได้กดปุ่มแล้ว!',
                    backgroundColor: Colors.green[100],
                    colorText: Colors.green[800],
                  );
                },
                child: const Text('กดที่นี่'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
