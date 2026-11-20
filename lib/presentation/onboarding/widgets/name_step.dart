import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import 'onboarding_widgets.dart';

/// Step 1 - ask what the app should call the user.
class NameStep extends StatelessWidget {
  const NameStep({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OnboardingStepHeader(
          icon: Icons.person_rounded,
          title: 'What should we call you?',
          subtitle:
              'Enter the name or nickname you want to see on your dashboard.',
        ),
        const SizedBox(height: 28),
        TextField(
          key: const Key('onboarding_name_field'),
          controller: controller,
          onChanged: onChanged,
          onSubmitted: (_) => onSubmitted(),
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          maxLength: 24,
          inputFormatters: [LengthLimitingTextInputFormatter(24)],
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
          decoration: onboardingInputDecoration(
            context,
            label: 'Your name',
            hint: 'e.g. Adam',
            icon: Icons.person_rounded,
          ),
        ),
        const SizedBox(height: 18),
        const OnboardingInfoPill(
          icon: Icons.lock_rounded,
          text: 'DanBudget saves your profile and budget on this device.',
        ),
      ],
    );
  }
}
