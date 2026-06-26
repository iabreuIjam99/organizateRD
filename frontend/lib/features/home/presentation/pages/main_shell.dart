import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "../../../../core/theme/app_theme.dart";

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getIndex(context),
        onDestinationSelected: (i) => _onTap(context, i),
        backgroundColor: AppTheme.surfaceContainerLow,
        indicatorColor: AppTheme.secondaryContainer.withValues(alpha: 0.2),
        height: 70,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: AppTheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.home, color: AppTheme.secondary),
            label: "Inicio",
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined, color: AppTheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.account_balance_wallet, color: AppTheme.secondary),
            label: "Presupuestos",
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined, color: AppTheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.receipt_long, color: AppTheme.secondary),
            label: "Impuestos",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: AppTheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.person, color: AppTheme.secondary),
            label: "Perfil",
          ),
        ],
      ),
    );
  }

  int _getIndex(BuildContext context) {
    final path = GoRouterState.of(context).matchedLocation;
    if (path.startsWith("/budgets")) return 1;
    if (path.startsWith("/taxes")) return 2;
    if (path.startsWith("/profile")) return 3;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0: context.go("/home");
      case 1: context.go("/budgets");
      case 2: context.go("/taxes");
      case 3: context.go("/profile");
    }
  }
}
