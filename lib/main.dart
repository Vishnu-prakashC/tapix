

import 'package:flutter/material.dart';

void main() {
  runApp(const TapixApp());
}

class TapixApp extends StatelessWidget {
  const TapixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int waterCount = 0;
  bool isPressed = false;

  void addWater() {
    setState(() {
      waterCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$waterCount bottles',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTapDown: (_) {
              setState(() => isPressed = true);
            },
            onTapUp: (_) {
              setState(() => isPressed = false);
              addWater();
            },
            onTapCancel: () {
              setState(() => isPressed = false);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              height: isPressed ? 160 : 180,
              width: isPressed ? 160 : 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyanAccent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.6),
                    blurRadius: 25,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.water_drop,
                  size: 80,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
