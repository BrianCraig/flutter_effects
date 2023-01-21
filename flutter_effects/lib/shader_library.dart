import 'dart:ui' show FragmentProgram, FragmentShader;

import 'package:flutter/widgets.dart';
import 'package:flutter_effects/shader_setter.dart';
import 'package:flutter_effects/uniforms.dart';

typedef CustomRenderer = void Function(Canvas canvas, Paint paint, Size size);

class FragmentShaderPaint extends StatefulWidget {
  final FragmentProgram fragmentProgram;
  final List<CustomUniforms> uniforms;
  final CustomRenderer? customRenderer;
  final Widget child;

  const FragmentShaderPaint({
    super.key,
    required this.fragmentProgram,
    required this.uniforms,
    required this.child,
    this.customRenderer,
  });

  @override
  State<FragmentShaderPaint> createState() => _FragmentShaderPaintState();
}

class _FragmentShaderPaintState extends State<FragmentShaderPaint> {
  late DateTime start;

  /// TODO on change, dispose and regenerate shader.
  late FragmentShader shader;

  @override
  void initState() {
    super.initState();
    start = DateTime.now();
    shader = widget.fragmentProgram.fragmentShader();
  }

  @override
  void dispose() {
    shader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _FragmentShaderPainter(
          shader: shader,
          uniforms: widget.uniforms,
          devicePixelRatio: MediaQuery.maybeDevicePixelRatioOf(context) ?? 1.0,
          customRenderer: widget.customRenderer,
        ),
        child: widget.child,
      ),
    );
  }
}

class _FragmentShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final List<CustomUniforms> uniforms;
  final double devicePixelRatio;
  final CustomRenderer? customRenderer;

  _FragmentShaderPainter({
    required this.shader,
    required this.uniforms,
    required this.devicePixelRatio,
    this.customRenderer,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // layout(location = 0) uniform vec2 i_resolution;
    shader.setSize(0, size);
    // layout(location = 1) uniform vec2 i_dpr;
    shader.setFloat(2, devicePixelRatio);

    var index = 3;
    for (final uniform in uniforms) {
      uniform.setUniforms(index, shader);
      index += uniform.size;
    }

    final paint = Paint()..shader = shader;
    if (customRenderer != null) {
      customRenderer!(canvas, paint, size);
    } else {
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
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _FragmentShaderPainter &&
          shader == other.shader &&
          uniforms == other.uniforms;

  @override
  int get hashCode => shader.hashCode ^ uniforms.hashCode;

  @override
  bool shouldRepaint(_FragmentShaderPainter oldDelegate) {
    return this != oldDelegate;
  }
}

extension DurationDouble on Duration {
  double get inSecondsDecimal => inMicroseconds / Duration.microsecondsPerSecond;
}