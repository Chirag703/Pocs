import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../cubit/education_cubit.dart';
import '../cubit/education_state.dart';
import 'add_education_step2_screen.dart';

class AddEducationStep1Screen extends StatelessWidget {
  const AddEducationStep1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EducationCubit(),
      child: const _AddEducationStep1View(),
    );
  }
}

class _AddEducationStep1View extends StatefulWidget {
  const _AddEducationStep1View();

  @override
  State<_AddEducationStep1View> createState() => _AddEducationStep1ViewState();
}

class _AddEducationStep1ViewState extends State<_AddEducationStep1View> {
  final _formKey = GlobalKey<FormState>();
  final _courseController = TextEditingController();
  final _universityController = TextEditingController();
  final _gradeController = TextEditingController();

  String _selectedDegree = '';
  String _startYear = '';
  String _endYear = '';
  bool _isGradeCgpa = true;
  bool _currentlyStudying = false;

  static const List<String> _degreeTypes = [
    '10th',
    '12th',
    "Bachelor's",
    "Master's",
    'PhD',
    'Diploma',
  ];

  static const List<String> _courses = [
    'Computer Science',
    'Information Technology',
    'Electronics',
    'Mechanical Engineering',
    'Civil Engineering',
    'Business Administration',
    'Commerce',
    'Science',
    'Arts',
    'Other',
  ];

  @override
  void dispose() {
    _courseController.dispose();
    _universityController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  Future<void> _pickYear(BuildContext context, bool isStart) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(isStart ? now.year - 4 : now.year),
      firstDate: DateTime(1990),
      lastDate: DateTime(now.year + 6),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme:
              const ColorScheme.light(primary: AppColors.black),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startYear = picked.year.toString();
        } else {
          _endYear = picked.year.toString();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EducationCubit, EducationState>(
      listener: (context, state) {
        if (state is EducationStep1Saved) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<EducationCubit>(),
                child: const AddEducationStep2Screen(),
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
          title: Text('Add Education', style: AppTextStyles.headlineSmall),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _EduStepBar(currentStep: 1),
                  const SizedBox(height: 20),
                  Text('Step 1 of 2 — Academic Details',
                      style: AppTextStyles.bodySmall),
                  const SizedBox(height: 24),
                  _label('Degree Type'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _degreeTypes.map((degree) {
                      final selected = _selectedDegree == degree;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedDegree = degree),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.black
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: selected
                                  ? AppColors.black
                                  : AppColors.lightGrey,
                            ),
                          ),
                          child: Text(
                            degree,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: selected
                                  ? AppColors.white
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  _label('Course / Specialisation'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _courseController.text.isNotEmpty
                        ? _courseController.text
                        : null,
                    items: _courses
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c,
                                  style: AppTextStyles.bodyMedium),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) _courseController.text = val;
                    },
                    decoration: const InputDecoration(
                        hintText: 'Select course'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  _label('University / College Name'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _universityController,
                    style: AppTextStyles.bodyLarge,
                    decoration: const InputDecoration(
                        hintText: 'e.g. IIT Bombay'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  _label('Start Year & End Year'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickYear(context, true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: AppColors.lightGrey),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded,
                                    size: 16,
                                    color: AppColors.mediumGrey),
                                const SizedBox(width: 8),
                                Text(
                                  _startYear.isEmpty
                                      ? 'Start Year'
                                      : _startYear,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: _startYear.isEmpty
                                        ? AppColors.textHint
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: _currentlyStudying
                              ? null
                              : () => _pickYear(context, false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 14),
                            decoration: BoxDecoration(
                              color: _currentlyStudying
                                  ? AppColors.offWhite
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: AppColors.lightGrey),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded,
                                    size: 16,
                                    color: AppColors.mediumGrey),
                                const SizedBox(width: 8),
                                Text(
                                  _currentlyStudying
                                      ? 'Present'
                                      : (_endYear.isEmpty
                                          ? 'End Year'
                                          : _endYear),
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: _endYear.isEmpty &&
                                            !_currentlyStudying
                                        ? AppColors.textHint
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _label('Grade / Score'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _gradeController,
                          style: AppTextStyles.bodyLarge,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText:
                                _isGradeCgpa ? 'e.g. 8.5' : 'e.g. 85',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.lightGrey),
                        ),
                        child: Row(
                          children: [
                            _GradeToggleChip(
                              label: 'CGPA',
                              selected: _isGradeCgpa,
                              onTap: () =>
                                  setState(() => _isGradeCgpa = true),
                            ),
                            _GradeToggleChip(
                              label: '%',
                              selected: !_isGradeCgpa,
                              onTap: () =>
                                  setState(() => _isGradeCgpa = false),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Currently Studying Here',
                          style: AppTextStyles.titleMedium),
                      Switch(
                        value: _currentlyStudying,
                        onChanged: (val) =>
                            setState(() => _currentlyStudying = val),
                        activeColor: AppColors.black,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _selectedDegree.isNotEmpty) {
                        context.read<EducationCubit>().saveStep1(
                              degreeType: _selectedDegree,
                              course: _courseController.text.trim(),
                              university:
                                  _universityController.text.trim(),
                              startYear: _startYear,
                              endYear: _currentlyStudying
                                  ? 'Present'
                                  : _endYear,
                              grade: _gradeController.text.trim(),
                              isGradeCgpa: _isGradeCgpa,
                              currentlyStudying: _currentlyStudying,
                            );
                      } else if (_selectedDegree.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Please select a degree type')),
                        );
                      }
                    },
                    child: const Text('Continue'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.lightGrey),
                      foregroundColor: AppColors.textSecondary,
                    ),
                    child: const Text('Save as Draft'),
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

  Widget _label(String text) =>
      Text(text, style: AppTextStyles.titleMedium);
}

class _GradeToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GradeToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color:
                selected ? AppColors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
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
