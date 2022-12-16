import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

class ShaderDecoration extends Decoration {
  final FragmentProgram fragmentProgram;
  late Timer timer;
  ShaderDecoration({
    required this.fragmentProgram,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    timer = Timer.periodic(
      const Duration(milliseconds: 200),
      (Timer t) => onChanged!(),
    );
    return ShaderBoxPainter(fragmentProgram.fragmentShader(), onChanged);
  }
}

class ShaderBoxPainter extends BoxPainter {
  final FragmentShader shader;
  late DateTime datetime;
  late Timer timer;

  ShaderBoxPainter(this.shader, super.onChanged) {
    datetime = DateTime.now();
    timer = Timer.periodic(
      const Duration(milliseconds: 200),
      (Timer t) => onChanged!(),
    );
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    shader.setFloat(
      0,
      datetime.difference(DateTime.now()).inMilliseconds.toDouble() / 1000,
    );
    shader.setFloat(1, 1 / configuration.size!.width);
    shader.setFloat(2, 1 / configuration.size!.height);
    final paint = Paint()..shader = shader;
    canvas.drawRect(
      offset & configuration.size!,
      paint,
    );
    print('$offset, ${configuration.size!}');
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}
