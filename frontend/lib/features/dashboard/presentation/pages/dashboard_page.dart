import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "../../../../core/theme/app_theme.dart";
import "../../../../core/network/api_client.dart";
import "../../../../core/models/models.dart";
import "../../../../core/models/transaction_repository.dart";

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _repo = TransactionRepository(ApiClient());
  DashboardData? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _repo.dashboard();
      setState(() { _data = data; _loading = false; });
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
          : _data == null
              ? const Center(child: Text("Error al cargar datos", style: TextStyle(color: AppTheme.onSurfaceVariant)))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: CustomScrollView(
                    slivers: [
                      _buildAppBar(),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList.list(children: [
                          _buildBalanceCard(),
                          const SizedBox(height: 16),
                          _buildBentoGrid(),
                          const SizedBox(height: 16),
                          _buildRecentTransactions(),
                        ]),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppTheme.surfaceContainerLow,
      title: Row(children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppTheme.primaryContainer,
          child: const Icon(Icons.person, color: AppTheme.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          "OrganizateRD",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontFamily: "Poppins",
            color: AppTheme.onSurface,
          ),
        ),
      ]),
      actions: [
        Stack(children: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppTheme.onSurfaceVariant),
            onPressed: () {},
          ),
          Positioned(
            right: 10, top: 10,
            child: Container(width: 8, height: 8,
              decoration: const BoxDecoration(color: AppTheme.error, shape: BoxShape.circle)),
          ),
        ]),
      ],
    );
  }

  Widget _buildBalanceCard() {
    final fmt = NumberFormat.currency(locale: "es_DO", symbol: "RD\$");
    final income = _data!.monthlyIncome;
    final expenses = _data!.monthlyExpenses;
    final balance = _data!.netBalance;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Balance del Mes", style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14)),
        const SizedBox(height: 8),
        Text(
          fmt.format(balance),
          style: const TextStyle(
            fontFamily: "Inter", fontSize: 32, fontWeight: FontWeight.w700,
            color: AppTheme.onSurface, letterSpacing: -0.01,
          ),
        ),
        const SizedBox(height: 16),
        Row(children: [
          _buildStatChip(Icons.arrow_upward, "Ingresos", fmt.format(income), AppTheme.secondary),
          const SizedBox(width: 12),
          _buildStatChip(Icons.arrow_downward, "Gastos", fmt.format(expenses), AppTheme.error),
        ]),
      ]),
    );
  }

  Widget _buildStatChip(IconData icon, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 11)),
              Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildBentoGrid() {
    final fmt = NumberFormat.currency(locale: "es_DO", symbol: "RD\$");
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _buildBentoCard("Gastos Mensuales", fmt.format(_data!.monthlyExpenses), AppTheme.error, Icons.trending_down),
        _buildBentoCard("Ingresos", fmt.format(_data!.monthlyIncome), AppTheme.secondary, Icons.trending_up),
        _buildBentoCard("Presupuestos", "${_data!.budgetCount} activos", AppTheme.tertiary, Icons.account_balance_wallet),
        _buildBentoCard("Metas", "${_data!.goalCount} en curso", AppTheme.primary, Icons.flag),
      ],
    );
  }

  Widget _buildBentoCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title, style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12)),
          Icon(icon, color: color, size: 18),
        ]),
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: "Inter")),
      ]),
    );
  }

  Widget _buildRecentTransactions() {
    final fmt = NumberFormat.currency(locale: "es_DO", symbol: "RD\$");
    final txs = _data!.recentTransactions;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("Transacciones Recientes",
        style: TextStyle(color: AppTheme.onSurface, fontSize: 16, fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      if (txs.isEmpty)
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(child: Text("Sin transacciones aún",
            style: TextStyle(color: AppTheme.onSurfaceVariant))),
        )
      else
        ...txs.map((tx) => _buildTransactionTile(tx, fmt)),
    ]);
  }

  Widget _buildTransactionTile(Transaction tx, NumberFormat fmt) {
    final isExpense = tx.type == "EXPENSE";
    final color = isExpense ? AppTheme.error : AppTheme.secondary;
    final prefix = isExpense ? "-" : "+";

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(isExpense ? Icons.arrow_downward : Icons.arrow_upward, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tx.description ?? tx.category,
            style: const TextStyle(color: AppTheme.onSurface, fontSize: 14, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis),
          Text(tx.category, style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text("$prefix${fmt.format(tx.amount)}",
            style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600)),
          if (tx.ncf != null)
            Text("NCF: ${tx.ncf}", style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 10)),
        ]),
      ]),
    );
  }
}
