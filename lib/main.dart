// File: lib/main.dart (CORRECTED)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // NEW
import 'screens/splash_screen.dart';
import 'providers/cart_provider.dart'; // ASSUMES CartProvider is in this path

void main() {
  // CRITICAL: Must be called before SharedPreferences.getInstance() in CartProvider
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // 1. Initialize CartProvider at the root of the application
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      // 2. Wrap your main app widget with the provider
      child: const HamiMiniMarketApp(),
    ),
  );
}

class HamiMiniMarketApp extends StatelessWidget {
  const HamiMiniMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hami MiniMarket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      // SplashScreen is now built INSIDE the provider's scope
      home: SplashScreen(),
    );
  }
}
