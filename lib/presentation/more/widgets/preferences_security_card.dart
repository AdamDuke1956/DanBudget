import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/local/app_database.dart';
import '../../../data/providers/dashboard_provider.dart';
import '../../../data/providers/database_providers.dart';
import '../../tax/tax_optimizer_screen.dart';

class PreferencesSecurityCard extends ConsumerWidget {
  const PreferencesSecurityCard({super.key, required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final profile = state.profile;
    final activeTheme = ref.watch(themeModeProvider);

    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preferences & Security',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Theme',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _ThemeModeTile(
                  title: 'Dark / Emerald',
                  subtitle: 'Obsidian Night',
                  icon: Icons.dark_mode_rounded,
                  activeColor: const Color(0xFF10B981),
                  isSelected: activeTheme == AppThemeMode.darkGreen,
                  onTap: () => ref.read(themeModeProvider.notifier).setTheme(AppThemeMode.darkGreen),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ThemeModeTile(
                  title: 'White / Crimson',
                  subtitle: 'Malaysian Ringgit',
                  icon: Icons.light_mode_rounded,
                  activeColor: const Color(0xFFE11D48),
                  isSelected: activeTheme == AppThemeMode.whiteRed,
                  onTap: () => ref.read(themeModeProvider.notifier).setTheme(AppThemeMode.whiteRed),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: colors.outline.withValues(alpha: 0.5), height: 1),
          const SizedBox(height: 6),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Biometric App Lock',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textPrimary),
            ),
            subtitle: Text(
              'Require fingerprint or Face ID on launch',
              style: TextStyle(fontSize: 12, color: colors.textSecondary),
            ),
            activeColor: colors.primary,
            value: profile.biometricLockEnabled,
            onChanged: (val) => _toggleBiometric(context, ref, val),
          ),
          Divider(color: colors.outline.withValues(alpha: 0.5), height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Cashflow Advisor',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textPrimary),
            ),
            subtitle: Text(
              'Show budget advice on the Plan tab',
              style: TextStyle(fontSize: 12, color: colors.textSecondary),
            ),
            activeColor: colors.primary,
            value: profile.aiAdviceEnabled,
            onChanged: (val) {
              ref.read(profileRepositoryProvider).updateProfile(
                    UserProfileTableCompanion(
                      aiAdviceEnabled: drift.Value(val),
                    ),
                  );
            },
          ),
          if (!state.employmentType.isIntern) ...[
            Divider(color: colors.outline.withValues(alpha: 0.5), height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.account_balance_rounded, color: colors.primary, size: 20),
              ),
              title: Text(
                'Income Tax (Form BE)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textPrimary),
              ),
              subtitle: Text(
                'Reliefs, receipts & refund estimate',
                style: TextStyle(fontSize: 12, color: colors.textSecondary),
              ),
              trailing: Icon(Icons.chevron_right_rounded, color: colors.textSecondary),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TaxOptimizerScreen()),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _toggleBiometric(BuildContext context, WidgetRef ref, bool val) async {
    final colors = AppColors.of(context);
    if (val) {
      final auth = LocalAuthentication();
      final canCheck = await auth.canCheckBiometrics;
      final isSupported = await auth.isDeviceSupported();

      if (!canCheck && !isSupported) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: colors.surfaceHigh,
              content: Text(
                'Biometrics not enrolled or unavailable on this device.',
                style: TextStyle(color: colors.warning),
              ),
            ),
          );
        }
        return;
      }

      try {
        final didAuth = await auth.authenticate(
          localizedReason: 'Scan fingerprint or Face ID to confirm biometric lock',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: false,
          ),
        );
        if (!didAuth) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: colors.surfaceHigh,
                content: Text(
                  'Biometric confirmation cancelled.',
                  style: TextStyle(color: colors.textSecondary),
                ),
              ),
            );
          }
          return;
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: colors.surfaceHigh,
              content: Text(
                'Biometric check error: $e',
                style: TextStyle(color: colors.danger),
              ),
            ),
          );
        }
        return;
      }
    }

    ref.read(profileRepositoryProvider).updateProfile(
          UserProfileTableCompanion(
            biometricLockEnabled: drift.Value(val),
          ),
        );
  }
}

class _ThemeModeTile extends StatelessWidget {
  const _ThemeModeTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.activeColor,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color activeColor;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withValues(alpha: 0.12) : colors.surfaceHigh,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? activeColor : colors.cardBorder,
              width: isSelected ? 1.8 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isSelected ? activeColor.withValues(alpha: 0.2) : colors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 16,
                      color: isSelected ? activeColor : colors.textSecondary,
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: activeColor,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, color: colors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
