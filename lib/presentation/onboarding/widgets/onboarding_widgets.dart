import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Segmented progress indicator shown at the top of the onboarding wizard.
class OnboardingProgressBar extends StatelessWidget {
  const OnboardingProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
      children: List.generate(totalSteps, (i) {
        final reached = i <= currentStep;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == totalSteps - 1 ? 0 : 6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              height: 5,
              decoration: BoxDecoration(
                color: reached ? colors.primary : colors.outline,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Icon badge + title + subtitle shown at the top of every step.
class OnboardingStepHeader extends StatelessWidget {
  const OnboardingStepHeader({
    super.key,
    this.icon,
    this.emoji,
    required this.title,
    required this.subtitle,
  });

  final IconData? icon;
  final String? emoji;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
          ),
          child:
              icon != null
                  ? Icon(icon, size: 28, color: colors.primary)
                  : Text(emoji ?? '', style: const TextStyle(fontSize: 28)),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            fontSize: 26,
            height: 1.2,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            height: 1.45,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Small rounded information pill with an icon.
class OnboardingInfoPill extends StatelessWidget {
  const OnboardingInfoPill({
    super.key,
    required this.icon,
    required this.text,
    this.color,
  });

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final effectiveColor = color ?? colors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: effectiveColor.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: effectiveColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.4,
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Selectable amount / option chip used for presets.
class OnboardingChip extends StatelessWidget {
  const OnboardingChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      backgroundColor: colors.surfaceHigh,
      selectedColor: colors.primary,
      side: BorderSide(color: selected ? colors.primary : colors.outline),
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: selected ? colors.onPrimary : colors.textPrimary,
      ),
    );
  }
}

/// Shared input decoration matching the rest of the app's sheets.
InputDecoration onboardingInputDecoration(
  BuildContext context, {
  required String label,
  String? hint,
  String? prefixText,
  IconData? icon,
}) {
  final colors = AppColors.of(context);
  OutlineInputBorder border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color, width: width),
      );

  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: TextStyle(color: colors.textSecondary, fontSize: 13),
    hintStyle: TextStyle(color: colors.textSecondary),
    prefixText: prefixText,
    prefixStyle: TextStyle(
      color: colors.textPrimary,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    prefixIcon:
        icon == null ? null : Icon(icon, color: colors.primary, size: 22),
    counterText: '',
    filled: true,
    fillColor: colors.surfaceHigh,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    border: border(colors.outline),
    enabledBorder: border(colors.outline),
    focusedBorder: border(colors.primary, 2),
  );
}
