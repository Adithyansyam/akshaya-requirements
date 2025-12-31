import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import '../widgets/homepage_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final user = FirebaseAuth.instance.currentUser;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildHomeContent() {
    return Container(
      color: const Color(0xFF001F3F),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Color(0xFFFFD700),
            ),
            SizedBox(height: 20),
            Text(
              'Home',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
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

  Widget _buildProfileContent() {
    // Navigate to dedicated ProfileScreen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        ).then((_) {
          // Reset to home tab when returning from profile
          setState(() {
            _currentIndex = 0;
          });
        });
      }
    });
    
    return Container(
      color: const Color(0xFF001F3F),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFFFD700),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F3F),
        title: Text(
          _currentIndex == 0 ? 'Home' : 'Profile',
          style: const TextStyle(color: Color(0xFFFFD700)),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFFFD700)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
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
      body: _currentIndex == 0 ? _buildHomeContent() : _buildProfileContent(),
      bottomNavigationBar: HomePageNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}