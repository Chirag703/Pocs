import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/app_router.dart';
import '../../../home/domain/entities/job.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchCubit>(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _searchController = TextEditingController();

  static const List<String> _trending = [
    'Flutter Developer',
    'Product Manager',
    'Data Scientist',
    'UI/UX Designer',
    'DevOps Engineer',
  ];

  static const List<Map<String, String>> _topCompanies = [
    {'name': 'Google', 'jobs': '120 jobs'},
    {'name': 'Microsoft', 'jobs': '98 jobs'},
    {'name': 'Amazon', 'jobs': '145 jobs'},
    {'name': 'Flipkart', 'jobs': '67 jobs'},
    {'name': 'Zepto', 'jobs': '42 jobs'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(AppStrings.search, style: AppTextStyles.headlineSmall),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: TextFormField(
                controller: _searchController,
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(
                  hintText: AppStrings.searchHint,
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: AppColors.mediumGrey),
                  suffixIcon: BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      return state is! SearchInitial
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded,
                                  color: AppColors.mediumGrey),
                              onPressed: () {
                                _searchController.clear();
                                context.read<SearchCubit>().clear();
                              },
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                ),
                onChanged: (q) => context.read<SearchCubit>().search(q),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.black));
                  }
                  if (state is SearchLoaded) {
                    return _buildResults(context, state);
                  }
                  return _buildInitialContent(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(AppStrings.trendingSearches, style: AppTextStyles.titleLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _trending
              .map(
                (t) => GestureDetector(
                  onTap: () {
                    _searchController.text = t;
                    context.read<SearchCubit>().search(t);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.lightGrey),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.trending_up_rounded,
                            size: 14, color: AppColors.mediumGrey),
                        const SizedBox(width: 6),
                        Text(t, style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 28),
        Text(AppStrings.topCompanies, style: AppTextStyles.titleLarge),
        const SizedBox(height: 12),
        ..._topCompanies.map(
          (company) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightGrey),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.business, size: 20,
                        color: AppColors.darkGrey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(company['name']!,
                            style: AppTextStyles.titleMedium),
                        Text(company['jobs']!,
                            style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.mediumGrey),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults(BuildContext context, SearchLoaded state) {
    if (state.results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded,
                size: 64, color: AppColors.lightGrey),
            const SizedBox(height: 16),
            Text('No results for "${state.query}"',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final job = state.results[index];
        return _SearchResultTile(job: job, onTap: () {
          context.push(AppRoutes.jobDetail, extra: job);
        });
      },
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;

  const _SearchResultTile({required this.job, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  const Icon(Icons.business, size: 22, color: AppColors.darkGrey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job.title, style: AppTextStyles.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    '${job.company} · ${job.location}',
                    style:
                        AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(job.salary, style: AppTextStyles.caption),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.mediumGrey),
          ],
        ),
      ),
    );
  }
}
