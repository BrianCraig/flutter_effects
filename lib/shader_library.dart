import 'dart:ui' show FragmentProgram, FragmentShader;

import 'package:flutter/scheduler.dart' show Ticker;
import 'package:flutter/widgets.dart';

/// FragmentProgram loader Widget,
/// similar to [FutureBuilder].
///
/// This Widget, like [FutureBuilder]
/// Can't know on the first frame is the
/// Future is resolved, so it shows the child
/// for at least one frame,
/// If you don't want any loading/compiling frame
/// to be shown, load the [FragmentProgram] in an upper context
/// and use directly the [FragmentShaderPaint].
class FragmentProgramBuilder extends StatelessWidget {
  /// future loader, example: `FragmentProgram.fromAsset('assets/my_shader.glsl')`
  final Future<FragmentProgram> future;

  /// default Widget shown while compiling/loading/waiting for [FragmentProgram]
  final Widget child;
  final Widget Function(BuildContext context, FragmentProgram fragmentProgram)
      builder;

  const FragmentProgramBuilder({
    super.key,
    required this.future,
    required this.builder,
    this.child = const SizedBox(),
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FragmentProgram>(
      future: future,
      builder: (context, AsyncSnapshot<FragmentProgram> snapshot) {
        if (snapshot.hasData) {
          return builder(context, snapshot.data!);
        }
        if (snapshot.hasError) {
          // TODO: implement error stategy
          return Text(
            snapshot.error.toString(),
            textDirection: TextDirection.ltr,
          );
        }
        return child;
      },
    );
  }
}

abstract class CustomUniforms {
  const CustomUniforms();

  void setUniforms(int baseIndex, FragmentShader shader);
}

class EmptyCustomUniforms extends CustomUniforms {
  const EmptyCustomUniforms();

  @override
  void setUniforms(int baseIndex, FragmentShader shader) {}
}

class FragmentUniforms {
  final Matrix4 transformation;
  final double time;
  final CustomUniforms custom;

  const FragmentUniforms({
    required this.transformation,
    required this.time,
    this.custom = const EmptyCustomUniforms(),
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FragmentUniforms &&
          runtimeType == other.runtimeType &&
          transformation == other.transformation &&
          time == other.time &&
          custom == other.custom;

  @override
  int get hashCode => transformation.hashCode ^ time.hashCode ^ custom.hashCode;
}

typedef CustomRenderer = void Function(Canvas canvas, Paint paint, Size size);

typedef FragmentShaderPaintCallback = FragmentUniforms Function(double time);

class FragmentShaderPaint extends StatefulWidget {
  final FragmentProgram fragmentProgram;
  final FragmentShaderPaintCallback uniforms;
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

class _FragmentShaderPaintState extends State<FragmentShaderPaint>
    with SingleTickerProviderStateMixin {
  late final Ticker ticker;
  late DateTime start;

  /// TODO on change, dispose and regenerate shader.
  late FragmentShader shader;
  late FragmentUniforms uniforms;

  @override
  void initState() {
    super.initState();
    start = DateTime.now();
    ticker = createTicker((_) {
      final newUniforms = generateUniforms();
      // we don't want to re-rendeer if uniforms are the same
      if (newUniforms != uniforms) {
        setState(() {
          uniforms = newUniforms;
        });
      }
    });
    ticker.start();
    shader = widget.fragmentProgram.fragmentShader();
    uniforms = generateUniforms();
  }

  FragmentUniforms generateUniforms() {
    return widget.uniforms(
        DateTime.now().difference(start).inMicroseconds.toDouble() / 1e6);
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _FragmentShaderPainter(
          shader: shader,
          uniforms: uniforms,
          customRenderer: widget.customRenderer,
        ),
        child: widget.child,
      ),
    );
  }
}

class _FragmentShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final FragmentUniforms uniforms;
  final CustomRenderer? customRenderer;

  _FragmentShaderPainter(
      {required this.shader, required this.uniforms, this.customRenderer});

  @override
  void paint(Canvas canvas, Size size) {
    // layout(location = 0) uniform vec2 i_resolution;
    shader.setSize(0, size);
    // layout(location = 1) uniform mat4 i_offset;
    shader.setM4(2, uniforms.transformation);
    // layout(location = 2) uniform float i_time;
    shader.setFloat(18, uniforms.time);

    // custom uniforms
    uniforms.custom.setUniforms(19, shader);

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

class MyCustomUniforms extends CustomUniforms {
  final Color firstColor;
  final Color secondColor;
  final double angle;
  const MyCustomUniforms({
    required this.firstColor,
    required this.secondColor,
    required this.angle,
  });

  @override
  void setUniforms(int baseIndex, FragmentShader shader) {
    shader.setRGBColor(baseIndex, firstColor);
    shader.setRGBColor(baseIndex + 3, secondColor);
    shader.setFloat(baseIndex + 6, angle);
  }
}
