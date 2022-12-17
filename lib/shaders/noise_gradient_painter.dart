import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shader_toy/main.dart';

/// remembers the `FragmentShader` state for this Widget
class NoiseGradientPainterWidget extends StatefulWidget {
  final Widget child;
  final FragmentProgram fragmentProgram;
  final Offset offset;
  final double scale;
  final int steps;

  const NoiseGradientPainterWidget({
    super.key,
    required this.child,
    required this.fragmentProgram,
    this.offset = Offset.zero,
    this.scale = 1.0,
    this.steps = 8,
  }) : assert (steps >= 2);

  @override
  State<NoiseGradientPainterWidget> createState() =>
      _NoiseGradientPainterWidgetState();
}

class _NoiseGradientPainterWidgetState
    extends State<NoiseGradientPainterWidget> {
  late FragmentShader fragmentShader;

  @override
  void initState() {
    super.initState();
    fragmentShader = debugTimeSync(() => widget.fragmentProgram.fragmentShader(), 'live ng fs');
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: NoiseGradientPainter(
        shader: fragmentShader,
        offset: widget.offset,
        scale: widget.scale,
        steps: widget.steps,
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

class NoiseGradientPainter extends CustomPainter {
  final FragmentShader shader;
  final Offset offset;
  final double scale;
  final int steps;

  NoiseGradientPainter({
    required this.shader,
    required this.offset,
    required this.scale,
    required this.steps,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) {
      return;
    }
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, offset.dx);
    shader.setFloat(3, offset.dy);
    shader.setFloat(4, scale);
    shader.setFloat(5, steps.toDouble());
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
  bool shouldRepaint(NoiseGradientPainter oldDelegate) {
    return true;
  }
}
