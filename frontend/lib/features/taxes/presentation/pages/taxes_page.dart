import "package:flutter/material.dart";

class TaxesPage extends StatelessWidget {
  const TaxesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Impuestos")),
      body: const Center(child: Text("Impuestos - Próximamente")),
    );
  }
}
