import 'package:calmzone/providers/login_controller.dart';
import 'package:calmzone/providers/plans_controller.dart';
import 'package:calmzone/providers/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../models/exercise_model.dart';
import '../providers/theme_provider.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load data
    Future.microtask(() {
      final provider = Provider.of<PlansProvider>(context, listen: false);
      provider.getExercises();
      provider.getMeditations();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: Constants.getBackgroundColor(isDark),
      appBar: AppBar(
        backgroundColor: Constants.getSurfaceColor(isDark),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Constants.getTextColor(isDark)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Exercises & Meditations',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Constants.getTextColor(isDark),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Constants.accentColor,
          labelColor: Constants.accentColor,
          unselectedLabelColor: Constants.getTextSecondaryColor(isDark),
          labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Exercises'),
            Tab(text: 'Meditations'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildExercisesTab(isDark), _buildMeditationsTab(isDark)],
      ),
    );
  }

  // =========================
  // EXERCISES TAB
  // =========================
  Widget _buildExercisesTab(bool isDark) {
    return Consumer<PlansProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.exercises.isEmpty) {
          return const Center(child: Text("No exercises found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.exercises.length,
          itemBuilder: (context, index) {
            final exercise = provider.exercises[index];

            return _buildExerciseCard(
              exercise,
              isDark,
              () => _showDetails(context, exercise, isDark),
              icon: Icons.fitness_center,
              color: Colors.blue,
            );
          },
        );
      },
    );
  }

  // =========================
  // MEDITATIONS TAB
  // =========================
  Widget _buildMeditationsTab(bool isDark) {
    return Consumer<PlansProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.meditations.isEmpty) {
          return const Center(child: Text("No meditations found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.meditations.length,
          itemBuilder: (context, index) {
            final meditation = provider.meditations[index];

            return _buildExerciseCard(
              meditation,
              isDark,
              () => _showDetails(context, meditation, isDark),
              icon: Icons.self_improvement,
              color: Colors.teal,
            );
          },
        );
      },
    );
  }

  // =========================
  // CARD UI
  // =========================
  Widget _buildExerciseCard(
    ExercisePlan plan,
    bool isDark,
    VoidCallback onTap, {
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.title,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Constants.getTextColor(isDark),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Constants.getTextSecondaryColor(isDark),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          plan.duration,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: Constants.getTextSecondaryColor(isDark),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Constants.accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            plan.difficulty,
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              color: Constants.accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.play_circle_filled,
                color: Constants.accentColor,
                size: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // DETAILS BOTTOM SHEET
  // =========================
  void _showDetails(BuildContext context, ExercisePlan plan, bool isDark) {
    final taskController = Provider.of<LoginController>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Constants.getSurfaceColor(isDark),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (plan.imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            plan.imageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 20),

                      Text(
                        plan.title,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Constants.getTextColor(isDark),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Instructions",
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      ...plan.instructions.asMap().entries.map((e) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Constants.accentColor
                                    .withOpacity(0.1),
                                child: Text(
                                  "${e.key + 1}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  e.value,
                                  style: GoogleFonts.outfit(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 30),
                      FutureBuilder<bool>(
                        future: taskController.isExerciseCompletedToday(
                          plan.id,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final isCompleted = snapshot.data ?? false;

                          if (isCompleted) {
                            return const Text(
                              "You have already completed this workout today.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }

                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final loginController = context
                                    .read<LoginController>();

                                final success = await loginController
                                    .saveCompletedWorkout(plan);

                                if (context.mounted) {
                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        success
                                            ? "Workout saved successfully!"
                                            : "Failed to save workout",
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.check_circle),
                              label: const Text("Mark as Completed"),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
