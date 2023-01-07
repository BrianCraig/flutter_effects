import 'dart:ui' show FragmentProgram, FragmentShader;

import 'package:flutter/widgets.dart';
import 'package:shader_toy/model/transform_2d.dart';

abstract class CustomUniforms {
  const CustomUniforms();

  void setUniforms(int baseIndex, FragmentShader shader);

  int get size;
}

class EmptyCustomUniforms extends CustomUniforms {
  const EmptyCustomUniforms();

  @override
  void setUniforms(int baseIndex, FragmentShader shader) {}

  @override
  get size => 0;
}

class FloatUniforms extends CustomUniforms {
  final double value;
  const FloatUniforms({this.value = 0.0});

  @override
  void setUniforms(int baseIndex, FragmentShader shader) {
    shader.setFloat(baseIndex, value);
  }

  @override
  int get size => 1;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FloatUniforms &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

typedef TimeUniforms = FloatUniforms;

class TransformUniforms extends CustomUniforms {
  final Matrix4 matrix;
  const TransformUniforms({required this.matrix});

  @override
  void setUniforms(int baseIndex, FragmentShader shader) {
    shader.setM4(baseIndex, matrix);
  }

  @override
  int get size => 16;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransformUniforms &&
          runtimeType == other.runtimeType &&
          matrix == other.matrix;

  @override
  int get hashCode => matrix.hashCode;
}

class ColorUniforms extends CustomUniforms {
  final Color color;
  const ColorUniforms({required this.color});

  @override
  void setUniforms(int baseIndex, FragmentShader shader) {
    shader.setRGBAColor(baseIndex, color);
  }

  @override
  int get size => 4;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorUniforms &&
          runtimeType == other.runtimeType &&
          color == other.color;

  @override
  int get hashCode => color.hashCode;
}

class Transform2DUniform extends CustomUniforms {
  final Transform2D transform;
  const Transform2DUniform({
    this.transform = const Transform2D()});

  @override
  void setUniforms(int baseIndex, FragmentShader shader) {
    shader.setOffset(baseIndex, transform.translation);
    shader.setFloat(baseIndex + 2, transform.rotation);
    shader.setFloat(baseIndex + 3, transform.scale);
  }

  @override
  int get size => 4;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transform2DUniform &&
          runtimeType == other.runtimeType &&
          transform == other.transform ;

  @override
  int get hashCode => transform.hashCode;
}

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

extension ShaderSetter on FragmentShader {
  /// Sets the mat4 uniform at [index] to Matrix4 [value].
  /// It takes 16 float spaces.
  void setM4(int index, Matrix4 value) {
    for (var row = 0; row < 4; row++) {
      for (var col = 0; col < 4; col++) {
        setFloat(index + ((row * 4) + col), value.entry(row, col));
      }
    }
  }

  /// Sets the vec2 uniform at [index] to Size [value].
  /// It takes 2 float spaces.
  void setOffset(int index, Offset value) {
    setFloat(index, value.dx);
    setFloat(index + 1, value.dy);
  }

  /// Sets the vec2 uniform at [index] to Size [value].
  /// It takes 2 float spaces.
  void setSize(int index, Size value) {
    setFloat(index, value.width);
    setFloat(index + 1, value.height);
  }

  /// Sets the vec3 uniform at [index] to RGB [value].
  /// It takes 3 float spaces.
  void setRGBColor(int index, Color value) {
    setFloat(index, value.red / 255);
    setFloat(index + 1, value.green / 255);
    setFloat(index + 2, value.blue / 255);
  }

  /// Sets the vec4 uniform at [index] to RGB [value].
  /// It takes 4 float spaces.
  void setRGBAColor(int index, Color value) {
    setFloat(index, value.red / 255);
    setFloat(index + 1, value.green / 255);
    setFloat(index + 2, value.blue / 255);
    setFloat(index + 3, value.opacity);
  }

  /// Sets the vec4 uniform at [index] to HSLA [value].
  /// It takes 4 float spaces.
  void setHSLColor(int index, HSLColor value) {
    setFloat(index, value.hue / 360);
    setFloat(index + 1, value.saturation);
    setFloat(index + 2, value.lightness);
    setFloat(index + 3, value.alpha);
  }
}

extension DurationDouble on Duration {
  double get inSecondsDecimal => inMicroseconds / Duration.microsecondsPerSecond;
}