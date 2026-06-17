import 'package:calmzone/screens/AuthGate.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../providers/login_controller.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import 'login_screen.dart';
import 'personal_data_screen.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();

    // Navigate based on login status and first-time status
    Future.delayed(const Duration(seconds: 3), () async {
      if (mounted) {
        await _navigateToNextScreen();
      }
    });
  }

  Future<void> _navigateToNextScreen() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthGate()),
    );
    // final userProvider = Provider.of<UserProvider>(context, listen: false);

    // if (userProvider.isLoggedIn) {
    //   final controller1 = Provider.of<LoginController>(context, listen: false);
    //   await controller1.checkUserLoggedIn();
    //   await controller1.checkUserProfileAndNavigate(context);
    //   // if (userProvider.isFirstTime) {
    //   //   Navigator.pushReplacement(
    //   //     context,
    //   //     MaterialPageRoute(builder: (context) => const PersonalDataScreen()),
    //   //   );
    //   // } else {
    //   //   Navigator.pushReplacement(
    //   //     context,
    //   //     MaterialPageRoute(builder: (context) => const DashboardScreen()),
    //   //   );
    //   // }
    // } else {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const LoginScreen()),
    //   );
    // }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: Constants.getBackgroundColor(isDark),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Constants.getBackgroundColor(isDark),
              Constants.secondaryColor2.withOpacity(isDark ? 0.05 : 0.1),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Container
                      Container(
                        width: 120,
                        height: 120,
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
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/calmzone_logo.png',
                            width: 80,
                            height: 80,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback to icon if logo doesn't exist
                              return Icon(
                                Icons.self_improvement,
                                size: 60,
                                color: Colors.white,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // App Name
                      Text(
                        'CalmZone',
                        style: GoogleFonts.outfit(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Constants.accentColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Tagline
                      Text(
                        'Your Mental Health Companion',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: Constants.getTextSecondaryColor(isDark),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 60),
                      // Loading Indicator
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Constants.accentColor,
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
