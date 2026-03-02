import 'package:get_it/get_it.dart';
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
  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<RegistrationRepository>(
    () => RegistrationRepositoryImpl(),
  );
  sl.registerLazySingleton<JobRepository>(() => JobRepositoryImpl());
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl());

  // Cubits (factories — new instance each time)
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepository>()));
  sl.registerFactory<RegistrationCubit>(
    () => RegistrationCubit(sl<RegistrationRepository>()),
  );
  sl.registerFactory<HomeCubit>(() => HomeCubit(sl<JobRepository>()));
  sl.registerFactory<SearchCubit>(() => SearchCubit(sl<JobRepository>()));
  sl.registerFactory<NotificationsCubit>(() => NotificationsCubit());
  sl.registerFactory<ActivityCubit>(() => ActivityCubit());
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl<ProfileRepository>()));
}
