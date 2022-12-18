import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shader_toy/shader_library.dart';

class ShaderDemoScreen extends StatelessWidget {
  const ShaderDemoScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var container = Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Debug demo',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints.tight(const Size(400, 60)),
              child: OutlinedButton(
                onPressed: () => Navigator.pop(
                  context,
                ),
                style: const ButtonStyle(),
                child: Text(
                  'Back',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          )
        ],
      ),
    );

    return Scaffold(
      body: FragmentProgramBuilder(
        future: FragmentProgram.fromAsset(
            'assets/flutter-shaders/debug.glsl'),
        builder: (BuildContext context, FragmentProgram fragmentProgram) =>
            FragmentShaderPaint(
          fragmentProgram: fragmentProgram,
          uniforms: (BuildContext context, double time) => FragmentUniforms(
            transformation: Matrix4.identity()
              ..scale(2.0)
              ..translate(cos(time) * .2, time * .1, 0)
              ..rotateZ(sin(time) * .05),
            time: time,
          ),
          child: container,
        ),
        child: container,
      ),
    );
  }
}
