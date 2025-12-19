import 'package:flutter/material.dart';
import 'package:showme/screens/home_screen.dart';

void main() {
  runApp(const ShowMeApp());
}

class ShowMeApp extends StatelessWidget {
  const ShowMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShowMe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFF0A1628),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
