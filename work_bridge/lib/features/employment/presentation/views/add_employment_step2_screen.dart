import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_router.dart';
import '../cubit/employment_cubit.dart';
import '../cubit/employment_state.dart';

class AddEmploymentStep2Screen extends StatefulWidget {
  const AddEmploymentStep2Screen({super.key});

  @override
  State<AddEmploymentStep2Screen> createState() =>
      _AddEmploymentStep2ScreenState();
}

class _AddEmploymentStep2ScreenState
    extends State<AddEmploymentStep2Screen> {
  final _responsibilitiesController = TextEditingController();
  final _achievementsController = TextEditingController();
  final _skillController = TextEditingController();

  final List<String> _skills = [];
  bool _showOnProfile = true;

  static const int _maxSkills = 10;

  @override
  void dispose() {
    _responsibilitiesController.dispose();
    _achievementsController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty &&
        !_skills.contains(skill) &&
        _skills.length < _maxSkills) {
      setState(() {
        _skills.add(skill);
        _skillController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmploymentCubit, EmploymentState>(
      listener: (context, state) {
        if (state is EmploymentSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Experience saved successfully!')),
          );
          context.go(AppRoutes.mainTab);
        }
      },
      child: BlocBuilder<EmploymentCubit, EmploymentState>(
        builder: (context, state) {
          final cubit = context.read<EmploymentCubit>();
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              leading: const BackButton(),
              backgroundColor: AppColors.background,
              elevation: 0,
              title: Text('Add Employment',
                  style: AppTextStyles.headlineSmall),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _EmpStepBar(currentStep: 2),
                    const SizedBox(height: 20),
                    Text('Step 2 of 2 — Role Details',
                        style: AppTextStyles.bodySmall),
                    const SizedBox(height: 20),
                    // Job summary card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  cubit.jobTitle.isNotEmpty
                                      ? cubit.jobTitle
                                      : 'Job Title',
                                  style: AppTextStyles.titleLarge
                                      .copyWith(
                                          color: AppColors.white),
                                ),
                              ),
                              if (cubit.currentlyWorking)
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Current Role',
                                    style: AppTextStyles.caption
                                        .copyWith(
                                            color: AppColors.white),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cubit.companyName.isNotEmpty
                                ? cubit.companyName
                                : 'Company',
                            style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.mediumGrey),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              if (cubit.employmentType.isNotEmpty)
                                _SummaryChip(
                                    label: cubit.employmentType),
                              if (cubit.workMode.isNotEmpty)
                                _SummaryChip(label: cubit.workMode),
                              if (cubit.joiningDate.isNotEmpty)
                                _SummaryChip(
                                    label:
                                        '${cubit.joiningDate} — ${cubit.endDate.isEmpty ? 'Present' : cubit.endDate}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _label('Key Responsibilities'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _responsibilitiesController,
                      style: AppTextStyles.bodyLarge,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText:
                            '• Led development of microservices architecture\n• Mentored junior engineers\n• Improved system performance by 40%',
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        _label('Skills Used'),
                        Text(
                          '${_skills.length}/$_maxSkills',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _skillController,
                            style: AppTextStyles.bodyLarge,
                            decoration: InputDecoration(
                              hintText: _skills.length >= _maxSkills
                                  ? 'Max $_maxSkills skills added'
                                  : 'Add a skill',
                              suffixIcon: IconButton(
                                icon: const Icon(
                                    Icons.add_circle_outline),
                                onPressed: _skills.length < _maxSkills
                                    ? _addSkill
                                    : null,
                              ),
                            ),
                            enabled: _skills.length < _maxSkills,
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
                                    style: AppTextStyles.bodySmall
                                        .copyWith(
                                            color:
                                                AppColors.textPrimary)),
                                deleteIcon: const Icon(Icons.close,
                                    size: 16),
                                onDeleted: () => setState(
                                    () => _skills.remove(skill)),
                                backgroundColor: AppColors.lightGrey,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: 20),
                    _label('Notable Achievements'),
                    const SizedBox(height: 4),
                    Text('Optional', style: AppTextStyles.caption),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _achievementsController,
                      style: AppTextStyles.bodyLarge,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText:
                            'e.g. Reduced deployment time by 60%',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text('Show on Profile',
                                style: AppTextStyles.titleMedium),
                            Text('Visible to recruiters',
                                style: AppTextStyles.caption),
                          ],
                        ),
                        Switch(
                          value: _showOnProfile,
                          onChanged: (val) =>
                              setState(() => _showOnProfile = val),
                          activeColor: AppColors.black,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<EmploymentCubit>()
                            .saveEmployment(
                              responsibilities:
                                  _responsibilitiesController.text
                                      .trim(),
                              skills: _skills,
                              achievements:
                                  _achievementsController.text.trim(),
                              showOnProfile: _showOnProfile,
                            );
                      },
                      child: const Text('Save Experience'),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _label(String text) =>
      Text(text, style: AppTextStyles.titleMedium);
}

class _SummaryChip extends StatelessWidget {
  final String label;

  const _SummaryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: AppColors.white),
      ),
    );
  }
}

class _EmpStepBar extends StatelessWidget {
  final int currentStep;

  const _EmpStepBar({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(2, (index) {
        final step = index + 1;
        final isActive = step <= currentStep;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.black
                        : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              if (step < 2) const SizedBox(width: 4),
            ],
          ),
        );
      }),
    );
  }
}
