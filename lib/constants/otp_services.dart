// import 'dart:math';

// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server/gmail.dart';

// class EmailOtpService {
//   /// =========================
//   /// GENERATE OTP
//   /// =========================
//   static String generateOtp() {
//     Random random = Random();

//     int otp = 100000 + random.nextInt(900000);

//     return otp.toString();
//   }

//   /// =========================
//   /// SEND OTP EMAIL
//   /// =========================
//   static Future<String?> sendOtpEmail({required String recipientEmail}) async {
//     try {
//       /// Your Gmail
//       String username = 'Shakeebwork@gmail.com';

//       /// Gmail App Password
//       String password = 'ogdf grcj iphj obfg';

//       /// Generate OTP
//       String otp = generateOtp();

//       /// SMTP server
//       final smtpServer = gmail(username, password);

//       /// Email message
//       final message = Message()
//         ..from = Address(username, 'CalmZone')
//         ..recipients.add(recipientEmail)
//         ..subject = 'Your OTP Verification Code'
//         ..html =
//             """
//           <h2>CalmZone Verification</h2>
//           <p>Your OTP code is:</p>

//           <h1 style="color:#4CAF50;">$otp</h1>

//           <p>This OTP will expire in 5 minutes.</p>
//         """;

//       /// Send email
//       await send(message, smtpServer);

//       print("Otp send : ${otp}");

//       /// Return generated OTP
//       return otp;
//     } catch (e) {
//       print("Otp error : ${e.toString()}");
//       return null;
//     }
//   }
// }
