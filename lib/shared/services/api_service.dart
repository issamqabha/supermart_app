import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ApiService {
  static Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      final String response = await rootBundle.loadString('assets/data/products.json');
      final List<dynamic> data = json.decode(response);
      print('تم تحميل ${data.length} منتجات من products.json');
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      print('خطأ في تحميل products.json: $e - استخدام بيانات احتياطية');
      return [
        {'name': 'تفاح أحمر', 'price': '15.00', 'image': '🍎', 'color': '#FF0000'},
        {'name': 'موز', 'price': '8.00', 'image': '🍌', 'color': '#FFFF00'},
        {'name': 'عصير برتقال', 'price': '12.00', 'image': '🧃', 'color': '#FFA500'},
        {'name': 'خبز توست', 'price': '5.00', 'image': '🍞', 'color': '#D2B48C'},
        {'name': 'لبن', 'price': '10.00', 'image': '🥛', 'color': '#FFFFFF'},
        {'name': 'بيض', 'price': '20.00', 'image': '🥚', 'color': '#FFFFFF'},
      ];
    }
  }
}