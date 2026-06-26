import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "../../../../core/theme/app_theme.dart";
import "../../../../core/network/api_client.dart";
import "../../../../core/models/models.dart";
import "../../../../core/models/budget_repository.dart";

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final _repo = BudgetRepository(ApiClient());
  List<Budget> _budgets = [];
  List<Goal> _goals = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        _repo.list(type: "PROJECT"),
        _repo.listGoals(),
      ]);
      setState(() {
        _budgets = results[0] as List<Budget>;
        _goals = results[1] as List<Goal>;
        _loading = false;
      });
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
                      _buildOverviewCards(),
                      const SizedBox(height: 20),
                      _buildSectionHeader("Proyectos Activos"),
                      const SizedBox(height: 12),
                      if (_budgets.isEmpty)
                        _buildEmptyState("Sin proyectos", "Crea tu primer proyecto de presupuesto")
                      else
                        ..._budgets.map((b) => _buildProjectCard(b)),
                      const SizedBox(height: 20),
                      _buildSectionHeader("Metas de Ahorro"),
                      const SizedBox(height: 12),
                      if (_goals.isEmpty)
                        _buildEmptyState("Sin metas", "Establece metas de ahorro")
                      else
                        ..._goals.map((g) => _buildGoalCard(g)),
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
      title: const Text("Presupuestos",
        style: TextStyle(color: AppTheme.onSurface, fontFamily: "Poppins", fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildOverviewCards() {
    final fmt = NumberFormat.currency(locale: "es_DO", symbol: "RD\$");
    final totalAllocated = _budgets.fold<double>(0, (s, b) => s + b.amount);
    final totalSpent = _budgets.fold<double>(0, (s, b) => s + b.spent);
    final execPct = totalAllocated > 0 ? (totalSpent / totalAllocated * 100).toStringAsFixed(1) : "0";

    return Row(children: [
      _buildMiniCard("Asignado", fmt.format(totalAllocated), AppTheme.secondary),
      const SizedBox(width: 8),
      _buildMiniCard("Gastado", "$execPct%", AppTheme.tertiary),
      const SizedBox(width: 8),
      _buildMiniCard("Proyectos", "${_budgets.length}", AppTheme.primary),
    ]);
  }

  Widget _buildMiniCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: "Inter")),
        ]),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title,
      style: const TextStyle(color: AppTheme.onSurface, fontSize: 16, fontWeight: FontWeight.w600));
  }

  Widget _buildProjectCard(Budget b) {
    final fmt = NumberFormat.currency(locale: "es_DO", symbol: "RD\$");
    final pct = (b.percentage * 100).toStringAsFixed(0);
    final isOverburn = b.percentage > 0.85;
    final color = isOverburn ? AppTheme.error : AppTheme.secondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isOverburn ? AppTheme.error.withValues(alpha: 0.4) : AppTheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Text(b.category, style: const TextStyle(color: AppTheme.onSurface, fontSize: 15, fontWeight: FontWeight.w600))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text("$pct%", style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: b.percentage.clamp(0.0, 1.0),
            backgroundColor: AppTheme.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("${fmt.format(b.spent)} de ${fmt.format(b.amount)}",
            style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12)),
          Text(b.period, style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 11)),
        ]),
      ]),
    );
  }

  Widget _buildGoalCard(Goal g) {
    final fmt = NumberFormat.currency(locale: "es_DO", symbol: "RD\$");
    final pct = (g.percentage * 100).toStringAsFixed(0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: AppTheme.tertiary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.savings_outlined, color: AppTheme.tertiary, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(g.name, style: const TextStyle(color: AppTheme.onSurface, fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text("${fmt.format(g.currentAmount)} de ${fmt.format(g.targetAmount)}",
            style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12)),
        ])),
        Text("$pct%", style: const TextStyle(color: AppTheme.tertiary, fontSize: 14, fontWeight: FontWeight.w700)),
      ]),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(child: Column(children: [
        Icon(Icons.account_balance_wallet_outlined, color: AppTheme.onSurfaceVariant.withValues(alpha: 0.5), size: 40),
        const SizedBox(height: 12),
        Text(title, style: const TextStyle(color: AppTheme.onSurface, fontSize: 14, fontWeight: FontWeight.w500)),
        Text(subtitle, style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12)),
      ])),
    );
  }

  void _showCreateDialog() {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    String period = "MONTHLY";

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Nuevo Proyecto", style: TextStyle(color: AppTheme.onSurface, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Nombre del proyecto"),
              style: const TextStyle(color: AppTheme.onSurface),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountCtrl,
              decoration: const InputDecoration(labelText: "Presupuesto (RD\$)"),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppTheme.onSurface),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: period,
              dropdownColor: AppTheme.surfaceContainerHigh,
              decoration: const InputDecoration(labelText: "Periodo"),
              items: const [
                DropdownMenuItem(value: "MONTHLY", child: Text("Mensual")),
                DropdownMenuItem(value: "ANNUAL", child: Text("Anual")),
              ],
              onChanged: (v) => setModalState(() => period = v ?? "MONTHLY"),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (nameCtrl.text.isEmpty || amountCtrl.text.isEmpty) return;
                  await _repo.create(
                    amount: double.parse(amountCtrl.text),
                    category: nameCtrl.text,
                    period: period,
                    budgetType: "PROJECT",
                  );
                  if (mounted) { Navigator.pop(ctx); _load(); }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryContainer,
                  foregroundColor: AppTheme.onSecondaryContainer,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Crear Proyecto"),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
