import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "../../../../core/theme/app_theme.dart";
import "../../../../core/network/api_client.dart";
import "../../../../core/models/models.dart";
import "../../../../core/models/transaction_repository.dart";

class TaxesPage extends StatefulWidget {
  const TaxesPage({super.key});

  @override
  State<TaxesPage> createState() => _TaxesPageState();
}

class _TaxesPageState extends State<TaxesPage> {
  final _repo = TransactionRepository(ApiClient());
  List<Transaction> _transactions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final txs = await _repo.list(type: "EXPENSE");
      setState(() { _transactions = txs; _loading = false; });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.secondary))
          : RefreshIndicator(
              onRefresh: _load,
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList.list(children: [
                      _buildExecutiveSummary(),
                      const SizedBox(height: 20),
                      _buildSectionHeader("Historial NCF"),
                      const SizedBox(height: 12),
                      if (_transactions.isEmpty)
                        _buildEmptyState()
                      else
                        _buildNCFTable(),
                    ]),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.secondaryContainer,
        foregroundColor: AppTheme.onSecondaryContainer,
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppTheme.surfaceContainerLow,
      title: const Text("Impuestos & NCF",
        style: TextStyle(color: AppTheme.onSurface, fontFamily: "Poppins", fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildExecutiveSummary() {
    final fmt = NumberFormat.currency(locale: "es_DO", symbol: "RD\$");
    final totalExpenses = _transactions.fold<double>(0, (s, t) => s + t.amount);
    final withNCF = _transactions.where((t) => t.ncf != null).length;
    final pending = _transactions.where((t) => t.ncf == null).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Resumen Ejecutivo", style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 13)),
        const SizedBox(height: 16),
        Row(children: [
          _buildSummaryItem("Total Gastos", fmt.format(totalExpenses), AppTheme.error),
          const SizedBox(width: 12),
          _buildSummaryItem("Con NCF", "$withNCF", AppTheme.secondary),
          const SizedBox(width: 12),
          _buildSummaryItem("Pendientes", "$pending", AppTheme.tertiary),
        ]),
      ]),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: "Inter")),
      ]),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title,
      style: const TextStyle(color: AppTheme.onSurface, fontSize: 16, fontWeight: FontWeight.w600));
  }

  Widget _buildNCFTable() {
    final fmt = NumberFormat.currency(locale: "es_DO", symbol: "RD\$");
    final fmtDate = DateFormat("dd/MM/yyyy");

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerHigh,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: const Row(children: [
            Expanded(flex: 2, child: Text("NCF", style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w600))),
            Expanded(flex: 2, child: Text("Fecha", style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w600))),
            Expanded(flex: 2, child: Text("Monto", style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w600))),
            Expanded(flex: 1, child: Text("Estado", style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w600))),
          ]),
        ),
        // Rows
        ..._transactions.take(20).map((tx) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppTheme.outlineVariant, width: 0.3)),
          ),
          child: Row(children: [
            Expanded(flex: 2, child: Text(tx.ncf ?? "—",
              style: const TextStyle(color: AppTheme.onSurface, fontSize: 13))),
            Expanded(flex: 2, child: Text(fmtDate.format(tx.date),
              style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12))),
            Expanded(flex: 2, child: Text(fmt.format(tx.amount),
              style: const TextStyle(color: AppTheme.onSurface, fontSize: 13, fontWeight: FontWeight.w500))),
            Expanded(flex: 1, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: tx.ncf != null
                    ? AppTheme.secondary.withValues(alpha: 0.15)
                    : AppTheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(tx.ncf != null ? "OK" : "Pend.",
                style: TextStyle(
                  color: tx.ncf != null ? AppTheme.secondary : AppTheme.onSurfaceVariant,
                  fontSize: 11, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
            )),
          ]),
        )),
      ]),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(child: Column(children: [
        Icon(Icons.receipt_long_outlined, color: AppTheme.onSurfaceVariant, size: 40),
        SizedBox(height: 12),
        Text("Sin transacciones NCF", style: TextStyle(color: AppTheme.onSurface, fontSize: 14)),
        Text("Registra gastos para generar comprobantes NCF", style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12)),
      ])),
    );
  }

  void _showCreateDialog() {
    final descCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final ncfCtrl = TextEditingController();
    String category = "Operacional";

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceContainer,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Nuevo Gasto con NCF", style: TextStyle(color: AppTheme.onSurface, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Descripción"),
              style: const TextStyle(color: AppTheme.onSurface),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountCtrl,
              decoration: const InputDecoration(labelText: "Monto (RD\$)"),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppTheme.onSurface),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ncfCtrl,
              decoration: const InputDecoration(labelText: "NCF (opcional)"),
              style: const TextStyle(color: AppTheme.onSurface),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: category,
              dropdownColor: AppTheme.surfaceContainerHigh,
              decoration: const InputDecoration(labelText: "Categoría"),
              items: const [
                DropdownMenuItem(value: "Operacional", child: Text("Operacional")),
                DropdownMenuItem(value: "Administrativo", child: Text("Administrativo")),
                DropdownMenuItem(value: "Marketing", child: Text("Marketing")),
                DropdownMenuItem(value: "Servicios", child: Text("Servicios")),
              ],
              onChanged: (v) => setModalState(() => category = v ?? "Operacional"),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (descCtrl.text.isEmpty || amountCtrl.text.isEmpty) return;
                  await _repo.create(
                    amount: double.parse(amountCtrl.text),
                    type: "EXPENSE",
                    category: category,
                    description: descCtrl.text,
                    ncf: ncfCtrl.text.isNotEmpty ? ncfCtrl.text : null,
                  );
                  if (mounted) { Navigator.pop(ctx); _load(); }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryContainer,
                  foregroundColor: AppTheme.onSecondaryContainer,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Registrar Gasto"),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
