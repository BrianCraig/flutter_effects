import 'dart:math' show pi;
import 'dart:ui' show FragmentProgram, FragmentShader;

import 'package:flutter/scheduler.dart' show Ticker;
import 'package:flutter/widgets.dart';

/// FragmentProgram loader Widget,
/// similar to [FutureBuilder].
///
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
      builder: (context, AsyncSnapshot snapshot) {
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
}

class FragmentShaderPaint extends StatefulWidget {
  final FragmentProgram fragmentProgram;
  final FragmentUniforms Function(BuildContext context, double time) uniforms;
  final Widget child;

  const FragmentShaderPaint({
    super.key,
    required this.fragmentProgram,
    required this.uniforms,
    required this.child,
  });

  @override
  State<FragmentShaderPaint> createState() => _FragmentShaderPaintState();
}

class _FragmentShaderPaintState extends State<FragmentShaderPaint>
    with SingleTickerProviderStateMixin {
  late final Ticker ticker;
  late DateTime start;
  late FragmentShader shader;

  @override
  void initState() {
    super.initState();
    start = DateTime.now();
    ticker = createTicker((_) {
      setState(() {});
    });
    ticker.start();
    shader = widget.fragmentProgram.fragmentShader();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FragmentShaderPainter(
        shader: shader,
        uniforms: widget.uniforms(context,
            DateTime.now().difference(start).inMicroseconds.toDouble() / 1e6),
      ),
      child: widget.child,
    );
  }
}

class _FragmentShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final FragmentUniforms uniforms;

  _FragmentShaderPainter({required this.shader, required this.uniforms});

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
  bool shouldRepaint(_FragmentShaderPainter oldDelegate) {
    return true; // TODO: make tests for performance
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

class Example extends StatelessWidget {
  final Widget myChild;
  const Example({
    super.key,
    required this.myChild,
  });

  @override
  Widget build(BuildContext context) {
    return FragmentProgramBuilder(
      future: FragmentProgram.fromAsset('assets/my_shader.glsl'),
      builder: (BuildContext context, FragmentProgram fragmentProgram) =>
          FragmentShaderPaint(
        fragmentProgram: fragmentProgram,
        uniforms: (BuildContext context, double time) => FragmentUniforms(
          transformation: Matrix4.identity(),
          time: time,
          custom: const MyCustomUniforms(
            firstColor: Color.fromRGBO(255, 0, 0, 1.0),
            secondColor: Color.fromRGBO(0, 0, 255, 1.0),
            angle: pi / 2,
          ),
        ),
        child: myChild,
      ),
      child: myChild,
    );
  }
}
