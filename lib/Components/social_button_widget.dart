import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../providers/theme_provider.dart';

class SocialIconButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback? onTap;

  const SocialIconButton({
    required this.iconPath,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap ?? () {
        // Handle social sign-in
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Constants.getSurfaceColor(isDark),
          border: Border.all(
            color: Constants.getBorderColor(isDark),
            width: 1,
          ),
        ),
        child: Image.asset(
          iconPath,
          height: 24,
          width: 24,
          errorBuilder: (context, error, stackTrace) {
            // Fallback icon if image doesn't exist
            return Icon(
              Icons.account_circle,
              size: 24,
              color: Constants.getTextSecondaryColor(isDark),
            );
          },
        ),
      ),
    );
  }
}
