import 'package:calmzone/providers/login_controller.dart';
import 'package:calmzone/screens/dashboard_screen.dart';
import 'package:calmzone/screens/login_screen.dart';
import 'package:calmzone/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        if (snapshot.hasData && snapshot.data != null) {
          Provider.of<LoginController>(
            context,
            listen: false,
          ).setUser(snapshot.data!);
          return const DashboardScreen(); // USER IS LOGGED IN
        }
        return const LoginScreen(); // USER NOT LOGGED IN
      },
    );
  }
}
