import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  
  bool _isEditing = false;
  Map<String, dynamic>? productData;

  @override
  void initState() {
    super.initState();
    
    // รับข้อมูลจาก GetX arguments
    productData = Get.arguments as Map<String, dynamic>?;
    
    _nameController = TextEditingController(
      text: productData?['name'] ?? '',
    );
    _priceController = TextEditingController(
      text: productData?['price']?.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: productData?['description'] ?? '',
    );
    _categoryController = TextEditingController(
      text: productData?['category'] ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = {
        'id': productData?['id'],
        'name': _nameController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'description': _descriptionController.text,
        'category': _categoryController.text,
      };

      // ส่งข้อมูลกลับไปหน้าก่อนหน้า
      Get.back(result: {
        'action': 'update',
        'data': updatedProduct,
      });

      Get.snackbar(
        'สำเร็จ',
        'บันทึกข้อมูลสินค้าเรียบร้อยแล้ว',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _deleteProduct() {
    Get.dialog(
      AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: Text(
          'คุณต้องการลบสินค้า "${_nameController.text}" หรือไม่?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // ปิด dialog
              
              // ส่งข้อมูลกลับไปหน้าก่อนหน้า
              Get.back(result: {
                'action': 'delete',
                'data': productData,
              });

              Get.snackbar(
                'สำเร็จ',
                'ลบสินค้าเรียบร้อยแล้ว',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
              );
            },
            child: const Text(
              'ลบ',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดสินค้า'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (productData != null)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _toggleEdit();
                } else if (value == 'delete') {
                  _deleteProduct();
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(_isEditing ? Icons.cancel : Icons.edit),
                      const SizedBox(width: 8),
                      Text(_isEditing ? 'ยกเลิก' : 'แก้ไข'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('ลบ', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: productData == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'หน้ารายละเอียดสินค้า',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'เลือกสินค้าจากหน้ารายการสินค้าเพื่อดูรายละเอียด',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image Placeholder
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: const Icon(
                        Icons.image,
                        size: 80,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Product Name
                    _buildFieldCard(
                      title: 'ชื่อสินค้า',
                      child: TextFormField(
                        controller: _nameController,
                        enabled: _isEditing,
                        decoration: InputDecoration(
                          border: _isEditing 
                              ? const OutlineInputBorder()
                              : InputBorder.none,
                          contentPadding: const EdgeInsets.all(12),
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _isEditing ? Colors.black : Colors.black87,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณาใส่ชื่อสินค้า';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Product Price
                    _buildFieldCard(
                      title: 'ราคา',
                      child: TextFormField(
                        controller: _priceController,
                        enabled: _isEditing,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: _isEditing 
                              ? const OutlineInputBorder()
                              : InputBorder.none,
                          contentPadding: const EdgeInsets.all(12),
                          suffixText: 'บาท',
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w600,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณาใส่ราคา';
                          }
                          if (double.tryParse(value) == null) {
                            return 'กรุณาใส่ราคาที่ถูกต้อง';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Product Category
                    _buildFieldCard(
                      title: 'หมวดหมู่',
                      child: TextFormField(
                        controller: _categoryController,
                        enabled: _isEditing,
                        decoration: InputDecoration(
                          border: _isEditing 
                              ? const OutlineInputBorder()
                              : InputBorder.none,
                          contentPadding: const EdgeInsets.all(12),
                        ),
                        style: const TextStyle(fontSize: 16),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณาใส่หมวดหมู่';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Product Description
                    _buildFieldCard(
                      title: 'รายละเอียด',
                      child: TextFormField(
                        controller: _descriptionController,
                        enabled: _isEditing,
                        maxLines: _isEditing ? 4 : null,
                        decoration: InputDecoration(
                          border: _isEditing 
                              ? const OutlineInputBorder()
                              : InputBorder.none,
                          contentPadding: const EdgeInsets.all(12),
                        ),
                        style: const TextStyle(fontSize: 16),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กrุณาใส่รายละเอียดสินค้า';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save Button (only show when editing)
                    if (_isEditing)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'บันทึกการเปลี่ยนแปลง',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildFieldCard({
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}