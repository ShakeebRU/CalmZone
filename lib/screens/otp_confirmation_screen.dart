import 'package:calmzone/providers/otp_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/constants.dart';
import '../providers/theme_provider.dart';
import 'login_screen.dart';
import 'new_password_screen.dart';
import 'package:provider/provider.dart';

class OTPConfirmationScreen extends StatefulWidget {
  final String email;
  final bool isPasswordReset;

  const OTPConfirmationScreen({
    super.key,
    required this.email,
    this.isPasswordReset = false,
  });

  @override
  State<OTPConfirmationScreen> createState() => _OTPConfirmationScreenState();
}

class _OTPConfirmationScreenState extends State<OTPConfirmationScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  int _resendTimer = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          if (_resendTimer > 0) {
            _resendTimer--;
            _startResendTimer();
          } else {
            _canResend = true;
          }
        });
      }
    });
  }

  void _handleOTPVerification() async {
    String otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length == 6) {
      // Handle OTP verification logic here
      if (widget.isPasswordReset) {
        // final FirebaseAuth _auth = FirebaseAuth.instance;
        await Provider.of<EmailOtpController>(
          context,
          listen: false,
        ).verifyOtp(email: widget.email, enteredOtp: otp);
        // Navigate to new password screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP verified successfully!'),
            backgroundColor: Constants.successColor,
            duration: const Duration(seconds: 1),
          ),
        );
        // Navigate to new password screen
        Future.delayed(const Duration(milliseconds: 800), () async {
          if (mounted) {
            final error = await Provider.of<EmailOtpController>(
              context,
              listen: false,
            ).sendResetPasswordEmail(widget.email);

            if (error == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password reset email sent. Check your inbox.'),
                ),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(error)));
            }

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => NewPasswordScreen(email: widget.email),
            //   ),
            // );
          }
        });
      } else {
        final FirebaseAuth _auth = FirebaseAuth.instance;
        await Provider.of<EmailOtpController>(
          context,
          listen: false,
        ).verifyOtp(email: widget.email, enteredOtp: otp);
        // Navigate to new password screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP verified successfully!'),
            backgroundColor: Constants.successColor,
            duration: const Duration(seconds: 1),
          ),
        );
        // Navigate to home or show success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account verified successfully!'),
            backgroundColor: Constants.successColor,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the complete OTP'),
          backgroundColor: Constants.errorColor,
        ),
      );
    }
  }

  void _handleResendOTP() async {
    if (_canResend) {
      setState(() {
        _resendTimer = 60;
        _canResend = false;
      });

      final FirebaseAuth _auth = FirebaseAuth.instance;

      await Provider.of<EmailOtpController>(
        context,
        listen: false,
      ).sendOtp(email: widget.email, user: _auth.currentUser!);

      _startResendTimer();
      // Resend OTP logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP resent to ${widget.email}'),
          backgroundColor: Constants.successColor,
        ),
      );
    }
  }

  void _onOTPChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: Constants.getBackgroundColor(isDark),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Constants.getTextColor(isDark)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Illustration/Icon
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Constants.accentColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.verified_user,
                    size: 60,
                    color: Constants.accentColor,
                  ),
                ),
                const SizedBox(height: 40),
                // Title
                Text(
                  'Enter Verification Code',
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Constants.getTextColor(isDark),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'We\'ve sent a 6-digit code to\n${widget.email}',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: Constants.getTextSecondaryColor(isDark),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                // OTP input fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      width: 50,
                      height: 60,
                      child: TextFormField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Constants.getTextColor(isDark),
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: Constants.getInputBackgroundColor(isDark),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Constants.getBorderColor(isDark),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Constants.getBorderColor(isDark),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Constants.accentColor,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) => _onOTPChanged(index, value),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Verify button
                ElevatedButton(
                  onPressed: _handleOTPVerification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Verify',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Resend OTP
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive the code? ",
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Constants.getTextSecondaryColor(isDark),
                      ),
                    ),
                    if (_canResend)
                      TextButton(
                        onPressed: _handleResendOTP,
                        child: Text(
                          'Resend',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: Constants.accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      Text(
                        'Resend in ${_resendTimer}s',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Constants.getTextSecondaryColor(isDark),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
