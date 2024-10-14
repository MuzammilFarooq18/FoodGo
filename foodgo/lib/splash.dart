import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodgo/main.dart'; // Ensure this import is available

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // 3 seconds ka delay aur phir next screen per navigate karega
    _timer = Timer(Duration(seconds: 3), () {
      if (mounted) {
        // Check karen ke widget abhi mounted hai
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthWrapper()), // AuthWrapper ko yahan call karein
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Timer ko cancel karein agar widget dispose ho jaye
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 238, 95, 85),
              const Color.fromARGB(255, 202, 16, 16),
            ],
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 330),
                Center(
                  child: Text(
                    'FoodGo',
                    style: TextStyle(
                      fontSize: 45,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 603,
              right: 189,
              child: Image.asset(
                'assets/images/burger1.png',
                width: 200,
                height: 200,
              ),
            ),
            Positioned(
              top: 643,
              left: 120,
              child: Image.asset(
                'assets/images/burger2.png',
                width: 190,
                height: 190,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
