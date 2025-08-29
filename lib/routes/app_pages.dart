import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เกี่ยวกับเรา'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Center(
        child: Card(
          elevation: 10,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Padding(
            padding: const EdgeInsets.all(36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 54,
                  backgroundColor: Colors.green[100],
                  child: Icon(Icons.info_outline, size: 54, color: Colors.green[700]),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Form Validate App',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 16),
                const Text(
                  'แอปสำหรับจัดการระบบ Authentication และฟอร์มต่าง ๆ ด้วย Flutter\n\nพัฒนาโดยทีม SSKRU ComSci',
                  style: TextStyle(fontSize: 17, color: Colors.black87, height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.email, color: Colors.green, size: 22),
                    SizedBox(width: 8),
                    Text('support@email.com', style: TextStyle(fontSize: 17)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.phone, color: Colors.green, size: 22),
                    SizedBox(width: 8),
                    Text('02-123-4567', style: TextStyle(fontSize: 17)),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'เวอร์ชัน 1.0.0',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
     ),
    );
  }
}
