import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/constants.dart';
import 'update_profile_screen.dart';

class ProfileViewScreen extends StatelessWidget {
  const ProfileViewScreen({super.key});

  Future<DocumentSnapshot> _getUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Constants.getBackgroundColor(isDark),
      body: FutureBuilder<DocumentSnapshot>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No profile data found"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return CustomScrollView(
            slivers: [
              _buildAppBar(data),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildProfileCard(data, isDark),
                      const SizedBox(height: 20),
                      _buildInfoSection(data, isDark),
                      const SizedBox(height: 30),
                      _buildEditButton(context, data),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildAppBar(Map<String, dynamic> data) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: Constants.accentColor,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          "My Profile",
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Constants.accentColor,
                Constants.accentColor.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
              child: Text(
                (data['name'] ?? 'U')[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 30,
                  color: Constants.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= PROFILE CARD =================
  Widget _buildProfileCard(Map<String, dynamic> data, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Constants.getSurfaceColor(isDark),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            data['name'] ?? '',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            data['email'] ?? '',
            style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ================= INFO SECTION =================
  Widget _buildInfoSection(Map<String, dynamic> data, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Constants.getSurfaceColor(isDark),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _infoTile(Icons.person, "Gender", data['gender']),
          _infoTile(Icons.cake, "Age", "${data['age']} years"),
          _infoTile(Icons.monitor_weight, "Weight", "${data['weight']} kg"),
          _infoTile(Icons.height, "Height", "${data['height']} cm"),
        ],
      ),
    );
  }

  // ================= INFO TILE =================
  Widget _infoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Constants.accentColor.withOpacity(0.1),
            child: Icon(icon, color: Constants.accentColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: GoogleFonts.outfit(fontSize: 15))),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ================= EDIT BUTTON =================
  Widget _buildEditButton(BuildContext context, Map<String, dynamic> data) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.accentColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UpdateProfileScreen(data: data)),
          );
        },
        child: Text(
          "Edit Profile",
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
