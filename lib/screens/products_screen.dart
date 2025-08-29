import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/drawer.dart';

class Product {
  final int id;
  final String name;
  final double price;
  final String category;
  final int stock;
  final String image;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.stock,
    required this.image,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'category': category,
        'stock': stock,
        'image': image,
        'description': description,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        price: json['price'].toDouble(),
        category: json['category'],
        stock: json['stock'],
        image: json['image'],
        description: json['description'],
      );

  // เพิ่ม copyWith method สำหรับการอัปเดต
  Product copyWith({
    int? id,
    String? name,
    double? price,
    String? category,
    int? stock,
    String? image,
    String? description,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      image: image ?? this.image,
      description: description ?? this.description,
    );
  }
}

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> products = [];

  String searchTerm = '';
  String selectedCategory = '';

  // Form controllers for adding new product
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<String> categories = [
    'อีเล็กทรอนิกส์',
    'คอมพิวเตอร์',
    'อุปกรณ์เสียง',
    'แฟชั่น',
    'บ้านและสวน'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการสินค้า'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.green[50], // เปลี่ยนพื้นหลังส่วนค้นหา
            child: Column(
              children: [
                // Search Bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchTerm = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'ค้นหาสินค้า...',
                    prefixIcon: const Icon(Icons.search, color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.green, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                // Category Filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('ทั้งหมด'),
                        selected: selectedCategory == '',
                        selectedColor: Colors.green,
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: selectedCategory == '' ? Colors.white : Colors.green,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            selectedCategory = '';
                          });
                        },
                        backgroundColor: Colors.green[50],
                      ),
                      const SizedBox(width: 8),
                      ...categories
                          .map((category) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(category),
                                  selected: selectedCategory == category,
                                  selectedColor: Colors.green,
                                  checkmarkColor: Colors.white,
                                  labelStyle: TextStyle(
                                    color: selectedCategory == category ? Colors.white : Colors.green,
                                  ),
                                  onSelected: (selected) {
                                    setState(() {
                                      selectedCategory = selected ? category : '';
                                    });
                                  },
                                  backgroundColor: Colors.green[50],
                                ),
                              ))
                          .toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Products List
          Expanded(
            child: _buildProductsList(),
          ),
        ],
      ),

      // Floating Action Button for Adding Product
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        tooltip: 'เพิ่มสินค้าใหม่',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildProductsList() {
    List<Product> filteredProducts = products.where((product) {
      bool matchesSearch = searchTerm.isEmpty ||
          product.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
          product.description.toLowerCase().contains(searchTerm.toLowerCase());

      bool matchesCategory =
          selectedCategory.isEmpty || product.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    if (filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'ยังไม่มีสินค้า กรุณาเพิ่มสินค้าใหม่',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.green[50],
                border: Border.all(color: Colors.green.shade100, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.green[50],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.green,
                        size: 36,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.green[50],
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          product.category,
                          style: TextStyle(
                            color: Colors.green[800],
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.inventory, size: 16, color: Colors.green[400]),
                      Text(
                        ' คงเหลือ: ${product.stock}',
                        style: TextStyle(
                          color: product.stock > 10 ? Colors.green : Colors.orange,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '฿${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductDialog() {
    _clearForm();
    showDialog(
      context: context,
      builder: (context) => _buildProductDialog(),
    );
  }

  Widget _buildProductDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'เพิ่มสินค้าใหม่',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Form Fields
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อสินค้า',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ราคา',
                  border: OutlineInputBorder(),
                  prefixText: '฿ ',
                ),
                onChanged: (value) {
                  setState(() {
                    _priceController.text = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _categoryController.text.isEmpty
                    ? null
                    : _categoryController.text,
                decoration: const InputDecoration(
                  labelText: 'หมวดหมู่',
                  border: OutlineInputBorder(),
                ),
                items: categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _categoryController.text = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'จำนวนคงเหลือ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'URL รูปภาพ (ไม่บังคับ)',
                  border: OutlineInputBorder(),
                  hintText: 'https://example.com/image.jpg',
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'คำอธิบาย',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('ยกเลิก'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _saveProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('เพิ่ม'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProduct() {
    if (_validateForm()) {
      final newProduct = Product(
        id: _generateNewId(),
        name: _nameController.text.trim(),
        price: double.parse(_priceController.text),
        category: _categoryController.text,
        stock: int.parse(_stockController.text),
        image: _imageController.text.trim().isEmpty
            ? 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=300&h=300&fit=crop'
            : _imageController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      setState(() {
        products.add(newProduct);
      });

      Navigator.pop(context);
      Get.snackbar(
        'สำเร็จ',
        'เพิ่มสินค้าสำเร็จ',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  bool _validateForm() {
    // ตรวจสอบข้อมูลที่จำเป็น
    if (_nameController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty ||
        _categoryController.text.isEmpty ||
        _stockController.text.trim().isEmpty) {
      Get.snackbar(
        'ข้อผิดพลาด',
        'กรุณากรอกข้อมูลให้ครบถ้วน',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // ตรวจสอบรูปแบบตัวเลข
    if (double.tryParse(_priceController.text) == null) {
      Get.snackbar(
        'ข้อผิดพลาด',
        'กรุณากรอกราคาให้ถูกต้อง',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (int.tryParse(_stockController.text) == null) {
      Get.snackbar(
        'ข้อผิดพลาด',
        'กรุณากรอกจำนวนคงเหลือให้ถูกต้อง',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // ตรวจสอบค่าที่ต้องเป็นบวก
    if (double.parse(_priceController.text) <= 0) {
      Get.snackbar(
        'ข้อผิดพลาด',
        'ราคาต้องมากกว่า 0',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (int.parse(_stockController.text) < 0) {
      Get.snackbar(
        'ข้อผิดพลาด',
        'จำนวนคงเหลือต้องไม่ติดลบ',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  int _generateNewId() {
    if (products.isEmpty) return 1;
    return products.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  void _clearForm() {
    _nameController.clear();
    _priceController.clear();
    _categoryController.clear();
    _stockController.clear();
    _imageController.clear();
    _descriptionController.clear();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _stockController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}