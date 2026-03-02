import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../cubit/registration_cubit.dart';
import '../cubit/registration_state.dart';
import 'register_step3_screen.dart';

class RegisterStep2Screen extends StatefulWidget {
  const RegisterStep2Screen({super.key});

  @override
  State<RegisterStep2Screen> createState() => _RegisterStep2ScreenState();
}

class _RegisterStep2ScreenState extends State<RegisterStep2Screen> {
  final _formKey = GlobalKey<FormState>();
  final _jobTitleController = TextEditingController();
  final _companyController = TextEditingController();
  final _skillController = TextEditingController();

  int _experienceYears = 0;
  final List<String> _skills = [];

  static const List<int> _expOptions = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  void dispose() {
    _jobTitleController.dispose();
    _companyController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationCubit, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationStep2Saved) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<RegistrationCubit>(),
                child: const RegisterStep3Screen(),
              ),
            ),
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StepBar(currentStep: 2),
                  const SizedBox(height: 24),
                  Text(
                    AppStrings.registerStep2,
                    style: AppTextStyles.headlineLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Step 2 of 3 — Your professional background',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 32),
                  _label(AppStrings.jobTitle),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _jobTitleController,
                    style: AppTextStyles.bodyLarge,
                    decoration: const InputDecoration(
                        hintText: 'e.g. Software Engineer'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  _label('${AppStrings.experience} (years)'),
                  const SizedBox(height: 12),
                  // Experience grid
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _expOptions.map((year) {
                      final selected = _experienceYears == year;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _experienceYears = year),
                        child: Container(
                          width: 52,
                          height: 44,
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.black
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: selected
                                  ? AppColors.black
                                  : AppColors.lightGrey,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            year == 10 ? '10+' : '$year',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: selected
                                  ? AppColors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  _label(AppStrings.currentCompany),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _companyController,
                    style: AppTextStyles.bodyLarge,
                    decoration: const InputDecoration(
                        hintText: 'e.g. Google, Startup XYZ'),
                  ),
                  const SizedBox(height: 20),
                  _label(AppStrings.skills),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _skillController,
                          style: AppTextStyles.bodyLarge,
                          decoration: InputDecoration(
                            hintText: AppStrings.addSkill,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: _addSkill,
                            ),
                          ),
                          onFieldSubmitted: (_) => _addSkill(),
                        ),
                      ),
                    ],
                  ),
                  if (_skills.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _skills
                          .map(
                            (skill) => Chip(
                              label: Text(skill,
                                  style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textPrimary)),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () =>
                                  setState(() => _skills.remove(skill)),
                              backgroundColor: AppColors.lightGrey,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<RegistrationCubit>().saveStep2(
                              jobTitle: _jobTitleController.text.trim(),
                              experienceYears: _experienceYears,
                              currentCompany: _companyController.text.trim(),
                              skills: _skills,
                            );
                      }
                    },
                    child: const Text(AppStrings.next),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
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
