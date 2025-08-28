import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Map<String, dynamic>> products = [
    {
      'id': 1,
      'name': 'iPhone 15 Pro Max',
      'price': 45900,
      'category': 'มือถือ',
      'stock': 15,
      'image': 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=300&h=300&fit=crop',
      'description': 'สมาร์ทโฟนรุ่นล่าสุดจาก Apple'
    },
    {
      'id': 2,
      'name': 'MacBook Air M2',
      'price': 42900,
      'category': 'คอมพิวเตอร์',
      'stock': 8,
      'image': 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=300&h=300&fit=crop',
      'description': 'แล็ปท็อปที่บางเบาและประหยัดพลังงาน'
    },
    {
      'id': 3,
      'name': 'AirPods Pro',
      'price': 8900,
      'category': 'อุปกรณ์เสริม',
      'stock': 25,
      'image': 'https://images.unsplash.com/photo-1606841837239-c5a1a4a07af7?w=300&h=300&fit=crop',
      'description': 'หูฟังไร้สายพร้อมระบบตัดเสียงรบกวน'
    }
  ];

  String searchTerm = '';
  String selectedCategory = '';
  bool showAddModal = false;

  Map<String, dynamic> formData = {
    'name': '',
    'price': '',
    'category': '',
    'stock': '',
    'image': '',
    'description': ''
  };

  final List<String> categories = [
    'มือถือ', 'คอมพิวเตอร์', 'อุปกรณ์เสริม', 'เครื่องใช้ไฟฟ้า', 'แฟชั่น', 'หนังสือ'
  ];

  List<Map<String, dynamic>> get filteredProducts {
    return products.where((product) {
      final matchesSearch = product['name'].toLowerCase().contains(searchTerm.toLowerCase()) ||
          product['description'].toLowerCase().contains(searchTerm.toLowerCase());
      final matchesCategory = selectedCategory.isEmpty || product['category'] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void handleInputChange(String field, dynamic value) {
    setState(() {
      formData[field] = value;
    });
  }

  void resetForm() {
    setState(() {
      formData = {
        'name': '',
        'price': '',
        'category': '',
        'stock': '',
        'image': '',
        'description': ''
      };
      showAddModal = false;
    });
  }

  // ...existing code...

  void handleSubmit() {
    if (formData['name'].isEmpty || formData['price'].isEmpty || formData['category'].isEmpty || formData['stock'].isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text('กรุณากรอกข้อมูลที่จำเป็นให้ครบถ้วน'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('ตกลง'),
            ),
          ],
        ),
      );
      return;
    }
    final productData = {
      ...formData,
      'price': int.tryParse(formData['price']) ?? 0,
      'stock': int.tryParse(formData['stock']) ?? 0,
    };
    final newProduct = {
      'id': products.isNotEmpty ? (products.map((p) => p['id'] as int).reduce((a, b) => a > b ? a : b) + 1) : 1,
      ...productData,
    };
    setState(() {
      products.add(newProduct);
    });
    resetForm();
  }

  void handleDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ยืนยันการลบ'),
        content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบสินค้านี้?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                products.removeWhere((product) => product['id'] == id);
              });
              Navigator.of(context).pop();
            },
            child: Text('ลบ'),
          ),
        ],
      ),
    );
  }

  int get totalValue => products.fold(0, (int sum, product) {
    final int price = product['price'] is int ? product['price'] : int.tryParse(product['price'].toString()) ?? 0;
    final int stock = product['stock'] is int ? product['stock'] : int.tryParse(product['stock'].toString()) ?? 0;
    return sum + (price * stock);
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการสินค้า'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(child: Text('มูลค่ารวม: ฿$totalValue')),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ระบบจัดการสินค้าและคลังสินค้า', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                    SizedBox(height: 8),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      showAddModal = true;
                    });
                  },
                  icon: Icon(Icons.add),
                  label: Text('เพิ่มสินค้าใหม่'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('รายการสินค้า (${filteredProducts.length} รายการ)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 8),
            Expanded(
              child: filteredProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2, size: 48, color: Colors.grey[400]),
                          SizedBox(height: 12),
                          Text('ไม่พบสินค้า', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('ลองเปลี่ยนคำค้นหาหรือเพิ่มสินค้าใหม่', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 900
                            ? 3
                            : MediaQuery.of(context).size.width > 600
                                ? 2
                                : 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.network(
                                  product['image'] ?? 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=300&h=300&fit=crop',
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    SizedBox(height: 4),
                                    Text(product['category'], style: TextStyle(color: Colors.grey[600])),
                                    SizedBox(height: 4),
                                    Text('฿${product['price']} | คงเหลือ: ${product['stock']}', style: TextStyle(color: Colors.blue[700])),
                                    SizedBox(height: 8),
                                    Text(product['description'], maxLines: 2, overflow: TextOverflow.ellipsis),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => handleDelete(product['id']),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      // สามารถเพิ่ม showDialog/modal สำหรับเพิ่มสินค้าใหม่ได้ที่นี่
    );
  }
}