class Budget {
  final String id;
  final double amount;
  final double spent;
  final String category;
  final String period;
  final String budgetType;
  final DateTime createdAt;

  const Budget({
    required this.id,
    required this.amount,
    this.spent = 0,
    required this.category,
    required this.period,
    this.budgetType = "PERSONAL",
    required this.createdAt,
  });

  double get percentage => amount > 0 ? spent / amount : 0;
  double get remaining => amount - spent;

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json["id"] as String,
      amount: (json["amount"] as num).toDouble(),
      spent: (json["spent"] as num? ?? 0).toDouble(),
      category: json["category"] as String,
      period: json["period"] as String,
      budgetType: json["budgetType"] as String? ?? "PERSONAL",
      createdAt: DateTime.parse(json["createdAt"] as String),
    );
  }
}

class Transaction {
  final String id;
  final double amount;
  final String type;
  final String category;
  final String? description;
  final String? ncf;
  final DateTime date;

  const Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    this.description,
    this.ncf,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json["id"] as String,
      amount: (json["amount"] as num).toDouble(),
      type: json["type"] as String,
      category: json["category"] as String,
      description: json["description"] as String?,
      ncf: json["ncf"] as String?,
      date: DateTime.parse(json["date"] as String),
    );
  }
}

class Goal {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final String icon;
  final String status;
  final DateTime createdAt;

  const Goal({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0,
    this.icon = "savings",
    this.status = "ACTIVE",
    required this.createdAt,
  });

  double get percentage => targetAmount > 0 ? currentAmount / targetAmount : 0;

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json["id"] as String,
      name: json["name"] as String,
      targetAmount: (json["targetAmount"] as num).toDouble(),
      currentAmount: (json["currentAmount"] as num? ?? 0).toDouble(),
      icon: json["icon"] as String? ?? "savings",
      status: json["status"] as String? ?? "ACTIVE",
      createdAt: DateTime.parse(json["createdAt"] as String),
    );
  }
}

class DashboardData {
  final double balance;
  final double monthlyIncome;
  final double monthlyExpenses;
  final double netBalance;
  final List<Transaction> recentTransactions;
  final int budgetCount;
  final int goalCount;

  const DashboardData({
    required this.balance,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.netBalance,
    required this.recentTransactions,
    required this.budgetCount,
    required this.goalCount,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      balance: (json["balance"] as num? ?? 0).toDouble(),
      monthlyIncome: (json["monthlyIncome"] as num? ?? 0).toDouble(),
      monthlyExpenses: (json["monthlyExpenses"] as num? ?? 0).toDouble(),
      netBalance: (json["netBalance"] as num? ?? 0).toDouble(),
      recentTransactions: (json["recentTransactions"] as List? ?? [])
          .map((t) => Transaction.fromJson(t as Map<String, dynamic>))
          .toList(),
      budgetCount: json["budgetCount"] as int? ?? 0,
      goalCount: json["goalCount"] as int? ?? 0,
    );
  }
}
