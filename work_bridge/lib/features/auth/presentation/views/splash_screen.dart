import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _dotsController;
  late Animation<double> _fadeAnimation;
  int _activeDot = 0;
  Timer? _dotTimer;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    _dotTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() => _activeDot = (_activeDot + 1) % 3);
      }
    });

    _navTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) context.go(AppRoutes.phoneEntry);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _dotsController.dispose();
    _dotTimer?.cancel();
    _navTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Logo
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text(
                    'W',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.appName,
                style: AppTextStyles.displayLarge.copyWith(
                  color: AppColors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.tagline,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.mediumGrey,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(flex: 2),
              // Animated progress dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _activeDot == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _activeDot == index
                          ? AppColors.white
                          : AppColors.darkGrey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
