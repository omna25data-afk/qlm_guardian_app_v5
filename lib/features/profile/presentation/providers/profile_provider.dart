import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final apiClient = getIt<ApiClient>();
  return ProfileRepository(apiClient);
});

final profileProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<Map<String, dynamic>>>((
      ref,
    ) {
      final repository = ref.watch(profileRepositoryProvider);
      return ProfileNotifier(repository);
    });

class ProfileNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getProfile();
      state = AsyncValue.data(data);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      final updated = await _repository.updateProfile(data);
      state = AsyncValue.data(updated);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
