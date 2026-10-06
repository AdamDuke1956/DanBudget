import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'glass_card.dart';

/// Temporary screen body for tabs that are built in later phases.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.phase,
    required this.description,
  });

  final String title;
  final IconData icon;
  final String phase;
  final String description;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 48, color: AppColors.primary),
                const SizedBox(height: 16),
                Text(title, style: text.titleLarge),
                const SizedBox(height: 8),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: text.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Chip(label: Text('Coming in $phase')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
