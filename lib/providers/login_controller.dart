import 'package:calmzone/constants/otp_services.dart';
import 'package:calmzone/providers/otp_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

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
  Future<bool> loginUser({
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

      _currentUser = credential.user;
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

  // =========================
  // CHECK LOGIN
  // =========================
  bool checkUserLoggedIn() {
    final user = _auth.currentUser;

    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }

    return false;
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();

    _currentUser = null;
    notifyListeners();
  }
}
