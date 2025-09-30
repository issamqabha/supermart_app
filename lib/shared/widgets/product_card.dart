import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import 'custom_button.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String image;
  final Color color;
  final VoidCallback onAdd;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.color,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppUtils.getGradient(color, Colors.white),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Center(
                child: Text(
                  image,
                  style: const TextStyle(fontSize: 50),
                ),
              ),
            ).animate().scale(duration: 300.ms),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(AppUtils.formatPrice(double.parse(price)), style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                CustomButton(
                  text: 'أضف إلى السلة',
                  onPressed: onAdd,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3);
  }
}