import "package:shared_preferences/shared_preferences.dart";
import "../../../../core/network/api_client.dart";
import "../../domain/entities/user.dart";
import "../../domain/repositories/auth_repository.dart";
import "../models/user_model.dart";

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _api;

  AuthRepositoryImpl(this._api);

  @override
  Future<({User user, String token})> login(
    String email,
    String password,
  ) async {
    final res = await _api.post("/auth/login", data: {
      "email": email,
      "password": password,
    });
    final token = res.data["token"] as String;
    final user = UserModel.fromJson(res.data["user"] as Map<String, dynamic>);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_token", token);
    return (user: user, token: token);
  }

  @override
  Future<({User user, String token})> register({
    required String email,
    required String password,
    required String name,
    required String rncCedula,
    required String userType,
  }) async {
    final res = await _api.post("/auth/register", data: {
      "email": email,
      "password": password,
      "name": name,
      "rncCedula": rncCedula,
      "userType": userType,
    });
    final token = res.data["token"] as String;
    final user = UserModel.fromJson(res.data["user"] as Map<String, dynamic>);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_token", token);
    return (user: user, token: token);
  }

  @override
  Future<User> me() async {
    final res = await _api.get("/auth/me");
    return UserModel.fromJson(res.data["user"] as Map<String, dynamic>);
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");
  }
}
