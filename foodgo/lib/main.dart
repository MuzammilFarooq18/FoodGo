import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodgo/splash.dart';
import 'package:foodgo/cartProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgo/home.dart';
import 'package:foodgo/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child:
          MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen()),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Jab tak auth state check ho raha hai, splash screen dikhana
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }

        User? user = snapshot.data;
        // User logged out ya logged in check karna
        if (user == null) {
          return LoginPage(); // User ko login page dikhana
        } else {
          return homepage(); // User ko home page dikhana
        }
      },
    );
  }
}
