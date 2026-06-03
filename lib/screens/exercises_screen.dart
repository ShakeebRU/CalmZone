// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import '../constants/constants.dart';
// import '../providers/theme_provider.dart';

// class ExercisesScreen extends StatefulWidget {
//   const ExercisesScreen({super.key});

//   @override
//   State<ExercisesScreen> createState() => _ExercisesScreenState();
// }

// class _ExercisesScreenState extends State<ExercisesScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final isDark = themeProvider.isDarkMode;

//     return Scaffold(
//       backgroundColor: Constants.getBackgroundColor(isDark),
//       appBar: AppBar(
//         backgroundColor: Constants.getSurfaceColor(isDark),
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: Constants.getTextColor(isDark),
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Exercises & Meditations',
//           style: GoogleFonts.outfit(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Constants.getTextColor(isDark),
//           ),
//         ),
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: Constants.accentColor,
//           labelColor: Constants.accentColor,
//           unselectedLabelColor: Constants.getTextSecondaryColor(isDark),
//           labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600),
//           tabs: const [
//             Tab(text: 'Exercises'),
//             Tab(text: 'Meditations'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildExercisesTab(isDark),
//           _buildMeditationsTab(isDark),
//         ],
//       ),
//     );
//   }

//   Widget _buildExercisesTab(bool isDark) {
//     final exercises = [
//       {
//         'title': 'Morning Stretch',
//         'duration': '10 min',
//         'difficulty': 'Beginner',
//         'image': Icons.fitness_center,
//         'color': Colors.blue,
//         'imageUrl': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
//         'videoUrl': 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
//       },
//       {
//         'title': 'Cardio Workout',
//         'duration': '20 min',
//         'difficulty': 'Intermediate',
//         'image': Icons.directions_run,
//         'color': Colors.red,
//         'imageUrl': 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800',
//         'videoUrl': 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_2mb.mp4',
//       },
//       {
//         'title': 'Strength Training',
//         'duration': '30 min',
//         'difficulty': 'Advanced',
//         'image': Icons.sports_gymnastics,
//         'color': Colors.purple,
//         'imageUrl': 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800',
//         'videoUrl': 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_5mb.mp4',
//       },
//       {
//         'title': 'Yoga Flow',
//         'duration': '25 min',
//         'difficulty': 'Intermediate',
//         'image': Icons.self_improvement,
//         'color': Colors.green,
//         'imageUrl': 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800',
//         'videoUrl': 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
//       },
//     ];

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: exercises.length,
//       itemBuilder: (context, index) {
//         final exercise = exercises[index];
//         return _buildExerciseCard(exercise, isDark, () {
//           _showExerciseDetails(context, exercise, isDark);
//         });
//       },
//     );
//   }

//   Widget _buildMeditationsTab(bool isDark) {
//     final meditations = [
//       {
//         'title': 'Breathing Exercise',
//         'duration': '5 min',
//         'type': 'Guided',
//         'image': Icons.air,
//         'color': Colors.teal,
//         'imageUrl': 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800',
//         'videoUrl': 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
//       },
//       {
//         'title': 'Mindfulness',
//         'duration': '15 min',
//         'type': 'Guided',
//         'image': Icons.psychology,
//         'color': Colors.indigo,
//         'imageUrl': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800',
//         'videoUrl': 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_2mb.mp4',
//       },
//       {
//         'title': 'Sleep Meditation',
//         'duration': '20 min',
//         'type': 'Guided',
//         'image': Icons.bedtime,
//         'color': Colors.deepPurple,
//         'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
//         'videoUrl': 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_5mb.mp4',
//       },
//       {
//         'title': 'Stress Relief',
//         'duration': '10 min',
//         'type': 'Guided',
//         'image': Icons.spa,
//         'color': Colors.pink,
//         'imageUrl': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800',
//         'videoUrl': 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
//       },
//     ];

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: meditations.length,
//       itemBuilder: (context, index) {
//         final meditation = meditations[index];
//         return _buildExerciseCard(meditation, isDark, () {
//           _showExerciseDetails(context, meditation, isDark);
//         });
//       },
//     );
//   }

