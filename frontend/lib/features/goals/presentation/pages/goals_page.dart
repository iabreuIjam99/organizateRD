import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "../../../../core/theme/app_theme.dart";
import "../../../../core/network/api_client.dart";
import "../../../../core/models/models.dart";
import "../../../../core/models/budget_repository.dart";

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  final _repo = BudgetRepository(ApiClient());
  List<Budget> _personalBudgets = [];
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
        _repo.list(type: "PERSONAL"),
        _repo.listGoals(),
      ]);
      setState(() {
        _personalBudgets = results[0] as List<Budget>;
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
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: AppTheme.surfaceContainerLow,
                    title: const Text("Metas y Presupuestos",
                      style: TextStyle(color: AppTheme.onSurface, fontFamily: "Poppins", fontWeight: FontWeight.w600)),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList.list(children: [
                      // Motivational Banner
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.secondaryContainer.withValues(alpha: 0.15), AppTheme.surfaceContainer],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.secondaryContainer.withValues(alpha: 0.3)),
                        ),
                        child: const Row(children: [
                          Icon(Icons.star, color: AppTheme.secondary, size: 28),
                          SizedBox(width: 12),
                          Expanded(child: Text("¡Vas por buen camino!",
                            style: TextStyle(color: AppTheme.onSurface, fontSize: 16, fontWeight: FontWeight.w600))),
                        ]),
                      ),
                      const SizedBox(height: 20),

                      // Personal Budgets
                      const Text("Presupuestos Activos",
                        style: TextStyle(color: AppTheme.onSurface, fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      if (_personalBudgets.isEmpty)
                        _buildEmptyCard("Sin presupuestos", "Crea presupuestos personales")
                      else
                        ..._personalBudgets.map((b) => _buildBudgetCard(b)),
                      const SizedBox(height: 20),

                      // Goals
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text("Metas de Ahorro",
                          style: TextStyle(color: AppTheme.onSurface, fontSize: 16, fontWeight: FontWeight.w600)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: AppTheme.secondary, size: 22),
                          onPressed: _showCreateGoalDialog,
                        ),
                      ]),
                      const SizedBox(height: 12),
                      if (_goals.isEmpty)
                        _buildEmptyCard("Sin metas", "Establece metas de ahorro")
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
        onPressed: _showCreateBudgetDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBudgetCard(Budget b) {
    final fmt = NumberFormat.currency(locale: "es_DO", symbol: "RD\$");
    final pct = (b.percentage * 100).toStringAsFixed(0);
    Color color;
    String status;
    if (b.percentage < 0.5) { color = AppTheme.secondary; status = "Saludable"; }
    else if (b.percentage < 0.8) { color = AppTheme.tertiary; status = "Precaución"; }
    else { color = AppTheme.error; status = "Alerta"; }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Text(b.category,
            style: const TextStyle(color: AppTheme.onSurface, fontSize: 15, fontWeight: FontWeight.w600))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
            child: Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
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
        Text("${fmt.format(b.spent)} de ${fmt.format(b.amount)}  ·  $pct%",
          style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12)),
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
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
            Text(g.name, style: const TextStyle(color: AppTheme.onSurface, fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text("${fmt.format(g.currentAmount)} de ${fmt.format(g.targetAmount)}",
              style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 13)),
          ])),
          Text("$pct%", style: const TextStyle(color: AppTheme.tertiary, fontSize: 16, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: g.percentage.clamp(0.0, 1.0),
            backgroundColor: AppTheme.surfaceContainerHigh,
            valueColor: const AlwaysStoppedAnimation(AppTheme.tertiary),
            minHeight: 6,
          ),
        ),
      ]),
    );
  }

  Widget _buildEmptyCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(child: Column(children: [
        Icon(Icons.savings_outlined, color: AppTheme.onSurfaceVariant.withValues(alpha: 0.4), size: 36),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(color: AppTheme.onSurface, fontSize: 14)),
        Text(subtitle, style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12)),
      ])),
    );
  }

  void _showCreateBudgetDialog() {
    final catCtrl = TextEditingController();
    final amtCtrl = TextEditingController();
    String period = "MONTHLY";

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceContainer,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Nuevo Presupuesto", style: TextStyle(color: AppTheme.onSurface, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            TextField(controller: catCtrl, decoration: const InputDecoration(labelText: "Categoría"),
              style: const TextStyle(color: AppTheme.onSurface)),
            const SizedBox(height: 12),
            TextField(controller: amtCtrl, decoration: const InputDecoration(labelText: "Límite (RD\$)"),
              keyboardType: TextInputType.number, style: const TextStyle(color: AppTheme.onSurface)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: period, dropdownColor: AppTheme.surfaceContainerHigh,
              decoration: const InputDecoration(labelText: "Periodo"),
              items: const [
                DropdownMenuItem(value: "MONTHLY", child: Text("Mensual")),
                DropdownMenuItem(value: "ANNUAL", child: Text("Anual")),
              ],
              onChanged: (v) => setModalState(() => period = v ?? "MONTHLY"),
            ),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () async {
                if (catCtrl.text.isEmpty || amtCtrl.text.isEmpty) return;
                await _repo.create(
                  amount: double.parse(amtCtrl.text), category: catCtrl.text,
                  period: period, budgetType: "PERSONAL",
                );
                if (mounted) { Navigator.pop(ctx); _load(); }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryContainer,
                foregroundColor: AppTheme.onSecondaryContainer,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Crear Presupuesto"),
            )),
          ]),
        ),
      ),
    );
  }

  void _showCreateGoalDialog() {
    final nameCtrl = TextEditingController();
    final amtCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceContainer,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Nueva Meta", style: TextStyle(color: AppTheme.onSurface, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Nombre de la meta"),
            style: const TextStyle(color: AppTheme.onSurface)),
          const SizedBox(height: 12),
          TextField(controller: amtCtrl, decoration: const InputDecoration(labelText: "Monto objetivo (RD\$)"),
            keyboardType: TextInputType.number, style: const TextStyle(color: AppTheme.onSurface)),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isEmpty || amtCtrl.text.isEmpty) return;
              await _repo.createGoal(name: nameCtrl.text, targetAmount: double.parse(amtCtrl.text));
              if (mounted) { Navigator.pop(ctx); _load(); }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.tertiary,
              foregroundColor: AppTheme.onTertiary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Crear Meta"),
          )),
        ]),
      ),
    );
  }
}
