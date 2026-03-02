import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/views/splash_screen.dart';
import '../../features/auth/presentation/views/phone_entry_screen.dart';
import '../../features/auth/presentation/views/otp_verification_screen.dart';
import '../../features/auth/presentation/views/account_not_found_screen.dart';
import '../../features/registration/presentation/views/register_step1_screen.dart';
import '../../features/registration/presentation/views/register_step2_screen.dart';
import '../../features/registration/presentation/views/register_step3_screen.dart';
import '../../features/registration/presentation/views/profile_created_screen.dart';
import '../../features/main_app/views/main_tab_screen.dart';
import '../../features/home/presentation/views/job_detail_screen.dart';
import '../../features/home/domain/entities/job.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String phoneEntry = '/phone-entry';
  static const String otpVerification = '/otp-verification';
  static const String accountNotFound = '/account-not-found';
  static const String registerStep1 = '/register/step1';
  static const String registerStep2 = '/register/step2';
  static const String registerStep3 = '/register/step3';
  static const String profileCreated = '/profile-created';
  static const String mainTab = '/main';
  static const String jobDetail = '/job-detail';
}

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.phoneEntry,
        builder: (context, state) => const PhoneEntryScreen(),
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return OtpVerificationScreen(phoneNumber: phone);
        },
      ),
      GoRoute(
        path: AppRoutes.accountNotFound,
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return AccountNotFoundScreen(phoneNumber: phone);
        },
      ),
      GoRoute(
        path: AppRoutes.registerStep1,
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return RegisterStep1Screen(phoneNumber: phone);
        },
      ),
      GoRoute(
        path: AppRoutes.registerStep2,
        builder: (context, state) => const RegisterStep2Screen(),
      ),
      GoRoute(
        path: AppRoutes.registerStep3,
        builder: (context, state) => const RegisterStep3Screen(),
      ),
      GoRoute(
        path: AppRoutes.profileCreated,
        builder: (context, state) => const ProfileCreatedScreen(),
      ),
      GoRoute(
        path: AppRoutes.mainTab,
        builder: (context, state) => const MainTabScreen(),
      ),
      GoRoute(
        path: AppRoutes.jobDetail,
        builder: (context, state) {
          final job = state.extra as Job;
          return JobDetailScreen(job: job);
        },
      ),
    ],
  );
}
