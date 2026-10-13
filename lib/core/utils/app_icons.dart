import 'package:flutter/material.dart';

class AppIcons {
  const AppIcons._();

  static IconData getCategoryIcon(String idOrName) {
    final lower = idOrName.toLowerCase();
    if (lower.contains('food') || lower.contains('dining') || lower.contains('makan')) {
      return Icons.restaurant_rounded;
    }
    if (lower.contains('toll') || lower.contains('rfid')) {
      return Icons.directions_car_rounded;
    }
    if (lower.contains('petrol') || lower.contains('fuel') || lower.contains('minyak')) {
      return Icons.local_gas_station_rounded;
    }
    if (lower.contains('transit') || lower.contains('mrt') || lower.contains('lrt') || lower.contains('bus')) {
      return Icons.directions_subway_rounded;
    }
    if (lower.contains('bill') || lower.contains('utility') || lower.contains('elektrik') || lower.contains('air')) {
      return Icons.receipt_long_rounded;
    }
    if (lower.contains('grocer') || lower.contains('household') || lower.contains('pasar')) {
      return Icons.shopping_cart_rounded;
    }
    if (lower.contains('cafe') || lower.contains('social') || lower.contains('kopi') || lower.contains('coffee')) {
      return Icons.local_cafe_rounded;
    }
    if (lower.contains('shopping') || lower.contains('personal') || lower.contains('beli')) {
      return Icons.shopping_bag_rounded;
    }
    if (lower.contains('entertain') || lower.contains('sub') || lower.contains('netflix')) {
      return Icons.movie_outlined;
    }
    if (lower.contains('charity') || lower.contains('giving') || lower.contains('sedekah') || lower.contains('zakat')) {
      return Icons.volunteer_activism_rounded;
    }
    if (lower.contains('saving') || lower.contains('asb') || lower.contains('simpan')) {
      return Icons.savings_rounded;
    }
    return Icons.category_rounded;
  }

  static IconData getAccountIcon(String typeOrName) {
    final lower = typeOrName.toLowerCase();
    if (lower.contains('bank') || lower.contains('maybank') || lower.contains('cimb') || lower.contains('bimb') || lower.contains('bsn') || lower.contains('rhb') || lower.contains('public')) {
      return Icons.account_balance_rounded;
    }
    if (lower.contains('wallet') || lower.contains('tng') || lower.contains('touch') || lower.contains('grab') || lower.contains('boost')) {
      return Icons.phone_android_rounded;
    }
    if (lower.contains('cash') || lower.contains('dompet') || lower.contains('tunai')) {
      return Icons.payments_rounded;
    }
    return Icons.account_balance_wallet_rounded;
  }

  static IconData getCommitmentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'spaylater':
        return Icons.shopping_bag_rounded;
      case 'ptptn':
        return Icons.school_rounded;
      case 'mara':
        return Icons.menu_book_rounded;
      case 'car_loan':
        return Icons.directions_car_rounded;
      case 'sloan':
        return Icons.payments_rounded;
      case 'credit_card':
        return Icons.credit_card_rounded;
      case 'personal_loan':
        return Icons.account_balance_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }

  static IconData getSpayLaterTagIcon(String tag) {
    final lower = tag.toLowerCase();
    if (lower.contains('tech')) return Icons.headphones_rounded;
    if (lower.contains('fashion')) return Icons.checkroom_rounded;
    if (lower.contains('care')) return Icons.spa_rounded;
    if (lower.contains('home')) return Icons.home_rounded;
    if (lower.contains('study')) return Icons.backpack_rounded;
    return Icons.inventory_2_rounded;
  }

  static Widget badge({
    required IconData icon,
    required Color color,
    double size = 18,
    double containerSize = 36,
    double borderRadius = 10,
  }) {
    return Container(
      width: containerSize,
      height: containerSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(icon, color: color, size: size),
    );
  }
}
