import "package:flutter/material.dart";
import "app.dart";
import "features/auth/presentation/bloc/auth_bloc.dart";
import "features/auth/presentation/bloc/auth_event.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final authBloc = AuthBloc();
  authBloc.add(CheckSession());
  runApp(OrganizateRDApp(authBloc: authBloc));
}
