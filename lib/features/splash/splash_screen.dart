import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppUtils.getGradient(Colors.white, Colors.grey[300]!),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: Icon(
                Icons.shopping_cart,
                size: 60,
                color: AppColors.primary,
              ),
            ).animate().scale(duration: 800.ms, curve: Curves.elasticOut).shake(duration: 500.ms),
            const SizedBox(height: 30),
            const Text(
              "SUPERMART",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.5),
            const SizedBox(height: 10),
            const Text(
              "تسوق بذكاء، عيش براحة",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: CircularProgressIndicator(
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 3,
        ).animate().scale(delay: 1000.ms).fadeIn(),
      ),
    );
  }
}