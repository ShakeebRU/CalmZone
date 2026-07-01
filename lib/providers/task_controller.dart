// import 'package:calmzone/models/exercise_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class TaskController extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   bool _isLoading = false;
//   String? otp;
//   String? _errorMessage;

//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   // =========================
//   // LOADING
//   // =========================
//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }

//   // =========================
//   // ERROR
//   // =========================
//   void _setError(String? message) {
//     _errorMessage = message;
//     notifyListeners();
//   }

// }
