import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shader_toy/shaders/shader_demo.dart';
import 'package:shader_toy/time_animation_builder.dart';

class ShaderDemoScreen extends StatelessWidget {
  final FragmentProgram fragmentProgram;

  const ShaderDemoScreen({
    super.key,
    required this.fragmentProgram,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TimeAnimationBuilder(
        builder: (context, double time, child) => ShaderDemoPaint(
          fragmentProgram: fragmentProgram,
          time: time,
          transformation: Matrix4.identity()
            ..scale(10.0)
            ..translate(cos(time)*.2, time*.1, 0)
            ..rotateZ(sin(time)*.05)
            ..rotateY(1.1),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Truchet Tilling Shader',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 16,),
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
          ),
        ),
      ),
    );
  }
}
