import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shader_toy/screens/infinite_scroll_circles.dart';
import 'package:shader_toy/screens/noise_types_screen.dart';
import 'package:shader_toy/screens/shader_demo_screen.dart';
import 'package:shader_toy/screens/truchet_tiling_screen.dart';
import 'package:shader_toy/shader_library.dart';

void main() async {
  runApp(const FlutterApp());
}

typedef FragmentMap = Map<FragmentSamples, FragmentProgram>;

enum FragmentSamples {
  noiseGradient,
  truchetTiling,
  debug,
  noiseTypes,
  scatteredSemicircles;
}

Future<FragmentMap> getFragmentPrograms() async {
  final uris = [
    "assets/shaders/noise_gradient.glsl",
    "assets/shaders/truchet_tiling.glsl",
    "assets/shaders/debug.glsl",
    "assets/shaders/noise_types.glsl",
    "assets/shaders/scattered_semicircles.glsl",
  ];
  final result =
      await Future.wait(uris.map((uri) => FragmentProgram.fromAsset(uri)));
  return {
    FragmentSamples.noiseGradient: result[0],
    FragmentSamples.truchetTiling: result[1],
    FragmentSamples.debug: result[2],
    FragmentSamples.noiseTypes: result[3],
    FragmentSamples.scatteredSemicircles: result[4],
  };
}

class FlutterApp extends StatelessWidget {
  const FlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<FragmentMap>(
            future: getFragmentPrograms(),
            builder: (builder, snapshot) {
              if (snapshot.hasData) {
                return Provider.value(
                  value: snapshot.data!,
                  child: const FlutterContent(),
                );
              }
              return const Text('Compiling Fragment Shaders...');
            }),
      ),
    );
  }
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _NoiseGradientUniforms &&
          runtimeType == other.runtimeType &&
          steps == other.steps &&
          firstColor == other.firstColor &&
          secondColor == other.secondColor;

  @override
  int get hashCode =>
      steps.hashCode ^ firstColor.hashCode ^ secondColor.hashCode;
}

CustomRenderer _myRenderer = (Canvas canvas, Paint paint, Size size) {
  // paint.blendMode = BlendMode.values[size.width.toInt() % BlendMode.values.length];
  // print(BlendMode.values[size.width.toInt() % BlendMode.values.length]);


  paint.blendMode = BlendMode.exclusion;
  canvas.drawRect(
    Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    ),
    paint,
  );
};

class FlutterContent extends StatelessWidget {
  const FlutterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
        body: Stack(
          children: [
            const HomeMenu(),
            IgnorePointer(
              child: FragmentShaderPaint(
                fragmentProgram: context
                    .watch<FragmentMap>()[FragmentSamples.noiseGradient]!,
                uniforms: (double time) => FragmentUniforms(
                  transformation: Matrix4.identity()
                    ..translate(sin(time) * 1, time)
                    ..scale((cos(time) + 4)),
                  time: time,
                  custom: _NoiseGradientUniforms(
                    steps: ((sin(time) + 1) * 6.0 + 2.0).round(),
                    firstColor: const Color.fromRGBO(206, 13, 13, 1.0),
                    secondColor: const Color.fromRGBO(12, 169, 12, 1.0),
                  ),
                ),
                customRenderer: _myRenderer,
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WrappedShaderChristmas extends StatelessWidget {
  final Widget child;

  const WrappedShaderChristmas({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FragmentShaderPaint(
      fragmentProgram:
          context.watch<FragmentMap>()[FragmentSamples.noiseGradient]!,
      uniforms: (double time) => FragmentUniforms(
        transformation: Matrix4.identity()
          ..translate(sin(time) * 1, time)
          ..scale((cos(time) + 4)),
        time: time,
        custom: _NoiseGradientUniforms(
          steps: ((sin(time) + 1) * 6.0 + 2.0).round(),
          firstColor: const Color.fromRGBO(206, 13, 13, 1.0),
          secondColor: const Color.fromRGBO(12, 169, 12, 1.0),
        ),
      ),
      child: child,
    );
  }
}

class HomeMenu extends StatelessWidget {
  const HomeMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Shaders test',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall!.merge(
                  const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,

                  ),
                ),
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
          const SizedBox(
            height: 16,
          ),
          const _MyButtonWidget(
            route: NoiseTypesScreen(),
            text: 'Noise types',
          ),
          const SizedBox(
            height: 16,
          ),
          const _MyButtonWidget(
            route: InfiniteScrollCirclesScreen(),
            text: 'Scroll Circles',
          ),
        ],
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
          style: const ButtonStyle(
            surfaceTintColor: MaterialStatePropertyAll(Colors.black),
            shadowColor: MaterialStatePropertyAll(Colors.black),
            side: MaterialStatePropertyAll(
                BorderSide(color: Colors.black, width: 4)),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.headlineSmall!.merge(
                  const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w900),
                ),
          ),
        ),
      ),
    );
  }
}
