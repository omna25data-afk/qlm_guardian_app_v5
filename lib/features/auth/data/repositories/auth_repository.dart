import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

/// Auth repository - coordinates between remote and local data sources
class AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  AuthRepository({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  /// Login user
  Future<UserModel> login(String phoneNumber, String password) async {
    final user = await _remote.login(phoneNumber, password);

    // Save token and cache user
    if (user.token != null) {
      await _local.saveToken(user.token!);
    }
    await _local.cacheUser(user);

    return user;
  }

  /// Logout user
  Future<void> logout() async {
    await _remote.logout();
    await _local.clearAll();
  }

  /// Get current user (from cache or remote)
  Future<UserModel?> getCurrentUser() async {
    // Try remote first if logged in
    if (await _local.isLoggedIn()) {
      final remoteUser = await _remote.getCurrentUser();
      if (remoteUser != null) {
        await _local.cacheUser(remoteUser);
        return remoteUser;
      }
    }

    // Fall back to cached user
    return await _local.getCachedUser();
  }

  /// Check if logged in
  Future<bool> isLoggedIn() => _local.isLoggedIn();

  /// Get stored token
  Future<String?> getToken() => _local.getToken();
}
