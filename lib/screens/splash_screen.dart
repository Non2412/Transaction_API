import 'package:flutter/material.dart';
import '../utils/navigation_helper.dart';
import '../services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startSplashSequence();
  }

  void _initAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Logo animations
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    // Text animations
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
  }

  Future<void> _startSplashSequence() async {
    // เริ่ม logo animation
    _logoController.forward();

    // รอ 800ms แล้วเริ่ม text animation
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    // รอให้ animation เสร็จ แล้วตรวจสอบสถานะผู้ใช้
    await Future.delayed(const Duration(milliseconds: 2200));
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    try {
      // ตรวจสอบว่าผู้ใช้เคยล็อกอินหรือไม่
      final isLoggedIn = await _checkLoginStatus();

      if (isLoggedIn) {
        // ถ้าล็อกอินแล้ว ไปหน้า Home
        NavigationHelper.toHome(clearStack: true);

        // ถ้าล็อกอินแล้ว ไปหน้า Home
        NavigationHelper.offAllNamed('/home');
      } else {
        // ถ้ายังไม่ล็อกอิน ไปหน้า Login
        NavigationHelper.offAllNamed('/login');
      }
    } catch (e) {
      // ถ้าเกิดข้อผิดพลาด ไปหน้า Login
      NavigationHelper.offAllNamed('/login');
    }
  }

  Future<bool> _checkLoginStatus() async {
    try {
      final storageService = StorageService();
      await storageService.init();
      return storageService.hasToken();
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700], // เขียวเข้ม
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF43EA7A), Color(0xFF178A3D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _logoScaleAnimation,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.shield, color: Colors.green[700], size: 60),
                  ),
                ),
                const SizedBox(height: 32),
                FadeTransition(
                  opacity: _textOpacityAnimation,
                  child: SlideTransition(
                    position: _textSlideAnimation,
                    child: Column(
                      children: [
                        Text(
                          'SSKRU ComSci',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                blurRadius: 8,
                                color: Colors.black26,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Secure • Simple • Smart',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'กำลังเตรียมแอปพลิเคชัน...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Footer
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Column(
              children: const [
                Text(
                  'เวอร์ชัน 1.0.0',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  '© 2024 Form Validate App',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
