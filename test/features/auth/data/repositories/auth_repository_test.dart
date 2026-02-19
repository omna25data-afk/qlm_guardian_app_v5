import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:qlm_guardian_app_v5/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:qlm_guardian_app_v5/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:qlm_guardian_app_v5/features/auth/data/models/user_model.dart';
import 'package:qlm_guardian_app_v5/features/auth/data/repositories/auth_repository.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource, AuthLocalDataSource])
void main() {
  late AuthRepository repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    repository = AuthRepository(
      remote: mockRemoteDataSource,
      local: mockLocalDataSource,
    );
  });

  const tUserModel = UserModel(
    id: 1,
    name: 'Test User',
    phoneNumber: '123456789',
    token: 'test_token',
  );

  group('login', () {
    const tPhone = '123456789';
    const tPassword = 'password';

    test('should return user when login is successful', () async {
      // Arrange
      when(
        mockRemoteDataSource.login(tPhone, tPassword),
      ).thenAnswer((_) async => tUserModel);
      when(mockLocalDataSource.saveToken(any)).thenAnswer((_) async => {});
      when(mockLocalDataSource.cacheUser(any)).thenAnswer((_) async => {});

      // Act
      final result = await repository.login(tPhone, tPassword);

      // Assert
      expect(result, tUserModel);
      verify(mockRemoteDataSource.login(tPhone, tPassword));
      verify(mockLocalDataSource.saveToken(tUserModel.token!));
      verify(mockLocalDataSource.cacheUser(tUserModel));
    });

    test('should throw exception when remote login fails', () async {
      // Arrange
      when(
        mockRemoteDataSource.login(tPhone, tPassword),
      ).thenThrow(Exception('Login failed'));

      // Act
      final call = repository.login;

      // Assert
      expect(() => call(tPhone, tPassword), throwsException);
      verify(mockRemoteDataSource.login(tPhone, tPassword));
      verifyZeroInteractions(mockLocalDataSource);
    });
  });

  group('logout', () {
    test('should call remote logout and clear local storage', () async {
      // Arrange
      when(mockRemoteDataSource.logout()).thenAnswer((_) async => {});
      when(mockLocalDataSource.clearAll()).thenAnswer((_) async => {});

      // Act
      await repository.logout();

      // Assert
      verify(mockRemoteDataSource.logout());
      verify(mockLocalDataSource.clearAll());
    });
  });

  group('getCurrentUser', () {
    test(
      'should return user from remote if logged in and remote succeeds',
      () async {
        // Arrange
        when(mockLocalDataSource.isLoggedIn()).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.getCurrentUser(),
        ).thenAnswer((_) async => tUserModel);
        when(mockLocalDataSource.cacheUser(any)).thenAnswer((_) async => {});

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result, tUserModel);
        verify(mockLocalDataSource.isLoggedIn());
        verify(mockRemoteDataSource.getCurrentUser());
        verify(mockLocalDataSource.cacheUser(tUserModel));
      },
    );

    test(
      'should return cached user if not logged in or remote fails (logic check)',
      () async {
        // In current implementation:
        // if isLoggedIn() is false -> returns cached user

        // Arrange
        when(mockLocalDataSource.isLoggedIn()).thenAnswer((_) async => false);
        when(
          mockLocalDataSource.getCachedUser(),
        ).thenAnswer((_) async => tUserModel);

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result, tUserModel);
        verify(mockLocalDataSource.isLoggedIn());
        verifyNever(mockRemoteDataSource.getCurrentUser());
        verify(mockLocalDataSource.getCachedUser());
      },
    );
  });
}
