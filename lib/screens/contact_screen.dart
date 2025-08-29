import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ติดต่อเรา'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ข้อมูลติดต่อ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            
            // ข้อมูลติดต่อ
            ContactInfoCard(),
            
            SizedBox(height: 20),
            
            // ฟอร์มติดต่อ
            ContactForm(),
          ],
        ),
      ),
    );
  }
}

// Widget สำหรับแสดงข้อมูลติดต่อ
class ContactInfoCard extends StatelessWidget {
  const ContactInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text('โทรศัพท์'),
              subtitle: const Text('094-510-3675'),
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.red),
              title: const Text('อีเมล'),
              subtitle: const Text('stu6612732135@sskru.ac.th'),
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.blue),
              title: const Text('ที่อยู่'),
              subtitle: const Text('มหาวิทยาลัยราชภัฏศรีสะเกษ คณะศิลปศาสาสและวิทยาศาสตร์ สาขาวิทยาการคอมพิวเตอร์ '
                  '  ถนนสุขาภิบาล ตำบลเมืองใต้ อำเภอเมือง จังหวัดศรีสะเกษ 33000'),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget สำหรับฟอร์มติดต่อ
class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ส่งข้อความถึงเรา',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อ',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'อีเมล',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกอีเมล';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'รูปแบบอีเมลไม่ถูกต้อง';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _messageController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'ข้อความ',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.message),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกข้อความ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // ส่งข้อมูล
                      Get.snackbar(
                        'สำเร็จ',
                        'ส่งข้อความเรียบร้อยแล้ว',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      
                      // ล้างฟอร์ม
                      _nameController.clear();
                      _emailController.clear();
                      _messageController.clear();
                    }
                  },
                  child: const Text('ส่งข้อความ'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}