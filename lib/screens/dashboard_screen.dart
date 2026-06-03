import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/constants.dart';
import '../models/exercise_model.dart';
import '../models/meal_plan_model.dart';
import '../providers/plans_controller.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../providers/subscription_provider.dart';
import '../providers/notification_provider.dart';
import '../widgets/monthly_progress_chart.dart';
import 'chatbot_screen.dart';
import 'camera_screen.dart';
import 'exercises_screen.dart';
import 'plans_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlansProvider>().loadAllPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return AdvancedDrawer(
      controller: _advancedDrawerController,
      openRatio: 0.7,
      animationDuration: const Duration(milliseconds: 300),
      backdropColor: Constants.getBackgroundColor(isDark).withOpacity(0.9),
      drawer: _buildDrawer(
        context,
        isDark,
        themeProvider,
        userProvider,
        subscriptionProvider,
        notificationProvider,
      ),
      child: Scaffold(
        backgroundColor: Constants.getBackgroundColor(isDark),
        appBar: AppBar(
          backgroundColor: Constants.getSurfaceColor(isDark),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            color: Constants.getTextColor(isDark),
            onPressed: _handleMenuButtonPressed,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Constants.getTextSecondaryColor(isDark),
                ),
              ),
              Text(
                userProvider.name ?? 'User',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Constants.getTextColor(isDark),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: Constants.getTextColor(isDark),
              ),
              onPressed: () => themeProvider.toggleTheme(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Monthly Progress Chart
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Constants.getSurfaceColor(isDark),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Monthly Progress',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Constants.getTextColor(isDark),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Constants.accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'This Month',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Constants.accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: MonthlyProgressChart(isDark: isDark),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Menu Buttons Grid
              Text(
                'Features',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Constants.getTextColor(isDark),
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildMenuCard(
                    context,
                    'Chat Bot',
                    'Talk with AI',
                    Icons.chat_bubble_outline,
                    Constants.accentColor,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatbotScreen(),
                        ),
                      );
                    },
                    isDark,
                  ),
                  _buildMenuCard(
                    context,
                    'Camera',
                    'Detect Emotions',
                    Icons.camera_alt_outlined,
                    Colors.blue,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CameraScreen(),
                        ),
                      );
                    },
                    isDark,
                  ),
                  _buildMenuCard(
                    context,
                    'Exercises',
                    'Daily Workouts',
                    Icons.fitness_center,
                    Colors.purple,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ExercisesScreen(),
                        ),
                      );
                    },
                    isDark,
                  ),
                  _buildMenuCard(
                    context,
                    'Plans',
                    'Diet & Routine',
                    Icons.calendar_today,
                    Colors.green,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlansScreen(),
                        ),
                      );
                    },
                    isDark,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
    bool isDark,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Constants.getSurfaceColor(isDark),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Constants.getTextColor(isDark),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: Constants.getTextSecondaryColor(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    bool isDark,
    ThemeProvider themeProvider,
    UserProvider userProvider,
    SubscriptionProvider subscriptionProvider,
    NotificationProvider notificationProvider,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // User Profile
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
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
                    ),
                    child: Center(
                      child: Text(
                        userProvider.name?.substring(0, 1).toUpperCase() ?? 'U',
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userProvider.name ?? 'User',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Constants.getTextColor(isDark),
                          ),
                        ),
                        Text(
                          '${userProvider.age ?? 'N/A'} years old',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: Constants.getTextSecondaryColor(isDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Subscription Status Card
              _buildSubscriptionStatusCard(
                context,
                subscriptionProvider,
                isDark,
              ),
              const SizedBox(height: 30),
              // Notification Settings
              _buildDrawerItem(
                context,
                'Notification Settings',
                Icons.notifications_active_outlined,
                () {
                  _showNotificationSettingsDialog(
                    context,
                    isDark,
                    notificationProvider,
                  );
                },
                isDark,
              ),
              const SizedBox(height: 10),
              // Subscription Plans
              _buildDrawerItem(
                context,
                'Subscription Plans',
                Icons.card_membership,
                () {
                  _showSubscriptionPlansDialog(
                    context,
                    subscriptionProvider,
                    isDark,
                  );
                },
                isDark,
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              // Menu Items
              _buildDrawerItem(
                context,
                'Feedback',
                Icons.feedback_outlined,
                () {
                  _showFeedbackDialog(context, isDark);
                },
                isDark,
              ),
              _buildDrawerItem(context, 'Rate Us', Icons.star_outline, () {
                _rateApp(context);
              }, isDark),
              _buildDrawerItem(
                context,
                'Permissions',
                Icons.security_outlined,
                () {
                  _showPermissionsDialog(context, isDark);
                },
                isDark,
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              _buildDrawerItem(
                context,
                'Logout',
                Icons.logout,
                () {
                  _handleLogout(context, userProvider);
                },
                isDark,
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionStatusCard(
    BuildContext context,
    SubscriptionProvider subscriptionProvider,
    bool isDark,
  ) {
    String statusText;
    Color statusColor;
    IconData statusIcon;

    if (subscriptionProvider.hasActiveSubscription) {
      if (subscriptionProvider.subscriptionType == SubscriptionType.trial) {
        final daysLeft = subscriptionProvider.getRemainingTrialDays();
        statusText = 'Trial: $daysLeft days left';
        statusColor = Constants.accentColor;
        statusIcon = Icons.star;
      } else if (subscriptionProvider.subscriptionType ==
          SubscriptionType.monthly) {
        statusText = 'Monthly Plan Active';
        statusColor = Constants.successColor;
        statusIcon = Icons.check_circle;
      } else {
        statusText = 'Yearly Plan Active';
        statusColor = Constants.successColor;
        statusIcon = Icons.check_circle;
      }
    } else {
      statusText = 'No Active Plan';
      statusColor = Constants.getTextSecondaryColor(isDark);
      statusIcon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Constants.getSurfaceColor(isDark),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subscription',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Constants.getTextSecondaryColor(isDark),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
    bool isDark, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: () {
        _advancedDrawerController.hideDrawer();
        Future.delayed(const Duration(milliseconds: 300), onTap);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive
                  ? Constants.errorColor
                  : Constants.getTextColor(isDark),
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 16,
                color: isDestructive
                    ? Constants.errorColor
                    : Constants.getTextColor(isDark),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Constants.getSurfaceColor(isDark),
        title: Text(
          'Feedback',
          style: GoogleFonts.outfit(
            color: Constants.getTextColor(isDark),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          maxLines: 5,
          style: GoogleFonts.outfit(color: Constants.getTextColor(isDark)),
          decoration: InputDecoration(
            hintText: 'Share your thoughts...',
            hintStyle: GoogleFonts.outfit(
              color: Constants.getTextSecondaryColor(isDark),
            ),
            filled: true,
            fillColor: Constants.getInputBackgroundColor(isDark),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Constants.getBorderColor(isDark)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.outfit(
                color: Constants.getTextSecondaryColor(isDark),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Thank you for your feedback!'),
                  backgroundColor: Constants.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Constants.accentColor,
            ),
            child: Text(
              'Submit',
              style: GoogleFonts.outfit(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _rateApp(BuildContext context) async {
    const url =
        'https://play.google.com/store/apps/details?id=com.calmzone.app';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open app store')));
    }
  }

  void _showPermissionsDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Constants.getSurfaceColor(isDark),
        title: Text(
          'App Permissions',
          style: GoogleFonts.outfit(
            color: Constants.getTextColor(isDark),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPermissionItem('Camera', 'For emotion detection', isDark),
            _buildPermissionItem('Storage', 'For saving media', isDark),
            _buildPermissionItem('Notifications', 'For reminders', isDark),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Constants.accentColor,
            ),
            child: Text('OK', style: GoogleFonts.outfit(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettingsDialog(
    BuildContext context,
    bool isDark,
    NotificationProvider notificationProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Constants.getSurfaceColor(isDark),
        title: Text(
          'Notification Settings',
          style: GoogleFonts.outfit(
            color: Constants.getTextColor(isDark),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNotificationToggleRow(
                context: context,
                title: 'Water',
                subtitle: 'Auto reminder every hour (fixed)',
                icon: Icons.water_drop,
                color: Colors.blue,
                isOn: notificationProvider.notifications['water']!,
                onChanged: (value) =>
                    notificationProvider.toggleNotification('water', value),
                isDark: isDark,
                trailingText: 'Hourly',
                editable: false,
              ),
              const SizedBox(height: 12),
              _buildNotificationToggleRow(
                context: context,
                title: 'Meals',
                subtitle:
                    'Fixed times: Breakfast 8:00, Lunch 13:00, Dinner 19:00',
                icon: Icons.restaurant,
                color: Colors.orange,
                isOn: notificationProvider.notifications['breakfast']!,
                onChanged: (value) {
                  notificationProvider.toggleNotification('breakfast', value);
                  notificationProvider.toggleNotification('lunch', value);
                  notificationProvider.toggleNotification('dinner', value);
                },
                isDark: isDark,
                trailingText: 'Fixed',
                editable: false,
              ),
              const SizedBox(height: 12),
              _buildNotificationToggleRow(
                context: context,
                title: 'Workout',
                subtitle: 'Customize daily workout reminder',
                icon: Icons.fitness_center,
                color: Colors.red,
                isOn: notificationProvider.notifications['workout']!,
                onChanged: (value) =>
                    notificationProvider.toggleNotification('workout', value),
                isDark: isDark,
                trailingText: _formatTime(
                  notificationProvider.notificationTimes['workout']!,
                ),
                onTapTrailing: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _parseTime(
                      notificationProvider.notificationTimes['workout']!,
                    ),
                  );
                  if (picked != null) {
                    notificationProvider.setNotificationTime(
                      'workout',
                      _formatTime24(picked),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              _buildNotificationToggleRow(
                context: context,
                title: 'Meditation',
                subtitle: 'Customize daily meditation reminder',
                icon: Icons.self_improvement,
                color: Colors.purple,
                isOn: notificationProvider.notifications['meditation']!,
                onChanged: (value) => notificationProvider.toggleNotification(
                  'meditation',
                  value,
                ),
                isDark: isDark,
                trailingText: _formatTime(
                  notificationProvider.notificationTimes['meditation']!,
                ),
                onTapTrailing: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _parseTime(
                      notificationProvider.notificationTimes['meditation']!,
                    ),
                  );
                  if (picked != null) {
                    notificationProvider.setNotificationTime(
                      'meditation',
                      _formatTime24(picked),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.outfit(
                color: Constants.getTextSecondaryColor(isDark),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggleRow({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isOn,
    required ValueChanged<bool> onChanged,
    required bool isDark,
    String? trailingText,
    VoidCallback? onTapTrailing,
    bool editable = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Constants.getSurfaceColor(isDark),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Constants.getBorderColor(isDark)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Constants.getTextColor(isDark),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Constants.getTextSecondaryColor(isDark),
                  ),
                ),
              ],
            ),
          ),
          if (trailingText != null)
            InkWell(
              onTap: editable ? onTapTrailing : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    Text(
                      trailingText,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: editable
                            ? Constants.accentColor
                            : Constants.getTextSecondaryColor(isDark),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (editable) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.edit, size: 14, color: Constants.accentColor),
                    ],
                  ],
                ),
              ),
            ),
          Switch(
            value: isOn,
            onChanged: onChanged,
            activeColor: Constants.accentColor,
          ),
        ],
      ),
    );
  }

  String _formatTime(String time) {
    if (time == 'HOURLY' || time.isEmpty) return 'Hourly';
    return time;
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    if (parts.length == 2) {
      final hour = int.tryParse(parts[0]) ?? 8;
      final minute = int.tryParse(parts[1]) ?? 0;
      return TimeOfDay(hour: hour, minute: minute);
    }
    return const TimeOfDay(hour: 8, minute: 0);
  }

  String _formatTime24(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  Widget _buildPermissionItem(String title, String description, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Constants.successColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: Constants.getTextColor(isDark),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.outfit(
                    color: Constants.getTextSecondaryColor(isDark),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSubscriptionPlansDialog(
    BuildContext context,
    SubscriptionProvider subscriptionProvider,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Constants.getSurfaceColor(isDark),
        title: Text(
          'Subscription Plans',
          style: GoogleFonts.outfit(
            color: Constants.getTextColor(isDark),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!subscriptionProvider.trialUsed)
                _buildPlanCardInDialog(
                  '7-Day Free Trial',
                  'Try all premium features',
                  'FREE',
                  subscriptionProvider.subscriptionType ==
                      SubscriptionType.trial,
                  () {
                    subscriptionProvider.startTrial();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Free trial started!'),
                        backgroundColor: Constants.successColor,
                      ),
                    );
                  },
                  isDark,
                ),
              const SizedBox(height: 12),
              _buildPlanCardInDialog(
                'Monthly Plan',
                'Billed monthly, cancel anytime',
                '\$9.99/month',
                subscriptionProvider.subscriptionType ==
                    SubscriptionType.monthly,
                () {
                  subscriptionProvider.subscribe(SubscriptionType.monthly);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Monthly subscription activated!'),
                      backgroundColor: Constants.successColor,
                    ),
                  );
                },
                isDark,
              ),
              const SizedBox(height: 12),
              _buildPlanCardInDialog(
                'Yearly Plan',
                'Save 30%, best value',
                '\$83.99/year',
                subscriptionProvider.subscriptionType ==
                    SubscriptionType.yearly,
                () {
                  subscriptionProvider.subscribe(SubscriptionType.yearly);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Yearly subscription activated!'),
                      backgroundColor: Constants.successColor,
                    ),
                  );
                },
                isDark,
                isHighlighted: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.outfit(
                color: Constants.getTextSecondaryColor(isDark),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCardInDialog(
    String title,
    String subtitle,
    String price,
    bool isActive,
    VoidCallback onTap,
    bool isDark, {
    bool isHighlighted = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive
              ? Constants.accentColor.withOpacity(0.1)
              : isHighlighted
              ? Constants.accentColor.withOpacity(0.05)
              : Constants.getInputBackgroundColor(isDark),
          border: Border.all(
            color: isActive
                ? Constants.accentColor
                : isHighlighted
                ? Constants.accentColor.withOpacity(0.5)
                : Constants.getBorderColor(isDark),
            width: isActive || isHighlighted ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Constants.getTextColor(isDark),
                        ),
                      ),
                      if (isActive) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Constants.successColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Active',
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Constants.getTextSecondaryColor(isDark),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Constants.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context, UserProvider userProvider) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Constants.getSurfaceColor(
          Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
        ),
        title: Text(
          'Logout',
          style: GoogleFonts.outfit(
            color: Constants.getTextColor(
              Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.outfit(
            color: Constants.getTextColor(
              Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Constants.errorColor,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await userProvider.logout();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }
}
