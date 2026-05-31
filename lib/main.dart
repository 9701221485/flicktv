import 'package:flutter/material.dart';
import 'package:lavanya/screens/blinkit_money_animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlinkitMoneyAnimation(),
    );
  }
}
