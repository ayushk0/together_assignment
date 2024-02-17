import 'package:flutter/material.dart';
import 'package:together_assignment/discovery.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Together.buzz Assignment',
      home: const DiscoveryScreen(),
    );
  }
}