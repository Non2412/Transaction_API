import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/expandable_info_card.dart'; // import ไฟล์ที่แยก

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'เกี่ยวกับเรา',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo/Icon Section
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.info_outline,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // App Name
            const Center(
              child: Text(
                'Transaction_API App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Version
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // ใช้ ExpandableInfoCard ที่แยกไฟล์แล้ว
            const ExpandableInfoCard(
              icon: Icons.description,
              title: 'เกี่ยวกับแอปพลิเคชัน',
              content: 'แอปพลิเคชันนี้พัฒนาด้วย Flutter เพื่อให้ผู้ใช้งานสามารถเข้าถึงข้อมูลและบริการต่างๆ ได้อย่างสะดวกและรวดเร็ว โดยมุ่งเน้นการใช้งานที่ง่ายและประสิทธิภาพที่ดี',
            ),
            const SizedBox(height: 20),

            const ExpandableInfoCard(
              icon: Icons.developer_mode,
              title: 'ผู้พัฒนา',
              content: 'พัฒนาโดยทีมงานผู้เชี่ยวชาญด้านการพัฒนาแอปพลิเคชันมือถือ ที่มีประสบการณ์ในการใช้เทคโนโลยี Flutter และ Dart ในการสร้างแอปพลิเคชันที่มีคุณภาพสูง',
            ),
            const SizedBox(height: 20),

            const ExpandableInfoCard(
              icon: Icons.contact_mail,
              title: 'ติดต่อเรา',
              content: 'หากมีข้อสงสัยหรือต้องการความช่วยเหลือ สามารถติดต่อเราได้ผ่าน Contact ที่แอปพลิเคชัน หรือส่งข้อความถึงทีมงานของเราได้ตลอดเวลา เราพร้อมให้บริการและแก้ไขปัญหาต่างๆ',
            ),
            const SizedBox(height: 30),

            // Additional Info Cards (ใช้ฟังก์ชันเดิม)
            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    icon: Icons.security,
                    title: 'ปลอดภัย',
                    subtitle: 'ข้อมูลเข้ารหัส',
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildFeatureCard(
                    icon: Icons.speed,
                    title: 'รวดเร็ว',
                    subtitle: 'ประสิทธิภาพสูง',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    icon: Icons.phone_android,
                    title: 'ใช้ง่าย',
                    subtitle: 'UI ที่เป็นมิตร',
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildFeatureCard(
                    icon: Icons.update,
                    title: 'อัพเดท',
                    subtitle: 'ปรับปรุงสม่ำเสมอ',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Copyright
            Center(
              child: Text(
                '© 2024 Transaction_API App\nAll rights reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ฟังก์ชันเดิมที่เหลือ - ไม่เปลี่ยนแปลง
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.blue[600],
              size: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}