import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../cubit/employment_cubit.dart';
import '../cubit/employment_state.dart';
import 'add_employment_step2_screen.dart';

class AddEmploymentStep1Screen extends StatelessWidget {
  const AddEmploymentStep1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmploymentCubit(),
      child: const _AddEmploymentStep1View(),
    );
  }
}

class _AddEmploymentStep1View extends StatefulWidget {
  const _AddEmploymentStep1View();

  @override
  State<_AddEmploymentStep1View> createState() =>
      _AddEmploymentStep1ViewState();
}

class _AddEmploymentStep1ViewState
    extends State<_AddEmploymentStep1View> {
  final _formKey = GlobalKey<FormState>();
  final _jobTitleController = TextEditingController();
  final _companyController = TextEditingController();
  final _cityController = TextEditingController();
  final _ctcController = TextEditingController();

  String _employmentType = '';
  String _workMode = '';
  String _joiningDate = '';
  String _endDate = '';
  bool _currentlyWorking = false;

  static const List<String> _employmentTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Internship',
    'Freelance',
  ];

  static const List<String> _workModes = [
    'On-site',
    'Remote',
    'Hybrid',
  ];

  @override
  void dispose() {
    _jobTitleController.dispose();
    _companyController.dispose();
    _cityController.dispose();
    _ctcController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, bool isJoining) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isJoining
          ? now.subtract(const Duration(days: 365))
          : now,
      firstDate: DateTime(2000),
      lastDate: now.add(const Duration(days: 365 * 2)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme:
              const ColorScheme.light(primary: AppColors.black),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      final formatted =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      setState(() {
        if (isJoining) {
          _joiningDate = formatted;
        } else {
          _endDate = formatted;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmploymentCubit, EmploymentState>(
      listener: (context, state) {
        if (state is EmploymentStep1Saved) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<EmploymentCubit>(),
                child: const AddEmploymentStep2Screen(),
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
          title: Text('Add Employment',
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
                  const _EmpStepBar(currentStep: 1),
                  const SizedBox(height: 20),
                  Text('Step 1 of 2 — Job Information',
                      style: AppTextStyles.bodySmall),
                  const SizedBox(height: 24),
                  _label('Job Title'),
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
                  _label('Employment Type'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _employmentTypes.map((type) {
                      final selected = _employmentType == type;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _employmentType = type),
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
                  _label('Company Name'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _companyController,
                    style: AppTextStyles.bodyLarge,
                    decoration: const InputDecoration(
                      hintText: 'Search company name',
                      prefixIcon: Icon(Icons.business_outlined,
                          size: 20),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            _label('City / Location'),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _cityController,
                              style: AppTextStyles.bodyLarge,
                              decoration: const InputDecoration(
                                hintText: 'e.g. Bangalore',
                                prefixIcon: Icon(
                                    Icons.location_on_outlined,
                                    size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Work Mode'),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.lightGrey),
                            ),
                            child: Column(
                              children: _workModes.map((mode) {
                                final selected = _workMode == mode;
                                return GestureDetector(
                                  onTap: () => setState(
                                      () => _workMode = mode),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? AppColors.black
                                          : Colors.transparent,
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      mode,
                                      style: AppTextStyles.bodySmall
                                          .copyWith(
                                        color: selected
                                            ? AppColors.white
                                            : AppColors.textSecondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _label('Joining Date & End Date'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickDate(context, true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.lightGrey),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                    Icons.calendar_today_rounded,
                                    size: 16,
                                    color: AppColors.mediumGrey),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _joiningDate.isEmpty
                                        ? 'Joining Date'
                                        : _joiningDate,
                                    style: AppTextStyles.bodySmall
                                        .copyWith(
                                      color: _joiningDate.isEmpty
                                          ? AppColors.textHint
                                          : AppColors.textPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
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
                          onTap: _currentlyWorking
                              ? null
                              : () => _pickDate(context, false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 14),
                            decoration: BoxDecoration(
                              color: _currentlyWorking
                                  ? AppColors.offWhite
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.lightGrey),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                    Icons.calendar_today_rounded,
                                    size: 16,
                                    color: AppColors.mediumGrey),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _currentlyWorking
                                        ? 'Present'
                                        : (_endDate.isEmpty
                                            ? 'End Date'
                                            : _endDate),
                                    style: AppTextStyles.bodySmall
                                        .copyWith(
                                      color: _endDate.isEmpty &&
                                              !_currentlyWorking
                                          ? AppColors.textHint
                                          : AppColors.textPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Currently Working Here',
                          style: AppTextStyles.titleMedium),
                      Switch(
                        value: _currentlyWorking,
                        onChanged: (val) =>
                            setState(() => _currentlyWorking = val),
                        activeColor: AppColors.black,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _label('Annual CTC'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _ctcController,
                    style: AppTextStyles.bodyLarge,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'e.g. 12',
                      prefixText: '₹ ',
                      suffixText: 'LPA',
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _employmentType.isNotEmpty) {
                        context.read<EmploymentCubit>().saveStep1(
                              jobTitle:
                                  _jobTitleController.text.trim(),
                              employmentType: _employmentType,
                              companyName: _companyController.text.trim(),
                              city: _cityController.text.trim(),
                              workMode: _workMode,
                              joiningDate: _joiningDate,
                              endDate: _currentlyWorking
                                  ? 'Present'
                                  : _endDate,
                              currentlyWorking: _currentlyWorking,
                              annualCtc: _ctcController.text.trim(),
                            );
                      } else if (_employmentType.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Please select an employment type')),
                        );
                      }
                    },
                    child: const Text('Continue'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: AppColors.lightGrey),
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
