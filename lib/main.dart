import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(HamiMiniMarketApp());
}

class HamiMiniMarketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hami MiniMarket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SplashScreen(),
    );
  }
}
