import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppUtils {
  static String formatPrice(double price) {
    return '${price.toStringAsFixed(2)} ر.س';
  }

  static double calculateTotal(List<Map<String, dynamic>> items) {
    return items.fold(0.0, (sum, item) => sum + double.parse(item['price']));
  }

  static void showSnackBar(BuildContext context, String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color ?? AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static LinearGradient getGradient(Color start, Color end) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [start, end],
    );
  }
}