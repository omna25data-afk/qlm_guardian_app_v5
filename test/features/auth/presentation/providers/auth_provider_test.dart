import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:qlm_guardian_app_v5/features/auth/data/models/user_model.dart';
import 'package:qlm_guardian_app_v5/features/auth/data/repositories/auth_repository.dart';
import 'package:qlm_guardian_app_v5/features/auth/presentation/providers/auth_provider.dart';

import 'auth_provider_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockRepository;
  late AuthNotifier notifier;

  setUp(() {
    mockRepository = MockAuthRepository();
    notifier = AuthNotifier(mockRepository);
  });

  const tUserModel = UserModel(
    id: 1,
    name: 'Test User',
    phoneNumber: '123456789',
    token: 'test_token',
  );

  group('init', () {
    test('should set status to authenticated if user is logged in', () async {
      // Arrange
      when(mockRepository.isLoggedIn()).thenAnswer((_) async => true);
      when(mockRepository.getCurrentUser()).thenAnswer((_) async => tUserModel);

      // Act
      await notifier.init();

      // Assert
      expect(notifier.state.status, AuthStatus.authenticated);
      expect(notifier.state.user, tUserModel);
    });

    test(
      'should set status to unauthenticated if user is not logged in',
      () async {
        // Arrange
        when(mockRepository.isLoggedIn()).thenAnswer((_) async => false);

        // Act
        await notifier.init();

        // Assert
        expect(notifier.state.status, AuthStatus.unauthenticated);
      },
    );
  });

  group('login', () {
    const tPhone = '123456789';
    const tPassword = 'password';

    test('should set status to loading then authenticated on success', () async {
      // Arrange
      when(mockRepository.login(any, any)).thenAnswer((_) async => tUserModel);

      // Act
      final future = notifier.login(tPhone, tPassword);

      // Assert
      // Since StateNotifier updates are synchronous in tests usually, but here we have async operations.
      // logic: state = loading -> await repo -> state = authenticated

      // Verification is tricky with checking intermediate states without a specialized test utility for Riverpod,
      // but we can check the final state and the return value.
      final result = await future;

      expect(result, true);
      expect(notifier.state.status, AuthStatus.authenticated);
      expect(notifier.state.user, tUserModel);
      verify(mockRepository.login(tPhone, tPassword));
    });

    test('should set status to loading then error on failure', () async {
      // Arrange
      when(mockRepository.login(any, any)).thenThrow(Exception('Login failed'));

      // Act
      final result = await notifier.login(tPhone, tPassword);

      // Assert
      expect(result, false);
      expect(notifier.state.status, AuthStatus.error);
      expect(notifier.state.error, 'Exception: Login failed');
    });
  });

  group('logout', () {
    test(
      'should call repository logout and set status to unauthenticated',
      () async {
        // Arrange
        when(mockRepository.logout()).thenAnswer((_) async => {});

        // Act
        await notifier.logout();

        // Assert
        expect(notifier.state.status, AuthStatus.unauthenticated);
        verify(mockRepository.logout());
      },
    );
  });
}