//   Widget _buildExerciseCard(Map<String, dynamic> exercise, bool isDark, VoidCallback onTap) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Constants.getSurfaceColor(isDark),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   color: (exercise['color'] as Color).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   exercise['image'] as IconData,
//                   color: exercise['color'] as Color,
//                   size: 30,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       exercise['title'] as String,
//                       style: GoogleFonts.outfit(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Constants.getTextColor(isDark),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.access_time,
//                           size: 14,
//                           color: Constants.getTextSecondaryColor(isDark),
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           exercise['duration'] as String,
//                           style: GoogleFonts.outfit(
//                             fontSize: 12,
//                             color: Constants.getTextSecondaryColor(isDark),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Constants.accentColor.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             exercise['difficulty'] ?? exercise['type'] as String,
//                             style: GoogleFonts.outfit(
//                               fontSize: 10,
//                               color: Constants.accentColor,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(
//                 Icons.play_circle_filled,
//                 color: Constants.accentColor,
//                 size: 40,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showExerciseDetails(BuildContext context, Map<String, dynamic> exercise, bool isDark) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.8,
//         decoration: BoxDecoration(
//           color: Constants.getSurfaceColor(isDark),
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         child: Column(
//           children: [
//             Container(
//               margin: const EdgeInsets.only(top: 12),
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Constants.getBorderColor(isDark),
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Image/Video Preview
//                     if (exercise['imageUrl'] != null)
//                       Container(
//                         width: double.infinity,
//                         height: 200,
//                         margin: const EdgeInsets.only(bottom: 20),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           color: Constants.getInputBackgroundColor(isDark),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(16),
//                           child: Image.network(
//                             exercise['imageUrl'] as String,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Container(
//                                 color: (exercise['color'] as Color).withOpacity(0.1),
//                                 child: Icon(
//                                   exercise['image'] as IconData,
//                                   color: exercise['color'] as Color,
//                                   size: 60,
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     Row(
//                       children: [
//                         Container(
//                           width: 80,
//                           height: 80,
//                           decoration: BoxDecoration(
//                             color: (exercise['color'] as Color).withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: Icon(
//                             exercise['image'] as IconData,
//                             color: exercise['color'] as Color,
//                             size: 40,
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 exercise['title'] as String,
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: Constants.getTextColor(isDark),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.access_time,
//                                     size: 16,
//                                     color: Constants.getTextSecondaryColor(isDark),
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     exercise['duration'] as String,
//                                     style: GoogleFonts.outfit(
//                                       fontSize: 14,
//                                       color: Constants.getTextSecondaryColor(isDark),
//                                     ),
//                                   ),
//                                   if (exercise['videoUrl'] != null) ...[
//                                     const SizedBox(width: 16),
//                                     Icon(
//                                       Icons.video_library,
//                                       size: 16,
//                                       color: Constants.accentColor,
//                                     ),
//                                     const SizedBox(width: 4),
//                                     Text(
//                                       'Video Available',
//                                       style: GoogleFonts.outfit(
//                                         fontSize: 12,
//                                         color: Constants.accentColor,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ],
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 32),
//                     Text(
//                       'Instructions',
//                       style: GoogleFonts.outfit(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Constants.getTextColor(isDark),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     ...List.generate(5, (index) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 12),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 24,
//                               height: 24,
//                               decoration: BoxDecoration(
//                                 color: Constants.accentColor.withOpacity(0.1),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   '${index + 1}',
//                                   style: GoogleFonts.outfit(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold,
//                                     color: Constants.accentColor,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Text(
//                                 'Step ${index + 1}: Follow the guided instructions carefully. Focus on your breathing and maintain proper form throughout the exercise.',
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 14,
//                                   color: Constants.getTextColor(isDark),
//                                   height: 1.5,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }),
//                     const SizedBox(height: 32),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text('Starting ${exercise['title']}...'),
//                               backgroundColor: Constants.successColor,
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Constants.accentColor,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(Icons.play_arrow),
//                             const SizedBox(width: 8),
//                             Text(
//                               'Start Exercise',
//                               style: GoogleFonts.outfit(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:calmzone/providers/plans_controller.dart';
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
