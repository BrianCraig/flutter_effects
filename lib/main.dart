import 'dart:ui';

import 'package:flutter/material.dart';

late DateTime now;

void main() {
  now = DateTime.now();
  runApp(const FlutterApp());
}

class FlutterApp extends StatelessWidget {
  const FlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Test'),
        ),
        body: const Lol(),
      ),
    );
  }
}

class Lol extends StatelessWidget {
  const Lol({super.key});

  @override
  Widget build(BuildContext context) {
    final program = FragmentProgram.fromAsset('assets/shader/red.glsl.iplr');

    return FutureBuilder<FragmentProgram>(
      builder: (_, snap) {
        if (snap.hasError) {
          return Text(
            snap.error.toString(),
            textDirection: TextDirection.ltr,
          );
        }
        if (!snap.hasData) return Container();
        return CustomPaint(
          painter: ShaderPainter(
            shader: snap.data!.fragmentShader(),
          ),
          child: const SizedBox.expand(),
        );
      },
      future: program,
    );
  }
}

class ShaderPainter extends CustomPainter {
  final FragmentShader shader;

  ShaderPainter({required this.shader});

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(
        0, now.difference(DateTime.now()).inMilliseconds.toDouble() / 1000);
    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
