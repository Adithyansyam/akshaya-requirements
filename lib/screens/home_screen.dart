import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _buildHomeContent() {
    return Container(
      color: const Color(0xFF001F3F), // Navy blue background
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Color(0xFFFFD700), // Gold icon
            ),
            SizedBox(height: 20),
            Text(
              'Home',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700), // Gold text
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Welcome to the Home screen!',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F3F), // Navy blue app bar
        title: const Text(
          'Home',
          style: TextStyle(color: Color(0xFFFFD700)), // Gold text
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFFFD700)), // Gold icons
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Sign out the user
              await FirebaseAuth.instance.signOut();
              // Navigate back to login screen
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: _buildHomeContent(),
    );
  }
}
