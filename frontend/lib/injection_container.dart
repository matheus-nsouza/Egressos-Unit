import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_egressos/core/constants/api_constants.dart';
import 'package:app_egressos/core/services/http_client.dart';
import 'package:app_egressos/features/auth/data/repositories/auth_repository.dart';
import 'package:app_egressos/features/auth/presentation/providers/auth_notifier.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ========== External ==========
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  // Firebase Auth
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  // ========== Core ==========
  // HTTP Client
  sl.registerLazySingleton<HttpClient>(
    () => HttpClient(
      baseUrl: ApiConstants.baseUrl,
      prefs: sl(),
    ),
  );

  // ========== Features - Auth ==========
  
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      httpClient: sl(),
      prefs: sl(),
      firebaseAuth: sl(),
    ),
  );

  // Provider / Notifier
  sl.registerFactory<AuthNotifier>(
    () => AuthNotifier(sl()),
  );
  
  // Adicione outras features aqui conforme necessário
}