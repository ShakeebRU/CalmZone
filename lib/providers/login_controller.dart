import 'package:calmzone/constants/otp_services.dart';
import 'package:calmzone/providers/otp_controller.dart';
import 'package:calmzone/providers/user_provider.dart';
import 'package:calmzone/screens/personal_data_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/dashboard_screen.dart';
import '../screens/first_test_screen.dart';

class LoginController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ FIX FOR google_sign_in 7.2.0
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isLoading = false;
  String? otp;
  String? _errorMessage;
  User? _currentUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  void setUser(User user) => _currentUser = user;

  // =========================
  // LOADING
  // =========================
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // =========================
  // ERROR
  // =========================
  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // =========================
  // EMAIL LOGIN
  // =========================
  Future<bool> loginUser(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      if (_currentUser != null) {
        final doc = await _firestore
            .collection('users')
            .doc(_currentUser!.uid)
            .get();

        if (doc.exists) {
          final data = doc.data()!;
          final cont = Provider.of<UserProvider>(context, listen: false);
          await cont.savePersonalData(
            name: data['name'],
            age: data['age'],
            gender: data['gender'],
            weight: data['weight'],
            height: data['height'],
          );
          await cont.setLoggedIn(true);
          print("Name: ${data['name']}");
          print("Age: ${data['age']}");
          print("Gender: ${data['gender']}");
        }
      }
      _currentUser = credential.user;
      print("user : ${_currentUser?.displayName}");
      notifyListeners();

      return true;
    } on FirebaseAuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // REGISTER USER
  // =========================
  Future<bool> registerUser(
    BuildContext context, {
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      _currentUser = credential.user;

      await _saveUserToFirestore(
        uid: _currentUser!.uid,
        name: name,
        email: email,
        otp: '',
        provider: 'email',
      );
      await Provider.of<EmailOtpController>(
        context,
        listen: false,
      ).sendOtp(user: _currentUser!, email: email);

      return true;
    } on FirebaseAuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // GOOGLE LOGIN (FIXED FOR v7.2.0)
  // =========================
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _setError(null);

      // 1. Create instance (Version 6.x style)
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      // 2. Trigger the flow
      // Returns nullable account, so check for null
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Sign in was cancelled');
      }

      // 3. Get Auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 4. Get tokens (These exist in v6)
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      // 5. Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      // 6. Login to Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      _currentUser = userCredential.user;

      // 7. Save data
      await _saveGoogleUserData();

      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // SAVE GOOGLE USER
  // =========================
  Future<void> _saveGoogleUserData() async {
    if (_currentUser == null) return;

    final doc = _firestore.collection('users').doc(_currentUser!.uid);

    final snapshot = await doc.get();

    if (!snapshot.exists) {
      await doc.set({
        'uid': _currentUser!.uid,
        'name': _currentUser!.displayName ?? '',
        'email': _currentUser!.email ?? '',
        'image': _currentUser!.photoURL ?? '',
        'provider': 'google',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // =========================
  // SAVE EMAIL USER
  // =========================
  Future<void> _saveUserToFirestore({
    required String uid,
    required String name,
    required String email,
    required String otp,
    required String provider,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'otp': otp,
      'otpCreatedAt': DateTime.now().toString(),
      'provider': provider,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // // =========================
  // // RESET PASSWORD
  // // =========================
  // Future<bool> resetPassword(String email) async {
  //   try {
  //     _setLoading(true);
  //     _setError(null);

  //     await _auth.sendPasswordResetEmail(email: email.trim());

  //     return true;
  //   } on FirebaseAuthException catch (e) {
  //     _setError(e.message);
  //     return false;
  //   } finally {
  //     _setLoading(false);
  //   }
  // }
  /// =========================
  /// UPDATE PASSWORD AFTER OTP
  /// =========================
  Future<bool> updatePasswordAfterOtp({
    required String email,
    required String newPassword,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      /// 1. Find user by email
      final query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        _setError("User not found");
        return false;
      }

      final uid = query.docs.first.id;

      /// 2. Get Firebase user
      final user = _auth.currentUser;

      if (user == null) {
        _setError("User not logged in session");
        return false;
      }

      /// 3. IMPORTANT: re-auth required in real apps
      await user.updatePassword(newPassword);

      return true;
    } on FirebaseAuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// =========================
  /// UPDATE USER PROFILE
  /// =========================
  Future<bool> updateUserProfile({
    required String name,
    required int age,
    required String gender,
    required double weight,
    required double height,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      if (_currentUser == null) {
        _setError('User not logged in');
        return false;
      }

      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'name': name.trim(),
        'age': age,
        'gender': gender,
        'weight': weight,
        'height': height,
        'profileCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// =========================
  /// CHECK PROFILE COMPLETION
  /// =========================
  Future<void> checkUserProfileAndNavigate(BuildContext context) async {
    try {
      if (_currentUser == null) {
        return;
      }

      final doc = await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .get();

      if (!doc.exists) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const PersonalDataScreen()),
          (route) => false,
        );
        return;
      }

      final data = doc.data();

      final String? name = data?['name'];

      /// If name is null or empty
      if (name == null || name.trim().isEmpty) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const PersonalDataScreen()),
          (route) => false,
        );
      } else {
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) {
        //       return CalmZoneTestScreen();
        //     },
        //   ),
        //   (route) => false,
        // );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  // =========================
  // CHECK LOGIN
  // =========================
  bool checkUserLoggedIn() {
    final user = _auth.currentUser;

    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    } else {}

    return false;
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();

    _currentUser = null;
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
