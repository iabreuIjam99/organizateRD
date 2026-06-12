import "package:flutter/material.dart";
import "core/theme/theme.dart";

void main() {
  runApp(const OrganizateRDApp());
}

class OrganizateRDApp extends StatelessWidget {
  const OrganizateRDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "OrganizateRD",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OrganizateRD"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_balance_wallet,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                "Bienvenido a OrganizateRD",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "Gestiona tus presupuestos personales y de negocio",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.login),
                label: const Text("Iniciar Sesión"),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.person_add),
                label: const Text("Crear Cuenta"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
