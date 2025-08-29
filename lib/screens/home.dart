import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form_validate/components/drawer.dart';
import '../controllers/auth_controller.dart';
import 'products_screen.dart'; // import ProductController & Product model

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.find<AuthController>();
  late ProductController productController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<ProductController>()) {
      productController = Get.find<ProductController>();
    } else {
      productController = Get.put(ProductController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: buildDrawer(context),
      ),
      body: Obx(() {
        final products = productController.products;

        if (products.isEmpty) {
          return const Center(child: Text("ยังไม่มีสินค้า"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final p = products[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    p.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 50,
                      height: 50,
                      color: Colors.green[50],
                      child: const Icon(Icons.image_not_supported,
                          size: 30, color: Colors.grey),
                    ),
                  ),
                ),
                title: Text(
                  p.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.description,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            p.category,
                            style: TextStyle(
                              color: Colors.green[800],
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "คงเหลือ: ${p.stock}",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Text(
                  "฿${p.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(76, 175, 80, 1),
          ),
          accountName: const Text(
            'sup asdf',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          accountEmail: const Text(
            'supp@gmail.com',
            style: TextStyle(color: Colors.white70),
          ),
          currentAccountPicture: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.green, size: 40),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home, color: Colors.green),
          title: const Text('Home'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.person, color: Colors.green),
          title: const Text('About'),
          onTap: () {
            Navigator.pop(context);
            Get.toNamed('/about');
          },
        ),
        ListTile(
          leading: const Icon(Icons.tag, color: Colors.green),
          title: const Text('Products'),
          onTap: () {
            Navigator.pop(context);
            Get.toNamed('/products');
          },
        ),
        ListTile(
          leading: const Icon(Icons.contact_mail, color: Colors.green),
          title: const Text('Contact'),
          onTap: () {
            Navigator.pop(context);
            Get.toNamed('/contact');
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.green),
          title: const Text('Logout'),
          onTap: () async {
            await authController.logout();
            Get.offAllNamed('/login');
          },
        ),
      ],
    );
  }
}
