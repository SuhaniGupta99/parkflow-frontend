import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth/splash_screen.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: const ParkFlowApp(),
    ),
  );
}

class ParkFlowApp extends StatelessWidget {
  const ParkFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}