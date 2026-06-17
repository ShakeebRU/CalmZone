import 'package:calmzone/providers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/constants.dart';
import '../Components/input_field_widget.dart';
import '../Components/social_button_widget.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'personal_data_screen.dart';
import 'dashboard_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.setLoggedIn(true);

      if (mounted) {
        final controller = Provider.of<LoginController>(context, listen: false);
        bool check = await controller.loginUser(
          context,
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (check) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Constants.successColor,
            ),
          );
          await controller.checkUserProfileAndNavigate(context);
          // Navigate based on first-time status
          // if (userProvider.isFirstTime) {
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const PersonalDataScreen(),
          //     ),
          //   );
          // } else {
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => const DashboardScreen()),
          // );
          // }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(controller.errorMessage.toString()),
              backgroundColor: Constants.errorColor,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: Constants.getBackgroundColor(isDark),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Theme toggle button
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      color: Constants.getTextColor(isDark),
                    ),
                    onPressed: () => themeProvider.toggleTheme(),
                  ),
                ),
                const SizedBox(height: 20),
                // CalmZone Logo
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Constants.accentColor,
                              Constants.secondaryColor2,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Constants.accentColor.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/calmzone_logo.png',
                            width: 70,
                            height: 70,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.self_improvement,
                                size: 50,
                                color: Colors.white,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'CalmZone',
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Constants.accentColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your Mental Health Companion',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Constants.getTextSecondaryColor(isDark),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Welcome Title
                Text(
                  'Welcome Back',
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Constants.getTextColor(isDark),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue your journey',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: Constants.getTextSecondaryColor(isDark),
                  ),
                ),
                const SizedBox(height: 48),
                // Email field
                CustomInputField(
                  isDark: isDark,
                  label: 'Email',
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Password field
                CustomInputField(
                  isDark: isDark,
                  label: 'Password',
                  hint: 'Enter your password',
                  isPassword: _obscurePassword,
                  controller: _passwordController,
                  sufixWidget: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Constants.getTextSecondaryColor(isDark),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Constants.accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Login button
                ElevatedButton(
                  onPressed: _handleLogin,
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
                    'Sign In',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Constants.getBorderColor(isDark)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Constants.getTextSecondaryColor(isDark),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Constants.getBorderColor(isDark)),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Social login buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialIconButton(iconPath: 'assets/icons/google.png'),
                    const SizedBox(width: 16),
                    SocialIconButton(iconPath: 'assets/icons/facebook.png'),
                    const SizedBox(width: 16),
                    SocialIconButton(iconPath: 'assets/icons/apple.png'),
                  ],
                ),
                const SizedBox(height: 40),
                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Constants.getTextSecondaryColor(isDark),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Constants.accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
