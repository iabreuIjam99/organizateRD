import "../entities/user.dart";

abstract class AuthRepository {
  Future<({User user, String token})> login(String email, String password);
  Future<({User user, String token})> register({
    required String email,
    required String password,
    required String name,
    required String rncCedula,
    required String userType,
  });
  Future<User> me();
  Future<void> logout();
}
