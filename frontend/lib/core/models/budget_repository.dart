import "../../../core/network/api_client.dart";
import "../../../core/models/models.dart";

class BudgetRepository {
  final ApiClient _api;
  BudgetRepository(this._api);

  Future<List<Budget>> list({String? type}) async {
    final res = await _api.get("/budgets", queryParameters: type != null ? {"type": type} : null);
    return (res.data["budgets"] as List).map((b) => Budget.fromJson(b)).toList();
  }

  Future<Budget> create({required double amount, required String category, required String period, String? budgetType}) async {
    final res = await _api.post("/budgets", data: {
      "amount": amount, "category": category, "period": period,
      if (budgetType != null) "budgetType": budgetType,
    });
    return Budget.fromJson(res.data["budget"]);
  }

  Future<Budget> update(String id, Map<String, dynamic> data) async {
    final res = await _api.put("/budgets/$id", data: data);
    return Budget.fromJson(res.data["budget"]);
  }

  Future<void> delete(String id) async {
    await _api.delete("/budgets/$id");
  }

  Future<List<Goal>> listGoals() async {
    final res = await _api.get("/budgets/goals");
    return (res.data["goals"] as List).map((g) => Goal.fromJson(g)).toList();
  }

  Future<Goal> createGoal({required String name, required double targetAmount, String? icon}) async {
    final res = await _api.post("/budgets/goals", data: {
      "name": name, "targetAmount": targetAmount,
      if (icon != null) "icon": icon,
    });
    return Goal.fromJson(res.data["goal"]);
  }

  Future<Goal> updateGoal(String id, Map<String, dynamic> data) async {
    final res = await _api.put("/budgets/goals/$id", data: data);
    return Goal.fromJson(res.data["goal"]);
  }

  Future<void> deleteGoal(String id) async {
    await _api.delete("/budgets/goals/$id");
  }
}
