import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

class AddEducationStep2Screen extends StatefulWidget {
  final String degree;
  final String course;
  final String university;
  final String grade;
  final String gradeType;
  final String startYear;
  final String endYear;

  const AddEducationStep2Screen({
    super.key,
    required this.degree,
    required this.course,
    required this.university,
    required this.grade,
    required this.gradeType,
    required this.startYear,
    required this.endYear,
  });

  @override
  State<AddEducationStep2Screen> createState() =>
      _AddEducationStep2ScreenState();
}

class _AddEducationStep2ScreenState
    extends State<AddEducationStep2Screen> {
  final _achievementsController = TextEditingController();
  final _activitiesController = TextEditingController();
  final _certUrlController = TextEditingController();
  final _skillController = TextEditingController();

  final List<String> _skills = [];
  bool _showOnProfile = true;

  @override
  void dispose() {
    _achievementsController.dispose();
    _activitiesController.dispose();
    _certUrlController.dispose();
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

  void _saveEducation() {
    // In a real app this would dispatch to a cubit/repo.
    // For now show a snack and pop back to profile.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Education saved successfully!')),
    );
    // Pop back to the screen that launched the education flow
    Navigator.of(context)
      ..pop()
      ..pop();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TwoStepIndicator(currentStep: 2),
              const SizedBox(height: 16),
              Text('Step 2 of 2 — More Details',
                  style: AppTextStyles.bodySmall),
              const SizedBox(height: 20),

              // Summary card
              _SummaryCard(
                line1: '${widget.degree}'
                    '${widget.course.isNotEmpty ? ' — ${widget.course}' : ''}',
                line2: widget.university,
                line3: widget.grade.isNotEmpty
                    ? '${widget.grade} ${widget.gradeType}'
                    : null,
                yearRange:
                    '${widget.startYear} – ${widget.endYear}',
              ),
              const SizedBox(height: 24),

              // Achievements
              _label(AppStrings.achievements),
              const SizedBox(height: 8),
              TextFormField(
                controller: _achievementsController,
                style: AppTextStyles.bodyLarge,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText:
                      '• Dean\'s list, Gold Medal, Research paper…',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),

              // Extra-Curricular Activities
              _label('${AppStrings.extraCurricular} (optional)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _activitiesController,
                style: AppTextStyles.bodyLarge,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'e.g. Debate club, Hackathon organiser…',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),

              // Key Skills Learnt
              _label(AppStrings.keySkillsLearnt),
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
                          deleteIcon:
                              const Icon(Icons.close, size: 16),
                          onDeleted: () =>
                              setState(() => _skills.remove(skill)),
                          backgroundColor: AppColors.lightGrey,
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 20),

              // Certificate URL
              _label(AppStrings.certificateUrl),
              const SizedBox(height: 8),
              TextFormField(
                controller: _certUrlController,
                style: AppTextStyles.bodyLarge,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  hintText: 'https://drive.google.com/…',
                  prefixIcon:
                      Icon(Icons.link_rounded, color: AppColors.mediumGrey),
                ),
              ),
              const SizedBox(height: 16),

              // Show on Profile toggle
              _ToggleRow(
                label: AppStrings.showOnProfile,
                value: _showOnProfile,
                onChanged: (v) => setState(() => _showOnProfile = v),
              ),
              const SizedBox(height: 36),

              ElevatedButton(
                onPressed: _saveEducation,
                child: const Text(AppStrings.saveEducation),
              ),
              const SizedBox(height: 32),
            ],
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

class _SummaryCard extends StatelessWidget {
  final String line1;
  final String line2;
  final String? line3;
  final String yearRange;

  const _SummaryCard({
    required this.line1,
    required this.line2,
    this.line3,
    required this.yearRange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.offWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: const Icon(Icons.school_rounded,
                color: AppColors.darkGrey, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(line1,
                    style: AppTextStyles.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(line2,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textSecondary)),
                if (line3 != null) ...[
                  const SizedBox(height: 2),
                  Text(line3!,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textSecondary)),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(yearRange,
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.mediumGrey)),
        ],
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
