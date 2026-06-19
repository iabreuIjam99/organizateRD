import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../../../core/theme/app_theme.dart";
import "../../../auth/presentation/bloc/auth_bloc.dart";
import "../../../auth/presentation/bloc/auth_event.dart";
import "../../../auth/presentation/bloc/auth_state.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final userName = authState is Authenticated ? authState.user.name ?? "" : "";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bienvenido, $userName",
          style: const TextStyle(color: AppTheme.onSurface),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.onSurfaceVariant),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
        backgroundColor: AppTheme.surfaceContainer,
      ),
      body: Center(
        child: Text(
          "Dashboard - Próximamente",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
