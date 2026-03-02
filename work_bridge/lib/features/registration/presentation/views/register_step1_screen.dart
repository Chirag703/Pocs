import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/app_router.dart';
import '../cubit/registration_cubit.dart';
import '../cubit/registration_state.dart';
import 'register_step2_screen.dart';

class RegisterStep1Screen extends StatelessWidget {
  final String phoneNumber;

  const RegisterStep1Screen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegistrationCubit>(),
      child: _RegisterStep1View(phoneNumber: phoneNumber),
    );
  }
}

class _RegisterStep1View extends StatefulWidget {
  final String phoneNumber;

  const _RegisterStep1View({required this.phoneNumber});

  @override
  State<_RegisterStep1View> createState() => _RegisterStep1ViewState();
}

class _RegisterStep1ViewState extends State<_RegisterStep1View> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  String _selectedGender = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.black),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _dobController.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationCubit, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationStep1Saved) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<RegistrationCubit>(),
                child: const RegisterStep2Screen(),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => context.go(AppRoutes.accountNotFound,
                extra: widget.phoneNumber),
          ),
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
                  _StepIndicator(currentStep: 1),
                  const SizedBox(height: 24),
                  Text(
                    AppStrings.registerStep1,
                    style: AppTextStyles.headlineLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Step 1 of 3 — Tell us about yourself',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 32),
                  _buildLabel(AppStrings.fullName),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    style: AppTextStyles.bodyLarge,
                    decoration: const InputDecoration(
                        hintText: 'e.g. Rahul Sharma'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildLabel(AppStrings.emailAddress),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: AppTextStyles.bodyLarge,
                    decoration: const InputDecoration(
                        hintText: 'e.g. rahul@email.com'),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (!v.contains('@')) return 'Invalid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildLabel(AppStrings.dateOfBirth),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _dobController,
                    readOnly: true,
                    style: AppTextStyles.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'DD/MM/YYYY',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today_rounded,
                            size: 20),
                        onPressed: () => _pickDate(context),
                      ),
                    ),
                    onTap: () => _pickDate(context),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildLabel(AppStrings.gender),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      AppStrings.male,
                      AppStrings.female,
                      AppStrings.other,
                    ].map((g) {
                      final selected = _selectedGender == g;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedGender = g),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
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
                              g,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: selected
                                    ? AppColors.white
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _selectedGender.isNotEmpty) {
                        context.read<RegistrationCubit>().saveStep1(
                              phone: widget.phoneNumber,
                              name: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              dateOfBirth: _dobController.text,
                              gender: _selectedGender,
                            );
                      } else if (_selectedGender.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please select your gender')),
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

  Widget _buildLabel(String text) => Text(
        text,
        style: AppTextStyles.titleMedium,
      );
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;

  const _StepIndicator({required this.currentStep});

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
