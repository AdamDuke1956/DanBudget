import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/local/app_database.dart';
import '../../../data/providers/database_providers.dart';

class BiometricGuard extends ConsumerStatefulWidget {
  const BiometricGuard({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<BiometricGuard> createState() => _BiometricGuardState();
}

class _BiometricGuardState extends ConsumerState<BiometricGuard> {
  bool _isUnlocked = false;
  bool _isAuthenticating = false;
  String? _errorMessage;
  final LocalAuthentication _auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndPromptBiometric();
    });
  }

  Future<void> _checkAndPromptBiometric() async {
    final profile = await ref.read(userProfileStreamProvider.future);
    if (!profile.biometricLockEnabled) {
      if (mounted) setState(() => _isUnlocked = true);
      return;
    }

    _authenticate();
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;
    setState(() {
      _isAuthenticating = true;
      _errorMessage = null;
    });

    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();

      if (canCheck || isSupported) {
        final didAuth = await _auth.authenticate(
          localizedReason: 'Authenticate to access DanBudget',
          options: const AuthenticationOptions(
            biometricOnly: false,
            stickyAuth: true,
          ),
        );
        if (mounted && didAuth) {
          setState(() {
            _isUnlocked = true;
            _isAuthenticating = false;
          });
          return;
        } else if (mounted) {
          setState(() {
            _errorMessage = 'Biometric authentication was cancelled or not recognized. You can retry or bypass below.';
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = 'Biometrics not enrolled or supported on this device. Tap Bypass to enter.';
          });
        }
      }
    } on PlatformException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message ?? 'Authentication error occurred. Tap Bypass to enter.';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Unable to verify biometrics. Tap Bypass to enter.';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isAuthenticating = false);
      }
    }
  }

  Future<void> _disableBiometricLock() async {
    await ref.read(profileRepositoryProvider).updateProfile(
          const UserProfileTableCompanion(
            biometricLockEnabled: drift.Value(false),
          ),
        );
    if (mounted) {
      setState(() => _isUnlocked = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surfaceHigh,
          content: Text('Biometric lock disabled.',
              style: TextStyle(color: AppColors.textPrimary)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileStreamProvider);

    return profileAsync.when(
      loading: () => widget.child,
      error: (_, __) => widget.child,
      data: (profile) {
        if (!profile.biometricLockEnabled || _isUnlocked) {
          return widget.child;
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.fingerprint_rounded,
                        size: 54,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  Text(
                    'DanBudget Locked',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Biometric security is active to protect your payslip and financial data.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline_rounded,
                              color: AppColors.warning, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textPrimary,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _isAuthenticating ? null : _authenticate,
                      icon: _isAuthenticating
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.onPrimary,
                              ),
                            )
                          : const Icon(Icons.fingerprint_rounded, size: 22),
                      label: Text(
                        _isAuthenticating ? 'Authenticating...' : 'Unlock with Biometrics',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _isUnlocked = true),
                      icon: const Icon(Icons.lock_open_rounded, size: 18),
                      label: const Text(
                        'Bypass Lock (Emulator Fallback)',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        backgroundColor: AppColors.surfaceHigh,
                        side: BorderSide(
                          color: AppColors.outline.withValues(alpha: 0.8),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  TextButton.icon(
                    onPressed: _disableBiometricLock,
                    icon: const Icon(Icons.lock_reset_rounded, size: 16),
                    label: Text(
                      'Disable Biometric Lock',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
