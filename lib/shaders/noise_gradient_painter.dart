import 'dart:ui';

import 'package:flutter/material.dart';

/// remembers the `FragmentShader` state for this Widget
class NoiseGradientPainterWidget extends StatefulWidget {
  final Widget child;
  final FragmentProgram fragmentProgram;
  final Offset offset;
  final double scale;

  const NoiseGradientPainterWidget({
    super.key,
    required this.child,
    required this.fragmentProgram,
    this.offset = Offset.zero,
    this.scale = 1.0,
  });

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
    fragmentShader = widget.fragmentProgram.fragmentShader();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: NoiseGradientPainter(
        shader: fragmentShader,
        offset: widget.offset,
        scale: widget.scale,
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

  NoiseGradientPainter({
    required this.shader,
    required this.offset,
    required this.scale,
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
    final paint = Paint()..shader = shader;
    final start = DateTime.now();
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      paint,
    );

    print('re-rendered, time is ${DateTime.now().difference(start).inMicroseconds} microseconds');
  }

  @override
  bool shouldRepaint(NoiseGradientPainter oldDelegate) {
    return true;
  }
}
