import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import 'profile_overview_screen.dart';
import 'profile_details_screen.dart';
import 'profile_resume_screen.dart';

class ProfileTabScreen extends StatefulWidget {
  const ProfileTabScreen({super.key});

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..loadProfile(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.white,
          elevation: 0,
          title:
              Text(AppStrings.profile, style: AppTextStyles.headlineSmall),
          bottom: TabBar(
            controller: _tabController,
            labelColor: AppColors.black,
            unselectedLabelColor: AppColors.mediumGrey,
            indicatorColor: AppColors.black,
            indicatorWeight: 2,
            labelStyle: AppTextStyles.titleMedium,
            unselectedLabelStyle: AppTextStyles.bodyMedium,
            tabs: const [
              Tab(text: AppStrings.overview),
              Tab(text: AppStrings.details),
              Tab(text: AppStrings.resume),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            ProfileOverviewScreen(),
            ProfileDetailsScreen(),
            ProfileResumeScreen(),
          ],
        ),
      ),
    );
  }
}
