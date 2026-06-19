import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "core/theme/app_theme.dart";
import "features/auth/presentation/bloc/auth_bloc.dart";
import "router/app_router.dart";

class OrganizateRDApp extends StatelessWidget {
  final AuthBloc authBloc;

  const OrganizateRDApp({super.key, required this.authBloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: authBloc,
      child: MaterialApp.router(
        title: "OrganizateRD",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter(authBloc).router,
      ),
    );
  }
}
