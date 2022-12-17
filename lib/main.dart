import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shader_toy/shaders/noise_gradient_painter.dart';
import 'package:shader_toy/time_animation_builder.dart';

late DateTime now;

late FragmentProgram fp;
late FragmentProgram noiseGradientProgram;

void main() async {
  now = DateTime.now();
  noiseGradientProgram = await FragmentProgram.fromAsset(
      'assets/flutter-shaders/noise_gradient_fragment.glsl');
  runApp(const FlutterApp());
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
    return MaterialApp(
      home: Scaffold(
        body: TimeAnimationBuilder(
          builder: (context, double time, child) => NoiseGradientPainterWidget(
            fragmentProgram: noiseGradientProgram,
            scale: tweenScale.transform(time / 6 % 1.0),
            offset: Offset(sin(time) * 0.1, time / 3),
            steps: ((sin(time) + 1) * 6.0 + 2.0).toInt(),
            child: Container(
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

                  Align(
                    alignment: Alignment.center,
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tight(
                        const Size(400, 60)
                      ),
                      child: OutlinedButton(
                        onPressed: () {},
                        style: const ButtonStyle(),
                        child: Text(
                          'See more shaders',
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
      ),
    );
  }
}

class AnimatedNoiseGradientPainterWidget extends AnimatedWidget {
  final Widget child;

  const AnimatedNoiseGradientPainterWidget({
    super.key,
    required this.child,
    required Animation<double> animation,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return NoiseGradientPainterWidget(
      fragmentProgram: noiseGradientProgram,
      scale: animation.value,
      child: child,
    );
  }
}
