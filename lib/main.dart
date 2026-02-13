import 'dart:math';

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
  double waterLevel = 0.0; // 0.0 to 1.0
  bool isPressed = false;
  double rippleSize = 0;
  bool showRipple = false;
  bool showParticles = false;
  DateTime? pressStartTime;

  void addWater() {
    setState(() {
      waterCount++;
      waterLevel += 0.1;
      if (waterLevel > 1) waterLevel = 1;
    });
  }

  void triggerSplash() {
    setState(() {
      showRipple = true;
      rippleSize = 0;
    });

    Future.delayed(const Duration(milliseconds: 10), () {
      if (!mounted) return;
      setState(() {
        rippleSize = 260;
      });
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        showRipple = false;
      });
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
              pressStartTime = DateTime.now();
              setState(() => isPressed = true);
            },
            onTapUp: (_) {
              final pressDuration =
                  DateTime.now().difference(pressStartTime!).inMilliseconds;

              setState(() => isPressed = false);

              if (pressDuration < 1200) {
                addWater(); // normal press
              } else {
                triggerSplash(); // over-press
              }
            },
            onTapCancel: () {
              setState(() => isPressed = false);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (showRipple)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: rippleSize,
                    width: rippleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.cyanAccent.withOpacity(0.4),
                        width: 4,
                      ),
                    ),
                  ),
                if (showParticles)
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: CustomPaint(
                      painter: SplashPainter(),
                    ),
                  ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.elasticOut,
                  height: isPressed ? 165 : 185,
                  width: isPressed ? 155 : 185,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.cyanAccent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.6),
                        blurRadius: 30,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Liquid fill
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          alignment: Alignment(0, 1 - (waterLevel * 2)),
                          child: Container(
                            height: 180,
                            width: 180,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF4FC3F7),
                                  Color(0xFF0288D1),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.water_drop,
                          size: 80,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SplashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * 3.14 / 180;
      final dx = size.width / 2 + 80 * cos(angle);
      final dy = size.height / 2 + 80 * sin(angle);
      canvas.drawCircle(Offset(dx, dy), 8, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
