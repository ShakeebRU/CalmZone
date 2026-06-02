import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../Components/input_field_widget.dart';
import '../providers/login_controller.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import 'dashboard_screen.dart';

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({super.key});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String? _selectedGender;
  int _currentStep = 0;

  final List<String> _genders = ['Male', 'Female', 'Other'];

  Future<void> _saveData() async {
    final loginController = Provider.of<LoginController>(
      context,
      listen: false,
    );

    final success = await loginController.updateUserProfile(
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text.trim()),
      gender: _selectedGender!,
      weight: double.parse(_weightController.text.trim()),
      height: double.parse(_heightController.text.trim()),
    );

    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (route) => false,
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loginController.errorMessage ?? 'Failed to save profile',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_currentStep == 0) {
      if (_nameController.text.isNotEmpty) {
        setState(() {
          _currentStep = 1;
        });
      }
    } else if (_currentStep == 1) {
      if (_ageController.text.isNotEmpty && _selectedGender != null) {
        setState(() {
          _currentStep = 2;
        });
      }
    } else if (_currentStep == 2) {
      if (_formKey.currentState!.validate()) {
        _saveData();
      }
    }
  }

  void _handleBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  // Future<void> _saveDataLocal() async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   await userProvider.savePersonalData(
  //     name: _nameController.text.trim(),
  //     age: int.parse(_ageController.text.trim()),
  //     gender: _selectedGender!,
  //     weight: double.parse(_weightController.text.trim()),
  //     height: double.parse(_heightController.text.trim()),
  //   );

  //   if (mounted) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const DashboardScreen()),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: Constants.getBackgroundColor(isDark),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                      height: 4,
                      decoration: BoxDecoration(
                        color: index <= _currentStep
                            ? Constants.accentColor
                            : Constants.getBorderColor(isDark),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      // Title
                      Text(
                        _currentStep == 0
                            ? 'Tell us about yourself'
                            : _currentStep == 1
                            ? 'Personal Information'
                            : 'Physical Details',
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Constants.getTextColor(isDark),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _currentStep == 0
                            ? 'We need some basic information to personalize your experience'
                            : _currentStep == 1
                            ? 'Help us understand you better'
                            : 'Let\'s complete your profile',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: Constants.getTextSecondaryColor(isDark),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Step 0: Name
                      if (_currentStep == 0) ...[
                        CustomInputField(
                          isDark: isDark,
                          label: 'Full Name',
                          hint: 'Enter your full name',
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                      ],
                      // Step 1: Age and Gender
                      if (_currentStep == 1) ...[
                        CustomInputField(
                          isDark: isDark,
                          label: 'Age',
                          hint: 'Enter your age',
                          keyboardType: TextInputType.number,
                          controller: _ageController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your age';
                            }
                            final age = int.tryParse(value);
                            if (age == null || age < 1 || age > 120) {
                              return 'Please enter a valid age';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Gender',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            color: Constants.getTextColor(isDark),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._genders.map((gender) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedGender = gender;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: _selectedGender == gender
                                      ? Constants.accentColor.withOpacity(0.1)
                                      : Constants.getInputBackgroundColor(
                                          isDark,
                                        ),
                                  border: Border.all(
                                    color: _selectedGender == gender
                                        ? Constants.accentColor
                                        : Constants.getBorderColor(isDark),
                                    width: _selectedGender == gender ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _selectedGender == gender
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      color: _selectedGender == gender
                                          ? Constants.accentColor
                                          : Constants.getTextSecondaryColor(
                                              isDark,
                                            ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      gender,
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        color: Constants.getTextColor(isDark),
                                        fontWeight: _selectedGender == gender
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                      // Step 2: Weight and Height
                      if (_currentStep == 2) ...[
                        CustomInputField(
                          isDark: isDark,
                          label: 'Weight (kg)',
                          hint: 'Enter your weight',
                          keyboardType: TextInputType.number,
                          controller: _weightController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your weight';
                            }
                            final weight = double.tryParse(value);
                            if (weight == null || weight < 1 || weight > 500) {
                              return 'Please enter a valid weight';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomInputField(
                          isDark: isDark,
                          label: 'Height (cm)',
                          hint: 'Enter your height',
                          keyboardType: TextInputType.number,
                          controller: _heightController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your height';
                            }
                            final height = double.tryParse(value);
                            if (height == null || height < 50 || height > 300) {
                              return 'Please enter a valid height';
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            // Navigation Buttons
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Constants.getSurfaceColor(isDark),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _handleBack,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: Constants.getBorderColor(isDark),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Back',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Constants.getTextColor(isDark),
                          ),
                        ),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentStep == 2 ? 'Complete' : 'Next',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
