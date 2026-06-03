import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/exercise_model.dart';
import '../models/meal_plan_model.dart';

class PlansProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // =========================
  // LOADING STATE
  // =========================
  bool isLoading = false;

  // =========================
  // DATA LISTS
  // =========================
  List<ExercisePlan> exercises = [];
  List<ExercisePlan> meditations = [];

  List<MealPlan> breakfast = [];
  List<MealPlan> lunch = [];
  List<MealPlan> dinner = [];
  List<MealPlan> snacks = [];

  bool get loading => isLoading;

  // =========================
  // INIT ALL DATA
  // =========================
  Future<void> loadAllPlans() async {
    isLoading = true;
    notifyListeners();

    await Future.wait([getExercises(), getMeditations(), getDietPlans()]);

    isLoading = false;
    notifyListeners();
  }

  // =========================================================
  // EXERCISES
  // =========================================================
  Future<void> getExercises() async {
    try {
      final snap = await _db
          .collection("plans")
          .doc("exercises")
          .collection("items")
          .get();

      exercises = snap.docs.map((e) => ExercisePlan.fromMap(e.data())).toList();
    } catch (e) {
      debugPrint("Error loading exercises: $e");
    }
  }

  // =========================================================
  // MEDITATIONS
  // =========================================================
  Future<void> getMeditations() async {
    try {
      final snap = await _db
          .collection("plans")
          .doc("meditations")
          .collection("items")
          .get();

      meditations = snap.docs
          .map((e) => ExercisePlan.fromMap(e.data()))
          .toList();
    } catch (e) {
      debugPrint("Error loading meditations: $e");
    }
  }

  // =========================================================
  // DIET PLANS (MEALS)
  // =========================================================
  Future<void> getDietPlans() async {
    try {
      await Future.wait([
        _getMeals("breakfast"),
        _getMeals("lunch"),
        _getMeals("dinner"),
        _getMeals("snacks"),
      ]);
    } catch (e) {
      debugPrint("Error loading diet plans: $e");
    }
  }

  Future<void> _getMeals(String category) async {
    final snap = await _db
        .collection("plans")
        .doc("meals")
        .collection(category)
        .get();

    final data = snap.docs.map((e) => MealPlan.fromMap(e.data())).toList();

    switch (category) {
      case "breakfast":
        breakfast = data;
        break;
      case "lunch":
        lunch = data;
        break;
      case "dinner":
        dinner = data;
        break;
      case "snacks":
        snacks = data;
        break;
    }
  }

  // =========================================================
  // REFRESH ALL
  // =========================================================
  Future<void> refresh() async {
    await loadAllPlans();
  }
}
