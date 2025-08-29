import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'products_screen.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final _formKey = GlobalKey<FormState>();
  late ProductController productController;

  // Form Controllers
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageController = TextEditingController();

  Product? _selectedProduct;
  bool _isEditing = false;

  final List<String> categories = [
    'อีเล็กทรอนิกส์',
    'คอมพิวเตอร์',
    'อุปกรณ์เสียง',
    'แฟชั่น',
    'บ้านและสวน'
  ];

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<ProductController>()) {
      productController = Get.find<ProductController>();
    } else {
      productController = Get.put(ProductController());
    }
    if (productController.products.isNotEmpty) {
      _loadProduct(productController.products.first);
    }
  }

  void _loadProduct(Product product) {
    setState(() {
      _selectedProduct = product;
      _nameController.text = product.name;
      _priceController.text = product.price.toString();
      _descriptionController.text = product.description;
      _categoryController.text = product.category;
      _stockController.text = product.stock.toString();
      _imageController.text = product.image;
      _isEditing = false;
    });
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
  }

  void _saveProduct() {
    if (!_formKey.currentState!.validate() || _selectedProduct == null) return;
    final updated = _selectedProduct!.copyWith(
      name: _nameController.text.trim(),
      price: double.tryParse(_priceController.text) ?? 0,
      description: _descriptionController.text.trim(),
      category: _categoryController.text,
      stock: int.tryParse(_stockController.text) ?? 0,
      image: _imageController.text.trim(),
    );
    productController.updateProduct(updated);
    _loadProduct(updated);
    Get.snackbar('สำเร็จ', 'บันทึกการแก้ไขแล้ว',
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  void _deleteProduct() {
    if (_selectedProduct == null) return;
    Get.defaultDialog(
      title: "ลบสินค้า",
      middleText: 'คุณต้องการลบ "${_selectedProduct!.name}" ใช่หรือไม่?',
      textCancel: "ยกเลิก",
      textConfirm: "ลบ",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        productController.deleteProduct(_selectedProduct!.id);
        if (productController.products.isNotEmpty) {
          _loadProduct(productController.products.first);
        } else {
          setState(() => _selectedProduct = null);
        }
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("จัดการสินค้า"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (productController.products.isEmpty) {
          return const Center(child: Text("ยังไม่มีสินค้า"));
        }
        return Column(
          children: [
            // แสดงสินค้าด้านบนแบบการ์ดแนวนอน
            SizedBox(
              height: 190,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                scrollDirection: Axis.horizontal,
                itemCount: productController.products.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final p = productController.products[index];
                  final isSelected = _selectedProduct?.id == p.id;

                  return GestureDetector(
                    onTap: () => _loadProduct(p),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? Colors.green : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // รูปสินค้า
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.network(
                                p.image,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.green[50],
                                  child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          // ชื่อและราคา
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "฿${p.price}",
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ฟอร์มแก้ไข
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _selectedProduct == null
                    ? const Text("เลือกสินค้าเพื่อแก้ไข")
                    : Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildInput(_nameController, "ชื่อสินค้า"),
                            const SizedBox(height: 12),
                            _buildInput(_priceController, "ราคา",
                                keyboard: TextInputType.number),
                            const SizedBox(height: 12),
                            _buildInput(_descriptionController, "รายละเอียด",
                                maxLines: 3),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: _categoryController.text.isNotEmpty
                                  ? _categoryController.text
                                  : null,
                              onChanged: _isEditing
                                  ? (v) => _categoryController.text = v ?? ''
                                  : null,
                              items: categories
                                  .map((c) =>
                                      DropdownMenuItem(value: c, child: Text(c)))
                                  .toList(),
                              decoration:
                                  const InputDecoration(labelText: "หมวดหมู่"),
                            ),
                            const SizedBox(height: 12),
                            _buildInput(_stockController, "สต๊อก",
                                keyboard: TextInputType.number),
                            const SizedBox(height: 12),
                            _buildInput(_imageController, "ลิงก์รูปภาพ"),
                            const SizedBox(height: 24),

                            // ปุ่มแก้ไข/ลบ
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _toggleEdit,
                                    icon: Icon(
                                        _isEditing ? Icons.cancel : Icons.edit),
                                    label: Text(_isEditing ? "ยกเลิก" : "แก้ไข"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _deleteProduct,
                                    icon: const Icon(Icons.delete_outline),
                                    label: const Text("ลบ"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            if (_isEditing)
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: ElevatedButton.icon(
                                  onPressed: _saveProduct,
                                  icon: const Icon(Icons.save),
                                  label: const Text("บันทึกการแก้ไข"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 32),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildInput(TextEditingController c, String label,
      {TextInputType? keyboard, int maxLines = 1}) {
    return TextFormField(
      controller: c,
      enabled: _isEditing,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: _isEditing ? Colors.white : Colors.grey[100],
      ),
    );
  }
}
