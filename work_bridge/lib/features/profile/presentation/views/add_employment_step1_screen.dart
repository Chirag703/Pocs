import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'add_employment_step2_screen.dart';

class AddEmploymentStep1Screen extends StatefulWidget {
  const AddEmploymentStep1Screen({super.key});

  @override
  State<AddEmploymentStep1Screen> createState() =>
      _AddEmploymentStep1ScreenState();
}

class _AddEmploymentStep1ScreenState
    extends State<AddEmploymentStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  final _jobTitleController = TextEditingController();
  final _companyController = TextEditingController();
  final _locationController = TextEditingController();
  final _ctcController = TextEditingController();

  String _selectedEmploymentType = '';
  String _selectedWorkMode = 'On-site';
  DateTime? _joiningDate;
  DateTime? _endDate;
  bool _currentlyWorking = false;
  bool _ctcVisible = false;

  static const List<String> _employmentTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Internship',
    'Freelance',
  ];

  static const List<String> _workModes = ['Hybrid', 'Remote', 'On-site'];

  @override
  void dispose() {
    _jobTitleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _ctcController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final initialDate =
        isStart ? (_joiningDate ?? DateTime.now()) : (_endDate ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1990),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
          _joiningDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  void _continue() {
    if (_formKey.currentState!.validate() &&
        _selectedEmploymentType.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AddEmploymentStep2Screen(
            jobTitle: _jobTitleController.text.trim(),
            company: _companyController.text.trim(),
            employmentType: _selectedEmploymentType,
            workMode: _selectedWorkMode,
            location: _locationController.text.trim(),
            joiningDate: _formatDate(_joiningDate),
            endDate: _currentlyWorking
                ? AppStrings.present
                : _formatDate(_endDate),
            isCurrentRole: _currentlyWorking,
            ctc: _ctcController.text.trim(),
          ),
        ),
      );
    } else if (_selectedEmploymentType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select an employment type')),
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
        title: Text(AppStrings.addEmployment,
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
                Text('Step 1 of 2 — Job Information',
                    style: AppTextStyles.bodySmall),
                const SizedBox(height: 28),

                // Job Title
                _label(AppStrings.jobTitle),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _jobTitleController,
                  style: AppTextStyles.bodyLarge,
                  autofocus: true,
                  decoration: const InputDecoration(
                      hintText: 'e.g. Software Engineer'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 20),

                // Employment Type chips
                _label(AppStrings.employmentType),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _employmentTypes.map((type) {
                    final selected = _selectedEmploymentType == type;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedEmploymentType = type),
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
                          type,
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

                // Company Name
                _label(AppStrings.companyName),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _companyController,
                  style: AppTextStyles.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'e.g. Google, Infosys…',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.lightGrey,
                        child: const Icon(
                            Icons.business_rounded,
                            size: 16,
                            color: AppColors.darkGrey),
                      ),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 20),

                // City / Location + Work Mode
                _label(
                    '${AppStrings.cityLocation} & ${AppStrings.workMode}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _locationController,
                        style: AppTextStyles.bodyLarge,
                        decoration: const InputDecoration(
                            hintText: 'e.g. Mumbai'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _WorkModeSelector(
                      modes: _workModes,
                      selected: _selectedWorkMode,
                      onSelect: (m) =>
                          setState(() => _selectedWorkMode = m),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Joining Date & End Date
                _label(
                    '${AppStrings.joiningDate} & ${AppStrings.endDate}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _DatePickerField(
                        label: AppStrings.joiningDate,
                        value: _formatDate(_joiningDate),
                        onTap: () => _pickDate(context, true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DatePickerField(
                        label: _currentlyWorking
                            ? AppStrings.present
                            : AppStrings.endDate,
                        value: _currentlyWorking
                            ? AppStrings.present
                            : _formatDate(_endDate),
                        onTap: _currentlyWorking
                            ? null
                            : () => _pickDate(context, false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Currently Working Here toggle
                _ToggleRow(
                  label: AppStrings.currentlyWorking,
                  value: _currentlyWorking,
                  onChanged: (v) => setState(() {
                    _currentlyWorking = v;
                    if (v) _endDate = null;
                  }),
                ),
                const SizedBox(height: 20),

                // Annual CTC
                _label(AppStrings.annualCtc),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _ctcController,
                  style: AppTextStyles.bodyLarge,
                  keyboardType: TextInputType.number,
                  obscureText: !_ctcVisible,
                  decoration: InputDecoration(
                    hintText: 'e.g. 1200000',
                    prefixText: '₹ ',
                    suffixText: 'INR',
                    suffixStyle: const TextStyle(
                      color: AppColors.mediumGrey,
                      fontSize: 13,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _ctcVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.mediumGrey,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _ctcVisible = !_ctcVisible),
                    ),
                  ),
                ),
                const SizedBox(height: 36),

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

class _DatePickerField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _DatePickerField({
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
                value.isEmpty ? label : value,
                style: AppTextStyles.bodySmall.copyWith(
                  color: value.isEmpty
                      ? AppColors.textHint
                      : AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
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

class _WorkModeSelector extends StatelessWidget {
  final List<String> modes;
  final String selected;
  final ValueChanged<String> onSelect;

  const _WorkModeSelector({
    required this.modes,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: modes
            .map(
              (m) => GestureDetector(
                onTap: () => onSelect(m),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: selected == m
                        ? AppColors.black
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    m,
                    style: AppTextStyles.caption.copyWith(
                      color: selected == m
                          ? AppColors.white
                          : AppColors.textSecondary,
                      fontWeight: selected == m
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
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
