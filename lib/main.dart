import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: Page()));
}

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<FragmentProgram>(
        future: FragmentProgram.fromAsset('assets/shader/red.frag'),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            throw snapshot.error!;
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          return SizedBox.expand(
            child: CustomPaint(
              painter: RedShaderPainter(snapshot.data!),
            ),
          );
        }),
      ),
    );
  }
}

class RedShaderPainter extends CustomPainter {
  RedShaderPainter(this.fragmentProgram);

  final FragmentProgram fragmentProgram;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..shader = fragmentProgram.fragmentShader();
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is RedShaderPainter &&
        oldDelegate.fragmentProgram == fragmentProgram) {
      return false;
    }
    return true;
  }
}
