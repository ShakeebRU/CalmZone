import 'package:calmzone/providers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../providers/theme_provider.dart';

class SocialIconButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback? onTap;

  const SocialIconButton({required this.iconPath, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap:
          onTap ??
          () async {
            // Handle social sign-in
            final controller = Provider.of<LoginController>(
              context,
              listen: false,
            );
            await controller.signInWithGoogle();
          },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          // shape: BoxShape.circle,
          color: Constants.getSurfaceColor(isDark),
          border: Border.all(color: Constants.getBorderColor(isDark), width: 1),
        ),
        child: Row(
          children: [
            Image.asset(iconPath, fit: BoxFit.contain, height: 24, width: 24),
            const SizedBox(width: 8),
            Text(
              "Sign in with Google",
              style: TextStyle(
                color: Constants.getTextColor(isDark),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
