import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EmailOtpController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  String? _generatedOtp;
  String? _error;
  DateTime? _expiryTime;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  /// =========================
  /// GENERATE OTP
  /// =========================
  String _generateOtp() {
    final random = Random();
    final otp = 100000 + random.nextInt(900000);
    return otp.toString();
  }

  /// =========================
  /// SEND OTP EMAIL
  /// =========================
  Future<bool> sendOtp({required String email, required User user}) async {
    try {
      _setLoading(true);
      _setError(null);

      /// Your gmail
      String username = 'Shakeebwork@gmail.com';

      /// Your app password
      String password = 'ogdf grcj iphj obfg';

      final smtpServer = gmail(username, password);

      /// Generate OTP
      _generatedOtp = _generateOtp();

      /// Expiry time
      _expiryTime = DateTime.now().add(const Duration(minutes: 1));

      final message = Message()
        ..from = Address(username, 'CalmZone')
        ..recipients.add(email)
        ..subject = 'Email Verification OTP'
        ..html =
            '''
          <div style="font-family: Arial; padding:20px;">
            <h2>CalmZone Verification</h2>

            <p>Your verification code is:</p>

            <h1 style="color:#4CAF50; letter-spacing:5px;">
              $_generatedOtp
            </h1>

            <p>
              This OTP will expire in 5 minutes.
            </p>
          </div>
        ''';

      await send(message, smtpServer);
      await storeOtpInFirestore(uid: user.uid, otp: _generatedOtp.toString());

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// =========================
  /// STORE OTP IN FIRESTORE
  /// =========================
  Future<bool> storeOtpInFirestore({
    required String uid,
    required String otp,
  }) async {
    try {
      /// Expiry Time
      final DateTime expiryTime = DateTime.now().add(
        const Duration(minutes: 5),
      );

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        /// OTP
        'otp': otp,

        /// OTP Creation Time
        'otpCreatedAt': DateTime.now().toIso8601String(),

        /// Verification Status
        'isVerified': false,
      });

      return true;
    } catch (e) {
      debugPrint('Store OTP Error: $e');

      return false;
    }
  }
  // /// =========================
  // /// VERIFY OTP
  // /// =========================
  // bool verifyOtp(String enteredOtp) {
  //   if (_generatedOtp == null) {
  //     _setError('OTP not generated');
  //     return false;
  //   }

  //   if (_expiryTime == null) {
  //     _setError('OTP expired');
  //     return false;
  //   }

  //   if (DateTime.now().isAfter(_expiryTime!)) {
  //     _setError('OTP expired');
  //     return false;
  //   }

  //   if (enteredOtp.trim() != _generatedOtp) {
  //     _setError('Invalid OTP');
  //     return false;
  //   }

  //   return true;
  // }
  /// =========================
  /// VERIFY OTP FROM FIRESTORE
  /// =========================
  Future<bool> verifyOtp({
    required String email,
    required String enteredOtp,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      /// Find user by email
      final query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email.trim())
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        _setError('User not found');
        return false;
      }

      final userDoc = query.docs.first;
      final data = userDoc.data();

      /// Stored OTP
      final storedOtp = data['otp'];

      if (storedOtp == null) {
        _setError('OTP not found');
        return false;
      }

      /// OTP creation time
      final otpCreatedAt = DateTime.parse(data['otpCreatedAt']);

      /// Check expiry (5 minutes)
      final difference = DateTime.now().difference(otpCreatedAt);

      if (difference.inMinutes > 5) {
        _setError('OTP expired');
        return false;
      }

      /// Verify OTP
      if (enteredOtp.trim() != storedOtp.toString().trim()) {
        _setError('Invalid OTP');
        return false;
      }

      /// Mark verified and remove OTP
      await userDoc.reference.update({
        'isVerified': true,
        'otp': FieldValue.delete(),
        'otpCreatedAt': FieldValue.delete(),
      });

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
  // Future<bool> verifyOtp({
  //   required String uid,
  //   required String enteredOtp,
  // }) async {
  //   try {
  //     _setLoading(true);
  //     _setError(null);

  //     /// Get user document
  //     final doc = await _firestore.collection('users').doc(uid).get();

  //     /// Check user exists
  //     if (!doc.exists) {
  //       _setError('User not found');
  //       return false;
  //     }

  //     final data = doc.data();

  //     if (data == null) {
  //       _setError('Invalid user data');
  //       return false;
  //     }

  //     /// Stored OTP
  //     final storedOtp = data['otp'];

  //     /// OTP creation time
  //     final otpCreatedAt = DateTime.parse(data['otpCreatedAt']);

  //     /// Check expiry (5 minutes)
  //     final difference = DateTime.now().difference(otpCreatedAt);

  //     if (difference.inMinutes > 5) {
  //       _setError('OTP expired');
  //       return false;
  //     }

  //     /// Verify OTP
  //     if (enteredOtp.trim() != storedOtp) {
  //       _setError('Invalid OTP');
  //       return false;
  //     }

  //     /// OPTIONAL:
  //     /// Mark email verified
  //     await _firestore.collection('users').doc(uid).update({
  //       'isVerified': true,

  //       /// Remove OTP after success
  //       'otp': FieldValue.delete(),
  //       'otpCreatedAt': FieldValue.delete(),
  //     });

  //     return true;
  //   } catch (e) {
  //     _setError(e.toString());
  //     return false;
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

  // =========================
  // SEND OTP FUNCTION (FOR FORGOT PASSWORD)
  // =========================
  Future<bool> sendOtpToEmail({required String email}) async {
    try {
      _setLoading(true);
      _setError(null);

      /// 1. find user by email
      final query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        _setError("User not found");
        return false;
      }

      final userDoc = query.docs.first;
      final uid = userDoc.id;

      /// Your gmail
      String username = 'Shakeebwork@gmail.com';

      /// Your app password
      String password = 'ogdf grcj iphj obfg';

      final smtpServer = gmail(username, password);

      /// Generate OTP
      _generatedOtp = _generateOtp();

      /// Expiry time
      _expiryTime = DateTime.now().add(const Duration(minutes: 1));

      final message = Message()
        ..from = Address(username, 'CalmZone')
        ..recipients.add(email)
        ..subject = 'Email Verification OTP'
        ..html =
            '''
          <div style="font-family: Arial; padding:20px;">
            <h2>CalmZone Verification</h2>

            <p>Your verification code is:</p>

            <h1 style="color:#4CAF50; letter-spacing:5px;">
              $_generatedOtp
            </h1>

            <p>
              This OTP will expire in 5 minutes.
            </p>
          </div>
        ''';

      await send(message, smtpServer);
      await storeOtpInFirestore(uid: uid, otp: _generatedOtp.toString());

      // /// 2. generate OTP
      // final otp = _generateOtp();

      // /// 3. expiry time (5 min)
      // final expiry = DateTime.now().add(const Duration(minutes: 5));

      // /// 4. save OTP in Firestore
      // await _firestore.collection('users').doc(uid).update({
      //   'otp': otp,
      //   'otpCreatedAt': DateTime.now().toIso8601String(),
      //   'otpExpiryTime': expiry.toIso8601String(),
      //   'isVerified': false,
      // });

      // /// 5. TODO: SEND EMAIL (you already have mailer OR Firebase extension)
      // debugPrint("OTP sent: $otp to $email");

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> sendResetPasswordEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());

      return null; // Success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No account found with this email.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        default:
          return e.message ?? 'Something went wrong.';
      }
    } catch (e) {
      return e.toString();
    }
  }
}
