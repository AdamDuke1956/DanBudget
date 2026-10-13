import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'data/providers/database_providers.dart';
import 'presentation/home/home_screen.dart';
import 'presentation/expenses/expenses_screen.dart';
import 'presentation/onboarding/onboarding_screen.dart';
import 'presentation/plan/plan_screen.dart';
import 'presentation/commitments/commitments_screen.dart';
import 'presentation/more/more_screen.dart';
import 'presentation/more/widgets/biometric_guard.dart';

class DanBudgetApp extends ConsumerWidget {
  const DanBudgetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    AppColors.current = themeMode.isDark ? AppPalette.dark : AppPalette.light;

    return MaterialApp(
      title: 'DanBudget',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode.isDark ? ThemeMode.dark : ThemeMode.light,
      home: const AppRoot(),
    );
  }
}

/// Launch gate: shows the onboarding wizard until the profile is onboarded,
/// then the (optionally biometric-locked) main app shell.
class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileStreamProvider);

    final Widget screen = profileAsync.when(
      loading: () => const _SplashScreen(key: ValueKey('splash')),
      error: (err, _) => Scaffold(
        key: const ValueKey('error'),
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            'Error: $err',
            style: TextStyle(color: AppColors.danger),
          ),
        ),
      ),
      data: (profile) => profile.isOnboarded
          ? const BiometricGuard(key: ValueKey('app'), child: AppShell())
          : const OnboardingScreen(key: ValueKey('onboarding')),
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: screen,
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

/// Bottom-navigation shell.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _index = 0;

  List<Widget> _buildTabs(AppThemeMode themeMode) => [
    HomeScreen(
      key: ValueKey('home_${themeMode.name}'),
      onNavigateToTab: (i) => setState(() => _index = i),
    ),
    ExpensesScreen(key: ValueKey('expenses_${themeMode.name}')),
    PlanScreen(key: ValueKey('plan_${themeMode.name}')),
    CommitmentsScreen(key: ValueKey('commitments_${themeMode.name}')),
    MoreScreen(key: ValueKey('more_${themeMode.name}')),
  ];

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _buildTabs(themeMode),
      ),
      bottomNavigationBar: MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.0,
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.primary.withValues(alpha: 0.18),
          elevation: 4,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long_rounded),
              label: 'Expenses',
            ),
            NavigationDestination(
              icon: Icon(Icons.pie_chart_outline_rounded),
              selectedIcon: Icon(Icons.pie_chart_rounded),
              label: 'Plan',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_outlined),
              selectedIcon: Icon(Icons.account_balance_rounded),
              label: 'Commitments',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view_rounded),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
