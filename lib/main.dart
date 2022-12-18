import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shader_toy/screens/shader_demo_screen.dart';
import 'package:shader_toy/screens/truchet_tiling_screen.dart';
import 'package:shader_toy/shader_library.dart';

Future<T> debugTime<T>(Future<T> original, String name) async {
  final start = DateTime.now();
  final output = await original;
  print(
      '[$name] took ${DateTime.now().difference(start).inMicroseconds.toString()} microseconds');
  return output;
}

T debugTimeSync<T>(T Function() original, String name) {
  final start = DateTime.now();
  final output = original();
  print(
      '[$name] took ${DateTime.now().difference(start).inMicroseconds.toString()} microseconds');
  return output;
}

void main() async {
  runApp(const FlutterApp());
}

class _NoiseGradientUniforms extends CustomUniforms {
  final int steps;
  final Color firstColor;
  final Color secondColor;

  const _NoiseGradientUniforms({
    this.steps = 10,
    required this.firstColor,
    required this.secondColor,
  });

  @override
  void setUniforms(int baseIndex, FragmentShader shader) {
    shader.setFloat(baseIndex, steps.toDouble());
    shader.setHSLColor(baseIndex + 1, HSLColor.fromColor(firstColor));
    shader.setHSLColor(baseIndex + 5, HSLColor.fromColor(secondColor));
  }
}

final tweenScale = TweenSequence<double>(
  <TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 0.9, end: 1.2).chain(
        CurveTween(curve: Curves.ease),
      ),
      weight: 40.0,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 1.2, end: 0.9).chain(
        CurveTween(curve: Curves.ease),
      ),
      weight: 40.0,
    ),
  ],
);

class FlutterApp extends StatelessWidget {
  const FlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget container = Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Shaders test',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(
            height: 16,
          ),
          const _MyButtonWidget(
            route: TruchetTillingScreen(),
            text: 'See Truchet tiling',
          ),
          const SizedBox(
            height: 16,
          ),
          const _MyButtonWidget(
            route: ShaderDemoScreen(),
            text: 'See Debug demo',
          ),
        ],
      ),
    );
    return MaterialApp(
      home: Scaffold(
        body: FragmentProgramBuilder(
          future: FragmentProgram.fromAsset(
              'assets/flutter-shaders/noise_gradient_fragment.glsl'),
          builder: (BuildContext context, FragmentProgram fragmentProgram) =>
              FragmentShaderPaint(
            fragmentProgram: fragmentProgram,
            uniforms: (BuildContext context, double time) => FragmentUniforms(
              transformation: Matrix4.identity()
                ..translate(sin(time) * 0.1, time / 3)
                ..scale(tweenScale.transform(time / 6 % 1.0) * 3),
              time: time,
              custom: _NoiseGradientUniforms(
                steps: ((sin(time) + 1) * 6.0 + 2.0).round(),
                firstColor: const Color.fromRGBO(206, 13, 13, 1.0),
                secondColor: const Color.fromRGBO(12, 169, 12, 1.0),
              ),
            ),
            child: container,
          ),
          child: container,
        ),
      ),
    );
  }
}

class _MyButtonWidget extends StatelessWidget {
  final Widget route;
  final String text;
  const _MyButtonWidget({required this.route, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints.tight(const Size(400, 60)),
        child: OutlinedButton(
          onPressed: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, _, __) => route,
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          ),
          style: const ButtonStyle(),
          child: Text(
            text,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
    );
  }
}
