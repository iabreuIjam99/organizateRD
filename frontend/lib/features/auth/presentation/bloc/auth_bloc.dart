import "package:flutter_bloc/flutter_bloc.dart";
import "package:shared_preferences/shared_preferences.dart";
import "auth_event.dart";
import "auth_state.dart";
import "../../../../core/network/api_client.dart";
import "../../data/repositories/auth_repository_impl.dart";
import "../../domain/repositories/auth_repository.dart";

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc()
      : _repository = AuthRepositoryImpl(ApiClient()),
        super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<CheckSession>(_onCheckSession);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _repository.login(event.email, event.password);
      emit(Authenticated(user: result.user, token: result.token));
    } catch (e) {
      emit(AuthError(message: _mapError(e)));
    }
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _repository.register(
        email: event.email,
        password: event.password,
        name: event.name,
        rncCedula: event.rncCedula,
        userType: event.userType,
      );
      emit(Authenticated(user: result.user, token: result.token));
    } catch (e) {
      emit(AuthError(message: _mapError(e)));
    }
  }

  Future<void> _onCheckSession(
    CheckSession event,
    Emitter<AuthState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");
    if (token == null) {
      emit(Unauthenticated());
      return;
    }
    try {
      final user = await _repository.me();
      emit(Authenticated(user: user, token: token));
    } catch (_) {
      await _repository.logout();
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _repository.logout();
    emit(Unauthenticated());
  }

  String _mapError(Object e) {
    final msg = e.toString();
    if (msg.contains("INVALID_CREDENTIALS")) return "Credenciales inválidas";
    if (msg.contains("DUPLICATE_EMAIL")) return "El correo ya está registrado";
    if (msg.contains("SocketException")) return "Error de conexión";
    return "Ha ocurrido un error. Intenta de nuevo.";
  }
}
