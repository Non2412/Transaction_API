import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool _isAppInfoExpanded = false;
  bool _isDeveloperExpanded = false;
  bool _isContactExpanded = false;

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

            // Expandable About Content
            _buildExpandableInfoCard(
              icon: Icons.description,
              title: 'เกี่ยวกับแอปพลิเคชัน',
              content: 'แอปพลิเคชันนี้พัฒนาด้วย Flutter เพื่อให้ผู้ใช้งานสามารถเข้าถึงข้อมูลและบริการต่างๆ ได้อย่างสะดวกและรวดเร็ว โดยมุ่งเน้นการใช้งานที่ง่ายและประสิทธิภาพที่ดี',
              isExpanded: _isAppInfoExpanded,
              onTap: () {
                setState(() {
                  _isAppInfoExpanded = !_isAppInfoExpanded;
                });
              },
            ),

            const SizedBox(height: 20),

            _buildExpandableInfoCard(
              icon: Icons.developer_mode,
              title: 'ผู้พัฒนา',
              content: 'พัฒนาโดยทีมนักศึกษาสาขาวิทยาการคอมพิวเตอร์ที่กำลังศึกษาด้านการพัฒนาแอปพลิเคชันมือถือ โดยการใช้เทคโนโลยี Flutter และ Dart ในการสร้างแอปพลิเคชัน',
              isExpanded: _isDeveloperExpanded,
              onTap: () {
                setState(() {
                  _isDeveloperExpanded = !_isDeveloperExpanded;
                });
              },
            ),

            const SizedBox(height: 20),

            _buildExpandableInfoCard(
              icon: Icons.contact_mail,
              title: 'ติดต่อเรา',
              content: 'หากมีข้อสงสัยหรือต้องการความช่วยเหลือ สามารถติดต่อเราได้ผ่าน Contact ที่แอปพลิเคชัน หรือส่งข้อความถึงทีมงานของเราได้ตลอดเวลา เราพร้อมให้บริการและแก้ไขปัญหาต่างๆ',
              isExpanded: _isContactExpanded,
              onTap: () {
                setState(() {
                  _isContactExpanded = !_isContactExpanded;
                });
              },
            ),

            const SizedBox(height: 30),

            // Additional Info Cards
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

  Widget _buildExpandableInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.blue[600],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: isExpanded 
              ? CrossFadeState.showSecond 
              : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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