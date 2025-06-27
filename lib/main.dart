import 'package:expense/home.dart';
import 'package:expense/login.dart';
import 'package:expense/splash_screen.dart';
import 'package:flutter/material.dart';
import 'signup.dart'; // Import the sign-up page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen()
    );
  }
}

 
