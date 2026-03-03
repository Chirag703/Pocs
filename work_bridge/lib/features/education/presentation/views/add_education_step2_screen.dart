import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_router.dart';
import '../cubit/education_cubit.dart';
import '../cubit/education_state.dart';

class AddEducationStep2Screen extends StatefulWidget {
  const AddEducationStep2Screen({super.key});

  @override
  State<AddEducationStep2Screen> createState() =>
      _AddEducationStep2ScreenState();
}

class _AddEducationStep2ScreenState
    extends State<AddEducationStep2Screen> {
  final _achievementsController = TextEditingController();
  final _extraCurricularController = TextEditingController();
  final _certificateController = TextEditingController();
  final _skillController = TextEditingController();

  final List<String> _skills = [];
  bool _showOnProfile = true;

  @override
  void dispose() {
    _achievementsController.dispose();
    _extraCurricularController.dispose();
    _certificateController.dispose();
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
    return BlocListener<EducationCubit, EducationState>(
      listener: (context, state) {
        if (state is EducationSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Education saved successfully!')),
          );
          context.go(AppRoutes.mainTab);
        }
      },
      child: BlocBuilder<EducationCubit, EducationState>(
        builder: (context, state) {
          final cubit = context.read<EducationCubit>();
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              leading: const BackButton(),
              backgroundColor: AppColors.background,
              elevation: 0,
              title: Text('Add Education',
                  style: AppTextStyles.headlineSmall),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _EduStepBar(currentStep: 2),
                    const SizedBox(height: 20),
                    Text('Step 2 of 2 — More Details',
                        style: AppTextStyles.bodySmall),
                    const SizedBox(height: 20),
                    // Progress summary card
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
                          Text(
                            cubit.degreeType.isNotEmpty
                                ? cubit.degreeType
                                : 'Degree',
                            style: AppTextStyles.titleLarge.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cubit.university.isNotEmpty
                                ? cubit.university
                                : 'University',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.mediumGrey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _SummaryChip(
                                  label:
                                      '${cubit.startYear} — ${cubit.endYear.isEmpty ? 'Present' : cubit.endYear}'),
                              const SizedBox(width: 8),
                              if (cubit.grade.isNotEmpty)
                                _SummaryChip(
                                    label:
                                        '${cubit.grade} ${cubit.isGradeCgpa ? 'CGPA' : '%'}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _label('Achievements / Highlights'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _achievementsController,
                      style: AppTextStyles.bodyLarge,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText:
                            '• Secured 1st rank in department\n• Dean\'s list for 3 semesters',
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _label('Extra-Curricular Activities'),
                    const SizedBox(height: 4),
                    Text('Optional',
                        style: AppTextStyles.caption),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _extraCurricularController,
                      style: AppTextStyles.bodyLarge,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText:
                            'e.g. NSS volunteer, Coding club president',
                      ),
                    ),
                    const SizedBox(height: 20),
                    _label('Key Skills Learnt'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _skillController,
                            style: AppTextStyles.bodyLarge,
                            decoration: InputDecoration(
                              hintText: 'Add a skill',
                              suffixIcon: IconButton(
                                icon: const Icon(
                                    Icons.add_circle_outline),
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
                    _label('Certificate / Transcript URL'),
                    const SizedBox(height: 4),
                    Text('Optional', style: AppTextStyles.caption),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _certificateController,
                      style: AppTextStyles.bodyLarge,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        hintText: 'https://drive.google.com/...',
                        prefixIcon:
                            Icon(Icons.link_rounded, size: 20),
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
                        context.read<EducationCubit>().saveEducation(
                              achievements:
                                  _achievementsController.text.trim(),
                              extraCurricular:
                                  _extraCurricularController.text
                                      .trim(),
                              skills: _skills,
                              certificateUrl:
                                  _certificateController.text.trim(),
                              showOnProfile: _showOnProfile,
                            );
                      },
                      child: const Text('Save Education'),
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

class _EduStepBar extends StatelessWidget {
  final int currentStep;

  const _EduStepBar({required this.currentStep});

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
