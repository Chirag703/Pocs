import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_router.dart';
import '../cubit/registration_cubit.dart';
import '../cubit/registration_state.dart';

class RegisterStep3Screen extends StatefulWidget {
  const RegisterStep3Screen({super.key});

  @override
  State<RegisterStep3Screen> createState() => _RegisterStep3ScreenState();
}

class _RegisterStep3ScreenState extends State<RegisterStep3Screen> {
  String _jobType = 'Full Time';
  final List<String> _cities = [];
  final _cityController = TextEditingController();
  double _salaryLpa = 5;
  String _noticePeriod = 'Immediate';

  static const List<String> _jobTypes = [
    'Full Time',
    'Part Time',
    'Remote',
    'Freelance',
  ];

  static const List<String> _noticePeriods = [
    'Immediate',
    '15 Days',
    '1 Month',
    '2 Months',
    '3 Months',
  ];

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  void _addCity() {
    final city = _cityController.text.trim();
    if (city.isNotEmpty && !_cities.contains(city)) {
      setState(() {
        _cities.add(city);
        _cityController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationCubit, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationSuccess) {
          context.go(AppRoutes.profileCreated);
        } else if (state is RegistrationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: const BackButton(),
          backgroundColor: AppColors.background,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StepBar(currentStep: 3),
                const SizedBox(height: 24),
                Text(
                  AppStrings.registerStep3,
                  style: AppTextStyles.headlineLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Step 3 of 3 — Tell us what you\'re looking for',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 32),
                _label(AppStrings.jobType),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _jobTypes.map((type) {
                    final selected = _jobType == type;
                    return ChoiceChip(
                      label: Text(type),
                      selected: selected,
                      onSelected: (_) => setState(() => _jobType = type),
                      selectedColor: AppColors.black,
                      backgroundColor: AppColors.white,
                      labelStyle: TextStyle(
                        color: selected ? AppColors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                _label(AppStrings.preferredCities),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        style: AppTextStyles.bodyLarge,
                        decoration: InputDecoration(
                          hintText: 'Add a city',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: _addCity,
                          ),
                        ),
                        onFieldSubmitted: (_) => _addCity(),
                      ),
                    ),
                  ],
                ),
                if (_cities.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _cities
                        .map(
                          (city) => Chip(
                            label: Text(city,
                                style: AppTextStyles.bodySmall
                                    .copyWith(color: AppColors.textPrimary)),
                            deleteIcon:
                                const Icon(Icons.close, size: 16),
                            onDeleted: () =>
                                setState(() => _cities.remove(city)),
                            backgroundColor: AppColors.lightGrey,
                          ),
                        )
                        .toList(),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _label(AppStrings.expectedSalary),
                    Text(
                      '${_salaryLpa.toInt()} LPA',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _salaryLpa,
                  min: 1,
                  max: 50,
                  divisions: 49,
                  activeColor: AppColors.black,
                  inactiveColor: AppColors.lightGrey,
                  onChanged: (val) => setState(() => _salaryLpa = val),
                ),
                const SizedBox(height: 20),
                _label(AppStrings.noticePeriod),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _noticePeriods.map((period) {
                    final selected = _noticePeriod == period;
                    return ChoiceChip(
                      label: Text(period),
                      selected: selected,
                      onSelected: (_) =>
                          setState(() => _noticePeriod = period),
                      selectedColor: AppColors.black,
                      backgroundColor: AppColors.white,
                      labelStyle: TextStyle(
                        color:
                            selected ? AppColors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),
                BlocBuilder<RegistrationCubit, RegistrationState>(
                  builder: (context, state) {
                    final isLoading = state is RegistrationLoading;
                    return ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context
                                  .read<RegistrationCubit>()
                                  .submitRegistration(
                                    jobType: _jobType,
                                    preferredCities: _cities,
                                    expectedSalaryLpa: _salaryLpa.toInt(),
                                    noticePeriod: _noticePeriod,
                                  );
                            },
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(AppStrings.createProfile),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text, style: AppTextStyles.titleMedium);
}

class _StepBar extends StatelessWidget {
  final int currentStep;

  const _StepBar({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        final step = index + 1;
        final isActive = step <= currentStep;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.black : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              if (step < 3) const SizedBox(width: 4),
            ],
          ),
        );
      }),
    );
  }
}
