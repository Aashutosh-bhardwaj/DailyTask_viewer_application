
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pharmafly/Screens/loginscreen.dart';
import 'loginscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer(const Duration(seconds: 3), () {

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );

    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // APP LOGO
            Container(
              height: 120,
              width: 120,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),

              child: const Icon(
                Icons.visibility,
                size: 75,
                color: Color(0xFF1565C0),
              ),
            ),

            const SizedBox(height: 25),

            // APP NAME
            const Text(
              "Tash Viewer",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 10),

            // TAGLINE
            const Text(
              "View Everything, Simply.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 50),

            // LOADING INDICATOR
            const SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
