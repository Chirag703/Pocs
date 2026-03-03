import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

class AddEmploymentStep2Screen extends StatefulWidget {
  final String jobTitle;
  final String company;
  final String employmentType;
  final String workMode;
  final String location;
  final String joiningDate;
  final String endDate;
  final bool isCurrentRole;
  final String ctc;

  const AddEmploymentStep2Screen({
    super.key,
    required this.jobTitle,
    required this.company,
    required this.employmentType,
    required this.workMode,
    required this.location,
    required this.joiningDate,
    required this.endDate,
    required this.isCurrentRole,
    required this.ctc,
  });

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
    if (_skills.length >= _maxSkills) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Maximum $_maxSkills skills allowed')),
      );
      return;
    }
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillController.clear();
      });
    }
  }

  void _saveExperience() {
    // In a real app this would dispatch to a cubit/repo.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Experience saved successfully!')),
    );
    // Pop back to the screen that launched the employment flow
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
        title: Text(AppStrings.addEmployment,
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
              Text('Step 2 of 2 — Role Details',
                  style: AppTextStyles.bodySmall),
              const SizedBox(height: 20),

              // Job summary card
              _JobSummaryCard(
                jobTitle: widget.jobTitle,
                company: widget.company,
                employmentType: widget.employmentType,
                workMode: widget.workMode,
                dateRange:
                    '${widget.joiningDate} – ${widget.endDate}',
                isCurrentRole: widget.isCurrentRole,
              ),
              const SizedBox(height: 24),

              // Key Responsibilities
              _label(AppStrings.keyResponsibilities),
              const SizedBox(height: 8),
              TextFormField(
                controller: _responsibilitiesController,
                style: AppTextStyles.bodyLarge,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText:
                      '• Developed REST APIs using Node.js\n• Led a team of 4 engineers…',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),

              // Skills Used
              _label(
                  '${AppStrings.skillsUsed} (up to $_maxSkills)'),
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
                          icon:
                              const Icon(Icons.add_circle_outline),
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

              // Notable Achievements
              _label(
                  '${AppStrings.notableAchievements} (optional)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _achievementsController,
                style: AppTextStyles.bodyLarge,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText:
                      'e.g. Reduced API latency by 40%, launched 3 features…',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),

              // Show on Profile toggle
              _ToggleRow(
                label: AppStrings.showOnProfile,
                value: _showOnProfile,
                onChanged: (v) =>
                    setState(() => _showOnProfile = v),
              ),
              const SizedBox(height: 36),

              ElevatedButton(
                onPressed: _saveExperience,
                child: const Text(AppStrings.saveExperience),
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

class _JobSummaryCard extends StatelessWidget {
  final String jobTitle;
  final String company;
  final String employmentType;
  final String workMode;
  final String dateRange;
  final bool isCurrentRole;

  const _JobSummaryCard({
    required this.jobTitle,
    required this.company,
    required this.employmentType,
    required this.workMode,
    required this.dateRange,
    required this.isCurrentRole,
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
            child: const Icon(Icons.business_center_rounded,
                color: AppColors.darkGrey, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(jobTitle,
                          style: AppTextStyles.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    if (isCurrentRole) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.success
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: AppColors.success
                                  .withOpacity(0.3)),
                        ),
                        child: Text(
                          'Current',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(company,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _Badge(label: employmentType),
                    const SizedBox(width: 6),
                    _Badge(label: workMode),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(dateRange,
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.mediumGrey),
              textAlign: TextAlign.right,
              maxLines: 2),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;

  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Text(label,
          style: AppTextStyles.caption
              .copyWith(color: AppColors.textSecondary)),
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
