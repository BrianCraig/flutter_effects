import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shader_toy/main.dart';

late Matrix4 matidentiy;

// ignore: must_be_immutable
class ShaderDemoPaint extends StatefulWidget {
  final Widget child;
  final FragmentProgram fragmentProgram;
  final double time;
  late Matrix4 transformation;

  ShaderDemoPaint({
    super.key,
    required this.child,
    required this.fragmentProgram,
    Matrix4? transformation,
    this.time = .0,
  }) {
    this.transformation = transformation ?? Matrix4.identity();
  }

  @override
  State<ShaderDemoPaint> createState() =>
      _ShaderDemoPaintState();
}

class _ShaderDemoPaintState
    extends State<ShaderDemoPaint> {
  late FragmentShader fragmentShader;

  @override
  void initState() {
    super.initState();
    fragmentShader = debugTimeSync(() => widget.fragmentProgram.fragmentShader(), 'live tt fs');
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ShaderDemoPainter(
        shader: fragmentShader,
        transformation: widget.transformation,
        time: widget.time,
      ),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    fragmentShader.dispose();
    super.dispose();
  }
}

class ShaderDemoPainter extends CustomPainter {
  final FragmentShader shader;
  final double time;
  final Matrix4 transformation;

  ShaderDemoPainter({
    required this.shader,
    required this.time,
    required this.transformation,
  });

  @override
  void paint(Canvas canvas, Size size) {

    // layout(location = 0) uniform vec2 i_resolution;
    // layout(location = 1) uniform mat4 i_offset;
    // layout(location = 2) uniform float i_time;

    shader.setSize(0, size);
    shader.setM4(2, transformation);
    shader.setFloat(18, time);
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
  bool shouldRepaint(ShaderDemoPainter oldDelegate) {
    return true;
  }
}

extension ShaderSetter on FragmentShader {
  void setM4(int index, Matrix4 value) {
    for (var row = 0; row < 4; row++) {
      for (var col = 0; col < 4; col++) {
        setFloat(index + ((row * 4) + col), value.entry(row, col));
      }
    }
  }

  void setSize(int index, Size value) {
    setFloat(index, value.width);
    setFloat(index+1, value.height);
  }
}
