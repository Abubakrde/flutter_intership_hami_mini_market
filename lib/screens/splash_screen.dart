// File: lib/screens/splash_screen.dart (UPDATED)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // NEW
import '../providers/cart_provider.dart'; // NEW
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp(); // Call the initialization function
  }

  void _initializeApp() async {
    // 1. Wait a minimum of 2 seconds for a better user experience
    await Future.delayed(const Duration(seconds: 2));

    // 2. Access the CartProvider instance using context.read.
    // This action ensures the context is fully built and ready to supply the provider.
    context.read<CartProvider>();

    // 3. Navigate to the next screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade700,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ... (Your existing UI code)
            const SizedBox(height: 40),
            // Added loading indicator for visual feedback
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
