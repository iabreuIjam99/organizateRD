import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "../features/auth/presentation/bloc/auth_bloc.dart";
import "../features/auth/presentation/bloc/auth_state.dart";
import "../features/auth/presentation/pages/login_page.dart";
import "../features/auth/presentation/pages/register_page.dart";
import "../features/home/presentation/pages/main_shell.dart";
import "../features/dashboard/presentation/pages/dashboard_page.dart";
import "../features/budget/presentation/pages/budget_page.dart";
import "../features/taxes/presentation/pages/taxes_page.dart";
import "../features/profile/presentation/pages/profile_page.dart";

class AppRouter {
  final AuthBloc authBloc;

  AppRouter(this.authBloc);

  late final GoRouter router = GoRouter(
    refreshListenable: _AuthRefreshNotifier(authBloc),
    initialLocation: "/",
    redirect: (context, state) {
      final authState = authBloc.state;
      final isLoggedIn = authState is Authenticated;
      final isAuthRoute = state.matchedLocation == "/login" ||
          state.matchedLocation == "/register";

      if (!isLoggedIn && !isAuthRoute) return "/login";
      if (isLoggedIn && isAuthRoute) return "/home";
      return null;
    },
    routes: [
      GoRoute(
        path: "/login",
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: "/register",
        builder: (_, __) => const RegisterPage(),
      ),
      ShellRoute(
        builder: (_, __, child) => MainShell(child: child),
        routes: [
          GoRoute(path: "/home", builder: (_, __) => const DashboardPage()),
          GoRoute(path: "/budgets", builder: (_, __) => const BudgetPage()),
          GoRoute(path: "/taxes", builder: (_, __) => const TaxesPage()),
          GoRoute(path: "/profile", builder: (_, __) => const ProfilePage()),
        ],
      ),
    ],
    errorBuilder: (_, __) => const Scaffold(
      body: Center(child: Text("Página no encontrada")),
    ),
  );
}

class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(AuthBloc authBloc) {
    authBloc.stream.listen((_) => notifyListeners());
  }
}
