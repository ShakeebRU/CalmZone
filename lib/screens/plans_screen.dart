// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import '../constants/constants.dart';
// import '../providers/theme_provider.dart';
// import '../providers/subscription_provider.dart';
// import '../providers/notification_provider.dart';
// import '../models/meal_plan_model.dart';

// class PlansScreen extends StatefulWidget {
//   const PlansScreen({super.key});

//   @override
//   State<PlansScreen> createState() => _PlansScreenState();
// }

// class _PlansScreenState extends State<PlansScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   int _waterIntake = 0;
//   final int _waterGoal = 8; // 8 glasses

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
//     final notificationProvider = Provider.of<NotificationProvider>(context);
//     final isDark = themeProvider.isDarkMode;

//     return Scaffold(
//       backgroundColor: Constants.getBackgroundColor(isDark),
//       appBar: AppBar(
//         backgroundColor: Constants.getSurfaceColor(isDark),
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Constants.getTextColor(isDark)),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Daily Plans',
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
//           isScrollable: true,
//           tabs: const [
//             Tab(text: 'Water'),
//             Tab(text: 'Meals'),
//             Tab(text: 'Exercise'),
//             Tab(text: 'Meditation'),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           // Subscription Status Card
//           if (!subscriptionProvider.hasActiveSubscription)
//             Container(
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Constants.accentColor, Constants.secondaryColor2],
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Start Free Trial',
//                           style: GoogleFonts.outfit(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           'Unlock all premium plans',
//                           style: GoogleFonts.outfit(
//                             fontSize: 12,
//                             color: Colors.white.withOpacity(0.9),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () => _showSubscriptionDialog(
//                       context,
//                       subscriptionProvider,
//                       isDark,
//                     ),
//                     style: TextButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor: Constants.accentColor,
//                     ),
//                     child: Text(
//                       'Subscribe',
//                       style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildWaterTab(isDark, notificationProvider),
//                 _buildMealsTab(isDark, notificationProvider),
//                 _buildWorkoutTab(isDark, notificationProvider),
//                 _buildMeditationTab(isDark, notificationProvider),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWaterTab(
//     bool isDark,
//     NotificationProvider notificationProvider,
//   ) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Water Intake Card
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Constants.getSurfaceColor(isDark),
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Water Intake',
//                           style: GoogleFonts.outfit(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Constants.getTextColor(isDark),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Goal: $_waterGoal glasses',
//                           style: GoogleFonts.outfit(
//                             fontSize: 14,
//                             color: Constants.getTextSecondaryColor(isDark),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Icon(Icons.water_drop, size: 48, color: Colors.blue),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//                 // Progress Circle
//                 SizedBox(
//                   width: 150,
//                   height: 150,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       SizedBox(
//                         width: 150,
//                         height: 150,
//                         child: CircularProgressIndicator(
//                           value: _waterIntake / _waterGoal,
//                           strokeWidth: 12,
//                           backgroundColor: Colors.blue.withOpacity(0.1),
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             Colors.blue,
//                           ),
//                         ),
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             '$_waterIntake',
//                             style: GoogleFonts.outfit(
//                               fontSize: 36,
//                               fontWeight: FontWeight.bold,
//                               color: Constants.getTextColor(isDark),
//                             ),
//                           ),
//                           Text(
//                             'glasses',
//                             style: GoogleFonts.outfit(
//                               fontSize: 14,
//                               color: Constants.getTextSecondaryColor(isDark),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 // Add Water Button
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton.icon(
//                         onPressed: () {
//                           if (_waterIntake < _waterGoal) {
//                             setState(() {
//                               _waterIntake++;
//                             });
//                           }
//                         },
//                         icon: const Icon(Icons.add),
//                         label: const Text('Add Glass'),
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           side: BorderSide(color: Colors.blue),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: OutlinedButton.icon(
//                         onPressed: () {
//                           if (_waterIntake > 0) {
//                             setState(() {
//                               _waterIntake--;
//                             });
//                           }
//                         },
//                         icon: const Icon(Icons.remove),
//                         label: const Text('Remove'),
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           side: BorderSide(color: Colors.blue),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),
//           // Notification Toggle
//           _buildNotificationCard(
//             'Water Reminders',
//             'Auto reminder every hour',
//             Icons.notifications,
//             Colors.blue,
//             notificationProvider.notifications['water']!,
//             (value) => notificationProvider.toggleNotification('water', value),
//             isDark,
//             info: 'Every hour (fixed)',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMealsTab(
//     bool isDark,
//     NotificationProvider notificationProvider,
//   ) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Breakfast Section
//           _buildMealSection(
//             'Breakfast',
//             '🌅',
//             MealPlansData.getBreakfastPlans(),
//             isDark,
//           ),
//           const SizedBox(height: 24),
//           // Lunch Section
//           _buildMealSection(
//             'Lunch',
//             '🍽️',
//             MealPlansData.getLunchPlans(),
//             isDark,
//           ),
//           const SizedBox(height: 24),
//           // Dinner Section
//           _buildMealSection(
//             'Dinner',
//             '🌙',
//             MealPlansData.getDinnerPlans(),
//             isDark,
//           ),
//           const SizedBox(height: 24),
//           // Snacks Section
//           _buildMealSection(
//             'Snacks',
//             '🍎',
//             MealPlansData.getSnacksPlans(),
//             isDark,
//           ),
//           const SizedBox(height: 24),
//           // Notification Settings
//           _buildNotificationCard(
//             'Meal Reminders',
//             'Fixed schedule: Breakfast 8:00, Lunch 13:00, Dinner 19:00',
//             Icons.restaurant,
//             Colors.orange,
//             notificationProvider.notifications['breakfast']!,
//             (value) {
//               notificationProvider.toggleNotification('breakfast', value);
//               notificationProvider.toggleNotification('lunch', value);
//               notificationProvider.toggleNotification('dinner', value);
//             },
//             isDark,
//             info: 'Fixed times (not editable)',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMealSection(
//     String title,
//     String icon,
//     List<MealCategory> categories,
//     bool isDark,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(icon, style: const TextStyle(fontSize: 24)),
//             const SizedBox(width: 8),
//             Text(
//               title,
//               style: GoogleFonts.outfit(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Constants.getTextColor(isDark),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         ...categories.expand(
//           (category) => category.meals.map((meal) {
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 12),
//               child: _buildMealCard(meal, isDark),
//             );
//           }),
//         ),
//       ],
//     );
//   }

