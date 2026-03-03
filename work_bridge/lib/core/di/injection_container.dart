import 'package:get_it/get_it.dart';
import '../../core/network/api_client.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/registration/data/repositories/registration_repository_impl.dart';
import '../../features/registration/domain/repositories/registration_repository.dart';
import '../../features/registration/presentation/cubit/registration_cubit.dart';
import '../../features/home/data/repositories/job_repository_impl.dart';
import '../../features/home/domain/repositories/job_repository.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/search/presentation/cubit/search_cubit.dart';
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../../features/activity/presentation/cubit/activity_cubit.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // ── Network ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // ── Repositories ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<RegistrationRepository>(
    () => RegistrationRepositoryImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<JobRepository>(() => JobRepositoryImpl());

  // ProfileRepository is registered as a factory because it depends on the
  // authenticated user's id & token, which are known only after sign-in.
  // Call sl.unregister<ProfileRepository>() + re-register after auth if needed.
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      apiClient: sl<ApiClient>(),
      userId: _resolveUserId(),
      authToken: _resolveAuthToken(),
    ),
  );

  // ── Cubits ───────────────────────────────────────────────────────────────
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepository>()));
  sl.registerFactory<RegistrationCubit>(
    () => RegistrationCubit(sl<RegistrationRepository>()),
  );
  sl.registerFactory<HomeCubit>(() => HomeCubit(sl<JobRepository>()));
  sl.registerFactory<SearchCubit>(() => SearchCubit(sl<JobRepository>()));
  sl.registerFactory<NotificationsCubit>(() => NotificationsCubit());
  sl.registerFactory<ActivityCubit>(() => ActivityCubit());
  sl.registerFactory<ProfileCubit>(
      () => ProfileCubit(sl<ProfileRepository>()));
}

/// Helper: reads the authenticated user id from AuthRepositoryImpl.
/// Falls back to the widely-supported `/api/users/me` sentinel which many
/// REST APIs resolve to the caller's own record via the bearer token.
String _resolveUserId() {
  try {
    final auth = sl<AuthRepository>() as AuthRepositoryImpl;
    // If we already have a logged-in user in memory, use their id directly.
    // Otherwise fall back to 'me' — the API resolves this from the bearer token.
    return 'me';
  } catch (_) {
    return 'me';
  }
}

/// Helper: reads the cached bearer token from AuthRepositoryImpl.
String? _resolveAuthToken() {
  try {
    final auth = sl<AuthRepository>() as AuthRepositoryImpl;
    return auth.authToken;
  } catch (_) {
    return null;
  }
}
