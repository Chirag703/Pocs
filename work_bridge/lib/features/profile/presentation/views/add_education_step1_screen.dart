import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'add_education_step2_screen.dart';

class AddEducationStep1Screen extends StatefulWidget {
  const AddEducationStep1Screen({super.key});

  @override
  State<AddEducationStep1Screen> createState() =>
      _AddEducationStep1ScreenState();
}

class _AddEducationStep1ScreenState extends State<AddEducationStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  final _courseController = TextEditingController();
  final _universityController = TextEditingController();
  final _gradeController = TextEditingController();

  String _selectedDegree = '';
  String? _startYear;
  String? _endYear;
  bool _currentlyStudying = false;
  bool _isCgpa = true;

  static const List<String> _degreeTypes = [
    '10th',
    '12th',
    "Bachelor's",
    "Master's",
    'PhD',
    'Diploma',
  ];

  static final List<String> _years = List.generate(
    50,
    (i) => (DateTime.now().year - i).toString(),
  );

  @override
  void dispose() {
    _courseController.dispose();
    _universityController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  Future<void> _showYearPicker(
      BuildContext context, bool isStart) async {
    final current = isStart ? _startYear : _endYear;
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  isStart ? AppStrings.startYear : AppStrings.endYear,
                  style: AppTextStyles.titleLarge,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _years.length,
                  itemBuilder: (_, index) {
                    final year = _years[index];
                    final selected = year == current;
                    return ListTile(
                      title: Text(year,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w400,
                          )),
                      trailing: selected
                          ? const Icon(Icons.check_rounded,
                              color: AppColors.black)
                          : null,
                      onTap: () {
                        setState(() {
                          if (isStart) {
                            _startYear = year;
                          } else {
                            _endYear = year;
                          }
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _continue() {
    if (_formKey.currentState!.validate() && _selectedDegree.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AddEducationStep2Screen(
            degree: _selectedDegree,
            course: _courseController.text.trim(),
            university: _universityController.text.trim(),
            grade: _gradeController.text.trim(),
            gradeType: _isCgpa ? AppStrings.cgpa : AppStrings.percentage,
            startYear: _startYear ?? '',
            endYear: _currentlyStudying ? 'Present' : (_endYear ?? ''),
          ),
        ),
      );
    } else if (_selectedDegree.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a degree type')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(AppStrings.addEducation,
            style: AppTextStyles.headlineSmall),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TwoStepIndicator(currentStep: 1),
                const SizedBox(height: 16),
                Text('Step 1 of 2 — Academic Details',
                    style: AppTextStyles.bodySmall),
                const SizedBox(height: 28),

                // Degree type chips
                _label(AppStrings.degreeType),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _degreeTypes.map((d) {
                    final selected = _selectedDegree == d;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedDegree = d),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 9),
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
                          d,
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

                // Course / Specialisation
                _label(AppStrings.courseSpecialisation),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _courseController,
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Computer Science',
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 20),

                // University / College
                _label(AppStrings.universityCollege),
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

                // Start & End Year side-by-side
                _label('${AppStrings.startYear} & ${AppStrings.endYear}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _YearPickerField(
                        label: AppStrings.startYear,
                        value: _startYear,
                        onTap: () => _showYearPicker(context, true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _YearPickerField(
                        label: AppStrings.endYear,
                        value: _currentlyStudying
                            ? 'Present'
                            : _endYear,
                        onTap: _currentlyStudying
                            ? null
                            : () => _showYearPicker(context, false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Currently Studying toggle
                _ToggleRow(
                  label: AppStrings.currentlyStudying,
                  value: _currentlyStudying,
                  onChanged: (v) => setState(() {
                    _currentlyStudying = v;
                    if (v) _endYear = null;
                  }),
                ),
                const SizedBox(height: 20),

                // Grade / Score with CGPA / % toggle
                _label(AppStrings.gradeScore),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _gradeController,
                        keyboardType: TextInputType.number,
                        style: AppTextStyles.bodyLarge,
                        decoration: InputDecoration(
                          hintText: _isCgpa ? 'e.g. 8.5' : 'e.g. 85',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _GradeToggle(
                      isCgpa: _isCgpa,
                      onToggle: (v) => setState(() => _isCgpa = v),
                    ),
                  ],
                ),
                const SizedBox(height: 36),

                // Action buttons
                ElevatedButton(
                  onPressed: _continue,
                  child: const Text('Continue'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(AppStrings.saveAsDraft),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) =>
      Text(text, style: AppTextStyles.titleMedium);
}

class _TwoStepIndicator extends StatelessWidget {
  final int currentStep;

  const _TwoStepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: currentStep >= 2
                  ? AppColors.black
                  : AppColors.lightGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}

class _YearPickerField extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback? onTap;

  const _YearPickerField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: value != null
                      ? AppColors.textPrimary
                      : AppColors.textHint,
                ),
              ),
            ),
            const Icon(Icons.calendar_today_rounded,
                size: 16, color: AppColors.mediumGrey),
          ],
        ),
      ),
    );
  }
}

class _GradeToggle extends StatelessWidget {
  final bool isCgpa;
  final ValueChanged<bool> onToggle;

  const _GradeToggle({required this.isCgpa, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleOption(
            label: AppStrings.cgpa,
            selected: isCgpa,
            onTap: () => onToggle(true),
          ),
          _ToggleOption(
            label: AppStrings.percentage,
            selected: !isCgpa,
            onTap: () => onToggle(false),
          ),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: selected ? AppColors.white : AppColors.textSecondary,
            fontWeight:
                selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: AppTextStyles.bodyMedium),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.black,
          ),
        ],
      ),
    );
  }
}