//   Widget _buildMealCard(MealPlan meal, bool isDark) {
//     return InkWell(
//       onTap: () => _showMealDetails(meal, isDark),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Constants.getSurfaceColor(isDark),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.network(
//                 meal.imageUrl,
//                 width: 80,
//                 height: 80,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     width: 80,
//                     height: 80,
//                     color: Constants.getInputBackgroundColor(isDark),
//                     child: Icon(Icons.restaurant, color: Constants.accentColor),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     meal.name,
//                     style: GoogleFonts.outfit(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Constants.getTextColor(isDark),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     meal.description,
//                     style: GoogleFonts.outfit(
//                       fontSize: 12,
//                       color: Constants.getTextSecondaryColor(isDark),
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.local_fire_department,
//                         size: 14,
//                         color: Constants.accentColor,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         '${meal.nutrition.calories} cal',
//                         style: GoogleFonts.outfit(
//                           fontSize: 12,
//                           color: Constants.getTextSecondaryColor(isDark),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Icon(
//                         Icons.access_time,
//                         size: 14,
//                         color: Constants.getTextSecondaryColor(isDark),
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         '${meal.prepTime + meal.cookTime} min',
//                         style: GoogleFonts.outfit(
//                           fontSize: 12,
//                           color: Constants.getTextSecondaryColor(isDark),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Icon(
//               Icons.chevron_right,
//               color: Constants.getTextSecondaryColor(isDark),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showMealDetails(MealPlan meal, bool isDark) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.9,
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
//                     // Image
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(16),
//                       child: Image.network(
//                         meal.imageUrl,
//                         width: double.infinity,
//                         height: 200,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             height: 200,
//                             color: Constants.getInputBackgroundColor(isDark),
//                             child: Icon(
//                               Icons.restaurant,
//                               size: 60,
//                               color: Constants.accentColor,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     Text(
//                       meal.name,
//                       style: GoogleFonts.outfit(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Constants.getTextColor(isDark),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       meal.description,
//                       style: GoogleFonts.outfit(
//                         fontSize: 16,
//                         color: Constants.getTextSecondaryColor(isDark),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     // Nutrition Info
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Constants.accentColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           _buildNutritionItem(
//                             'Calories',
//                             '${meal.nutrition.calories}',
//                             Icons.local_fire_department,
//                           ),
//                           _buildNutritionItem(
//                             'Protein',
//                             '${meal.nutrition.protein}g',
//                             Icons.fitness_center,
//                           ),
//                           _buildNutritionItem(
//                             'Carbs',
//                             '${meal.nutrition.carbs}g',
//                             Icons.grain,
//                           ),
//                           _buildNutritionItem(
//                             'Fat',
//                             '${meal.nutrition.fat}g',
//                             Icons.opacity,
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     // Ingredients
//                     Text(
//                       'Ingredients',
//                       style: GoogleFonts.outfit(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Constants.getTextColor(isDark),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     ...meal.ingredients.map((ingredient) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 8),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.circle,
//                               size: 6,
//                               color: Constants.accentColor,
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Text(
//                                 ingredient,
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 14,
//                                   color: Constants.getTextColor(isDark),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }),
//                     const SizedBox(height: 24),
//                     // Recipe
//                     Text(
//                       'Recipe',
//                       style: GoogleFonts.outfit(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Constants.getTextColor(isDark),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Constants.getInputBackgroundColor(isDark),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         meal.recipe,
//                         style: GoogleFonts.outfit(
//                           fontSize: 14,
//                           color: Constants.getTextColor(isDark),
//                           height: 1.6,
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

//   Widget _buildNutritionItem(String label, String value, IconData icon) {
//     return Column(
//       children: [
//         Icon(icon, size: 20, color: Constants.accentColor),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: GoogleFonts.outfit(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Constants.getTextColor(
//               Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
//             ),
//           ),
//         ),
//         Text(
//           label,
//           style: GoogleFonts.outfit(
//             fontSize: 10,
//             color: Constants.getTextSecondaryColor(
//               Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildWorkoutTab(
//     bool isDark,
//     NotificationProvider notificationProvider,
//   ) {
//     final workouts = [
//       {
//         'title': 'Morning Cardio',
//         'duration': '20 min',
//         'imageUrl':
//             'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
//         'description': 'Start your day with energizing cardio exercises',
//       },
//       {
//         'title': 'Strength Training',
//         'duration': '30 min',
//         'imageUrl':
//             'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800',
//         'description': 'Build muscle and strength with this workout',
//       },
//       {
//         'title': 'Yoga Flow',
//         'duration': '25 min',
//         'imageUrl':
//             'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800',
//         'description': 'Flexibility and mindfulness through yoga',
//       },
//     ];

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ...workouts.map((workout) {
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 16),
//               child: _buildWorkoutCard(workout, isDark),
//             );
//           }),
//           const SizedBox(height: 24),
//           _buildNotificationCard(
//             'Workout Reminders',
//             'Get notified for daily workouts',
//             Icons.fitness_center,
//             Colors.red,
//             notificationProvider.notifications['workout']!,
//             (value) =>
//                 notificationProvider.toggleNotification('workout', value),
//             isDark,
//             info:
//                 'Time: ${notificationProvider.notificationTimes['workout']} (customizable in drawer)',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWorkoutCard(Map<String, dynamic> workout, bool isDark) {
//     return Container(
//       padding: const EdgeInsets.all(16),
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
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Image.network(
//               workout['imageUrl'] as String,
//               width: double.infinity,
//               height: 150,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   height: 150,
//                   color: Constants.getInputBackgroundColor(isDark),
//                   child: Icon(
//                     Icons.fitness_center,
//                     size: 60,
//                     color: Constants.accentColor,
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             workout['title'] as String,
//             style: GoogleFonts.outfit(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Constants.getTextColor(isDark),
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             workout['description'] as String,
//             style: GoogleFonts.outfit(
//               fontSize: 14,
//               color: Constants.getTextSecondaryColor(isDark),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Icon(
//                 Icons.access_time,
//                 size: 16,
//                 color: Constants.getTextSecondaryColor(isDark),
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 workout['duration'] as String,
//                 style: GoogleFonts.outfit(
//                   fontSize: 12,
//                   color: Constants.getTextSecondaryColor(isDark),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMeditationTab(
//     bool isDark,
//     NotificationProvider notificationProvider,
//   ) {
//     final meditations = [
//       {
//         'title': 'Morning Meditation',
//         'duration': '10 min',
//         'imageUrl':
//             'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800',
//         'description': 'Start your day with peace and clarity',
//       },
//       {
//         'title': 'Stress Relief',
//         'duration': '15 min',
//         'imageUrl':
//             'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800',
//         'description': 'Release tension and find inner calm',
//       },
//       {
//         'title': 'Sleep Meditation',
//         'duration': '20 min',
//         'imageUrl':
//             'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
//         'description': 'Prepare for restful sleep',
//       },
//     ];

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ...meditations.map((meditation) {
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 16),
//               child: _buildWorkoutCard(meditation, isDark),
//             );
//           }),
//           const SizedBox(height: 24),
//           _buildNotificationCard(
//             'Meditation Reminders',
//             'Get notified for daily meditation',
//             Icons.self_improvement,
//             Colors.purple,
//             notificationProvider.notifications['meditation']!,
//             (value) =>
//                 notificationProvider.toggleNotification('meditation', value),
//             isDark,
//             info:
//                 'Time: ${notificationProvider.notificationTimes['meditation']} (customizable in drawer)',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNotificationCard(
//     String title,
//     String description,
//     IconData icon,
//     Color color,
//     bool enabled,
//     ValueChanged<bool> onToggle,
//     bool isDark, {
//     String? info,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
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
//       child: Row(
//         children: [
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, color: color, size: 24),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: GoogleFonts.outfit(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Constants.getTextColor(isDark),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   description,
//                   style: GoogleFonts.outfit(
//                     fontSize: 12,
//                     color: Constants.getTextSecondaryColor(isDark),
//                   ),
//                 ),
//                 if (enabled && info != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 4),
//                     child: Text(
//                       info,
//                       style: GoogleFonts.outfit(
//                         fontSize: 11,
//                         color: Constants.accentColor,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           Switch(
//             value: enabled,
//             onChanged: onToggle,
//             activeColor: Constants.accentColor,
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSubscriptionDialog(
//     BuildContext context,
//     SubscriptionProvider subscriptionProvider,
//     bool isDark,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: Constants.getSurfaceColor(isDark),
//         title: Text(
//           'Choose Your Plan',
//           style: GoogleFonts.outfit(
//             color: Constants.getTextColor(isDark),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (!subscriptionProvider.trialUsed)
//               _buildPlanOption(
//                 '7-Day Free Trial',
//                 'Then \$9.99/month',
//                 'FREE',
//                 () {
//                   subscriptionProvider.startTrial();
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: const Text('Free trial started!'),
//                       backgroundColor: Constants.successColor,
//                     ),
//                   );
//                 },
//                 isDark,
//                 isHighlighted: true,
//               ),
//             const SizedBox(height: 12),
//             _buildPlanOption('Monthly', 'Billed monthly', '\$9.99/month', () {
//               subscriptionProvider.subscribe(SubscriptionType.monthly);
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: const Text('Monthly subscription activated!'),
//                   backgroundColor: Constants.successColor,
//                 ),
//               );
//             }, isDark),
//             const SizedBox(height: 12),
//             _buildPlanOption(
//               'Yearly',
//               'Save 30%',
//               '\$83.99/year',
//               () {
//                 subscriptionProvider.subscribe(SubscriptionType.yearly);
//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: const Text('Yearly subscription activated!'),
//                     backgroundColor: Constants.successColor,
//                   ),
//                 );
//               },
//               isDark,
//               isHighlighted: true,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               'Cancel',
//               style: GoogleFonts.outfit(
//                 color: Constants.getTextSecondaryColor(isDark),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPlanOption(
//     String title,
//     String subtitle,
//     String price,
//     VoidCallback onTap,
//     bool isDark, {
//     bool isHighlighted = false,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: isHighlighted
//               ? Constants.accentColor.withOpacity(0.1)
//               : Constants.getInputBackgroundColor(isDark),
//           border: Border.all(
//             color: isHighlighted
//                 ? Constants.accentColor
//                 : Constants.getBorderColor(isDark),
//             width: isHighlighted ? 2 : 1,
//           ),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: GoogleFonts.outfit(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Constants.getTextColor(isDark),
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: GoogleFonts.outfit(
//                     fontSize: 12,
//                     color: Constants.getTextSecondaryColor(isDark),
//                   ),
//                 ),
//               ],
//             ),
//             Text(
//               price,
//               style: GoogleFonts.outfit(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Constants.accentColor,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../providers/plans_controller.dart';
import '../providers/theme_provider.dart';
import '../providers/subscription_provider.dart';
import '../providers/notification_provider.dart';
import '../models/meal_plan_model.dart';
import '../models/exercise_model.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int _waterIntake = 0;
  final int _waterGoal = 8;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    // Load Firestore data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlansProvider>().loadAllPlans();
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
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final plansProvider = Provider.of<PlansProvider>(context);

    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: Constants.getBackgroundColor(isDark),
      appBar: AppBar(
        backgroundColor: Constants.getSurfaceColor(isDark),
        elevation: 0,
        title: Text(
          'Daily Plans',
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
          tabs: const [
            Tab(text: 'Water'),
            Tab(text: 'Meals'),
            // Tab(text: 'Exercise'),
            // Tab(text: 'Meditation'),
          ],
        ),
      ),

      body: plansProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (!subscriptionProvider.hasActiveSubscription)
                  _buildSubscriptionBanner(subscriptionProvider, isDark),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildWaterTab(isDark, notificationProvider),
                      _buildMealsTab(
                        isDark,
                        notificationProvider,
                        plansProvider,
                      ),
                      // _buildExerciseTab(
                      //   isDark,
                      //   notificationProvider,
                      //   plansProvider,
                      // ),
                      // _buildMeditationTab(
                      //   isDark,
                      //   notificationProvider,
                      //   plansProvider,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  // =========================================================
  // WATER TAB (UNCHANGED)
  // =========================================================

  Widget _buildWaterTab(
    bool isDark,
    NotificationProvider notificationProvider,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Water Intake Card
          Container(
            padding: const EdgeInsets.all(24),
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Water Intake',
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Constants.getTextColor(isDark),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Goal: $_waterGoal glasses',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: Constants.getTextSecondaryColor(isDark),
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.water_drop, size: 48, color: Colors.blue),
                  ],
                ),
                const SizedBox(height: 24),
                // Progress Circle
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(
                          value: _waterIntake / _waterGoal,
                          strokeWidth: 12,
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_waterIntake',
                            style: GoogleFonts.outfit(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Constants.getTextColor(isDark),
                            ),
                          ),
                          Text(
                            'glasses',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: Constants.getTextSecondaryColor(isDark),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Add Water Button
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          if (_waterIntake < _waterGoal) {
                            setState(() {
                              _waterIntake++;
                            });
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Glass'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          if (_waterIntake > 0) {
                            setState(() {
                              _waterIntake--;
                            });
                          }
                        },
                        icon: const Icon(Icons.remove),
                        label: const Text('Remove'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Notification Toggle
          _buildNotificationCard(
            'Water Reminders',
            'Auto reminder every hour',
            Icons.notifications,
            Colors.blue,
            notificationProvider.notifications['water']!,
            (value) => notificationProvider.toggleNotification('water', value),
            isDark,
            info: 'Every hour (fixed)',
          ),
        ],
      ),
    );
  }

  // =========================================================
  // MEALS TAB (FROM FIRESTORE)
  // =========================================================
  Widget _buildMealsTab(
    bool isDark,
    NotificationProvider notificationProvider,
    PlansProvider provider,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildMealSection("Breakfast", "🌅", provider.breakfast, isDark),
          _buildMealSection("Lunch", "🍽️", provider.lunch, isDark),
          _buildMealSection("Dinner", "🌙", provider.dinner, isDark),
          _buildMealSection("Snacks", "🍎", provider.snacks, isDark),
        ],
      ),
    );
  }

  Widget _buildMealSection(
    String title,
    String icon,
    List<MealPlan> meals,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Constants.getTextColor(isDark),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (meals.isEmpty) const Text("No meals found"),

        ...meals.map((meal) => _buildMealCard(meal, isDark)),
        const SizedBox(height: 20),
      ],
    );
  }

  // Widget _buildMealCard(MealPlan meal, bool isDark) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 12),
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Constants.getSurfaceColor(isDark),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Row(
  //       children: [
  //         Image.network(
  //           meal.imageUrl,
  //           width: 70,
  //           height: 70,
  //           fit: BoxFit.cover,
  //         ),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 meal.name,
  //                 style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
  //               ),
  //               Text(
  //                 meal.description,
  //                 maxLines: 2,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //               Text("${meal.nutrition.calories} cal"),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  void _showMealDetails(MealPlan meal, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Constants.getBackgroundColor(isDark),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: SingleChildScrollView(
                controller: controller,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        meal.imageUrl,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      meal.name,
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      meal.description,
                      style: GoogleFonts.outfit(fontSize: 15),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        _infoChip(
                          Icons.timer,
                          "${meal.prepTime + meal.cookTime} min",
                        ),
                        const SizedBox(width: 10),
                        _infoChip(Icons.restaurant_menu, meal.difficulty),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Text(
                      "Nutrition",
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _nutritionCard(
                          "Calories",
                          "${meal.nutrition.calories}",
                        ),
                        _nutritionCard("Protein", "${meal.nutrition.protein}g"),
                        _nutritionCard("Carbs", "${meal.nutrition.carbs}g"),
                        _nutritionCard("Fat", "${meal.nutrition.fat}g"),
                        _nutritionCard("Fiber", "${meal.nutrition.fiber}g"),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Text(
                      "Ingredients",
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...meal.ingredients.map(
                      (ingredient) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 18,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(ingredient)),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      "Recipe",
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(meal.recipe, style: GoogleFonts.outfit(height: 1.6)),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.green),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }

  Widget _nutritionCard(String title, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.withOpacity(0.1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildMealCard(MealPlan meal, bool isDark) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _showMealDetails(meal, isDark),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Constants.getSurfaceColor(isDark),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                meal.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meal.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${meal.nutrition.calories} cal",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // EXERCISE TAB (FROM FIRESTORE)
  // =========================================================
  Widget _buildExerciseTab(
    bool isDark,
    NotificationProvider notificationProvider,
    PlansProvider provider,
  ) {
    return _buildExerciseList(provider.exercises, isDark, "Exercises");
  }

  Widget _buildMeditationTab(
    bool isDark,
    NotificationProvider notificationProvider,
    PlansProvider provider,
  ) {
    return _buildExerciseList(provider.meditations, isDark, "Meditations");
  }

  Widget _buildExerciseList(
    List<ExercisePlan> items,
    bool isDark,
    String title,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          if (items.isEmpty) const Text("No data found"),

          ...items.map((e) => _buildExerciseCard(e, isDark)),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(ExercisePlan plan, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Constants.getSurfaceColor(isDark),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.network(plan.imageUrl, width: 80, height: 80),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.title,
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                ),
                Text(plan.description),
                Text("${plan.duration} min"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SUBSCRIPTION BANNER
  // =========================================================
  Widget _buildSubscriptionBanner(SubscriptionProvider provider, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.white),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "Unlock premium plans",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => provider.startTrial(),
            child: const Text("Start"),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    String title,
    String description,
    IconData icon,
    Color color,
    bool enabled,
    ValueChanged<bool> onToggle,
    bool isDark, {
    String? info,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Constants.getTextColor(isDark),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Constants.getTextSecondaryColor(isDark),
                  ),
                ),
                if (enabled && info != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      info,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Constants.accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Switch(
            value: enabled,
            onChanged: onToggle,
            activeColor: Constants.accentColor,
          ),
        ],
      ),
    );
  }

  void _showSubscriptionDialog(
    BuildContext context,
    SubscriptionProvider subscriptionProvider,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Constants.getSurfaceColor(isDark),
        title: Text(
          'Choose Your Plan',
          style: GoogleFonts.outfit(
            color: Constants.getTextColor(isDark),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!subscriptionProvider.trialUsed)
              _buildPlanOption(
                '7-Day Free Trial',
                'Then \$9.99/month',
                'FREE',
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
                isHighlighted: true,
              ),
            const SizedBox(height: 12),
            _buildPlanOption('Monthly', 'Billed monthly', '\$9.99/month', () {
              subscriptionProvider.subscribe(SubscriptionType.monthly);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Monthly subscription activated!'),
                  backgroundColor: Constants.successColor,
                ),
              );
            }, isDark),
            const SizedBox(height: 12),
            _buildPlanOption(
              'Yearly',
              'Save 30%',
              '\$83.99/year',
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
        ],
      ),
    );
  }

  Widget _buildPlanOption(
    String title,
    String subtitle,
    String price,
    VoidCallback onTap,
    bool isDark, {
    bool isHighlighted = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isHighlighted
              ? Constants.accentColor.withOpacity(0.1)
              : Constants.getInputBackgroundColor(isDark),
          border: Border.all(
            color: isHighlighted
                ? Constants.accentColor
                : Constants.getBorderColor(isDark),
            width: isHighlighted ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
}
