import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "../features/auth/presentation/bloc/auth_bloc.dart";
import "../features/auth/presentation/bloc/auth_state.dart";
import "../features/auth/presentation/pages/login_page.dart";
import "../features/auth/presentation/pages/register_page.dart";
import "../features/home/presentation/pages/home_page.dart";

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
      GoRoute(
        path: "/home",
        builder: (_, __) => const HomePage(),
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
