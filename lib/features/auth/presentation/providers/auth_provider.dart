import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

/// Auth state
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? error;

  const AuthState({this.status = AuthStatus.initial, this.user, this.error});

  AuthState copyWith({AuthStatus? status, UserModel? user, String? error}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
}

/// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState());

  /// Initialize - check if already logged in
  Future<void> init() async {
    final isLoggedIn = await _repository.isLoggedIn();
    if (isLoggedIn) {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        state = AuthState(status: AuthStatus.authenticated, user: user);
        return;
      }
    }
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Login
  Future<bool> login(String phoneNumber, String password) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    try {
      final user = await _repository.login(phoneNumber, password);
      state = AuthState(status: AuthStatus.authenticated, user: user);
      return true;
    } catch (e) {
      state = AuthState(status: AuthStatus.error, error: e.toString());
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = getIt<ApiClient>();
  return AuthRepository(
    remote: AuthRemoteDataSource(apiClient),
    local: AuthLocalDataSource(),
  );
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
