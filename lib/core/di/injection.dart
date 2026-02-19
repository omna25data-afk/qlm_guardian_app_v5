import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../sync/sync_service.dart';
import '../database/app_database.dart';
import '../../features/registry/data/datasources/registry_local_datasource.dart';
import '../../features/registry/data/datasources/registry_remote_datasource.dart';
import '../../features/registry/data/repositories/registry_repository.dart';
import '../../features/admin/data/repositories/admin_repository.dart';
import '../../features/records/data/repositories/records_repository.dart';
import '../../features/dashboard/data/repositories/dashboard_repository.dart';
import '../../features/profile/data/repositories/profile_repository.dart';
import '../config/app_config.dart';
import '../../features/system/data/repositories/system_repository.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies
Future<void> initDependencies() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Open cache box
  final cacheBox = await Hive.openBox('api_cache');
  final syncBox = await Hive.openBox('sync_queue');

  // Register boxes
  getIt.registerSingleton<Box<dynamic>>(cacheBox, instanceName: 'cacheBox');
  getIt.registerSingleton<Box<dynamic>>(syncBox, instanceName: 'syncBox');

  // Network Info
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfo());

  // API Client
  getIt.registerSingletonAsync<ApiClient>(() async {
    return await ApiClient.create(cacheBox: cacheBox);
  });

  // Wait for async singletons
  await getIt.allReady();

  // Sync Service (depends on ApiClient)
  getIt.registerLazySingleton<SyncService>(
    () => SyncService(
      apiClient: getIt<ApiClient>(),
      networkInfo: getIt<NetworkInfo>(),
      syncBox: getIt<Box<dynamic>>(instanceName: 'syncBox'),
    ),
  );

  // --- Registry Feature ---

  // Database
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Data Sources
  getIt.registerLazySingleton<RegistryLocalDataSource>(
    () => RegistryLocalDataSourceImpl(getIt<AppDatabase>()),
  );

  getIt.registerLazySingleton<RegistryRemoteDataSource>(
    () => RegistryRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  // Repository
  getIt.registerLazySingleton<RegistryRepository>(
    () => RegistryRepository(
      localDataSource: getIt<RegistryLocalDataSource>(),
      remoteDataSource: getIt<RegistryRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
      cacheBox: getIt<Box<dynamic>>(instanceName: 'cacheBox'),
      syncService: getIt<SyncService>(),
    ),
  );

  // --- System Repository (Generated) ---
  getIt.registerLazySingleton<SystemRepository>(() {
    final baseUrl = AppConfig.apiBaseUrl.replaceAll(RegExp(r'/api$'), '');
    return SystemRepository(getIt<ApiClient>().dio, baseUrl: baseUrl);
  });

  // --- Migrated Features (v4 → v5) ---

  getIt.registerLazySingleton<AdminRepository>(
    () => AdminRepository(getIt<ApiClient>(), getIt<SystemRepository>()),
  );

  getIt.registerLazySingleton<RecordsRepository>(
    () => RecordsRepository(
      getIt<ApiClient>(),
      getIt<NetworkInfo>(),
      getIt<Box<dynamic>>(instanceName: 'cacheBox'),
    ),
  );

  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepository(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepository(getIt<ApiClient>()),
  );
}

/// Reset all dependencies (for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
