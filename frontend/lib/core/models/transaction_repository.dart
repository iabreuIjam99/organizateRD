import "../../../core/network/api_client.dart";
import "../../../core/models/models.dart";

class TransactionRepository {
  final ApiClient _api;
  TransactionRepository(this._api);

  Future<List<Transaction>> list({String? type, String? category}) async {
    final params = <String, dynamic>{};
    if (type != null) params["type"] = type;
    if (category != null) params["category"] = category;
    final res = await _api.get("/transactions", queryParameters: params.isNotEmpty ? params : null);
    return (res.data["transactions"] as List).map((t) => Transaction.fromJson(t)).toList();
  }

  Future<Transaction> create({
    required double amount,
    required String type,
    required String category,
    String? description,
    String? ncf,
  }) async {
    final res = await _api.post("/transactions", data: {
      "amount": amount, "type": type, "category": category,
      if (description != null) "description": description,
      if (ncf != null) "ncf": ncf,
    });
    return Transaction.fromJson(res.data["transaction"]);
  }

  Future<Transaction> update(String id, Map<String, dynamic> data) async {
    final res = await _api.put("/transactions/$id", data: data);
    return Transaction.fromJson(res.data["transaction"]);
  }

  Future<void> delete(String id) async {
    await _api.delete("/transactions/$id");
  }

  Future<DashboardData> dashboard() async {
    final res = await _api.get("/dashboard");
    return DashboardData.fromJson(res.data);
  }
}
