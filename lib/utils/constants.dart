import 'package:flutter/material.dart';

class CategoryConstants {
  static const Map<String, IconData> categoryIcons = {
    'Food': Icons.restaurant,
    'Transport': Icons.directions_car,
    'Bills': Icons.receipt_long,
    'Shopping': Icons.shopping_bag,
    'Entertainment': Icons.movie,
    'Salary': Icons.payments,
    'Others': Icons.category,
  };

  static IconData getIcon(String category) {
    return categoryIcons[category] ?? Icons.help_outline;
  }
}
