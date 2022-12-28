import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shader_toy/model/fragment_samples.dart';
import 'package:shader_toy/screens/infinite_scroll_circles.dart';
import 'package:shader_toy/screens/noise_types_screen.dart';
import 'package:shader_toy/screens/shader_demo_screen.dart';
import 'package:shader_toy/screens/truchet_tiling_screen.dart';
import 'package:shader_toy/shader_library.dart';
import 'package:shader_toy/widgets/show_shader_demo.dart';

void main() async {
  runApp(const FlutterApp());
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

const welcomeText = '''
Hi developers!

Are you tired of the same old boring backgrounds in your Flutter apps? Do you want to add some flair and excitement to your user interface? Look no further! Our Flutter background effects package has got you covered.

With our package, you can easily add dynamic and visually stunning backgrounds to your Flutter apps. Whether you want a subtle parallax effect or a bold and vibrant gradient, we have a wide range of options to choose from.

But it's not just about the aesthetics. Our package is also designed to be easy to use and integrate into your existing Flutter projects. All you have to do is add a few lines of code and you'll be up and running in no time.

So why wait? Give our Flutter background effects package a try today and see the difference it can make in your apps. Your users will thank you!
''';

/// Must be 1 viewport height
class WelcomeTopSection extends StatelessWidget {
  const WelcomeTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Theme(
      data: ThemeData.from(
        colorScheme: const ColorScheme.highContrastLight(
          background: Colors.white,
        ),
      ),
      child: WelcomeTopSectionContent(height: height),
    );
  }
}

class WelcomeTopSectionContent extends StatelessWidget {
  const WelcomeTopSectionContent({
    super.key,
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.loose(
                const Size.fromWidth(480),
              ),
              child: Text(
                welcomeText,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomeText extends StatelessWidget {
  final String text;
  const WelcomeText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(
        colorScheme: const ColorScheme.highContrastDark(
          background: Colors.black,
        ),
      ),
      child: WelcomeTextContent(
        text: text,
      ),
    );
  }
}

class WelcomeTextContent extends StatelessWidget {
  final String text;
  const WelcomeTextContent({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tight(
        const Size.fromHeight(240),
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints.tight(
            const Size(480, 48),
          ),
          child: Text(
            text,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
      ),
    );
  }
}

class WelcomeMenuOLD extends StatelessWidget {
  const WelcomeMenuOLD({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Stack(
      fit: StackFit.loose,
      // TODO check why expand crashes, or use another thing
      // Do a lot of things lulw
      children: [
        ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: mq.width,
                maxWidth: mq.width,
                minHeight: 300,
                maxHeight: 600),
            child: const HomeMenu()),
        IgnorePointer(
          child: FragmentShaderPaint(
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
            customRenderer: _myRenderer,
            child: const SizedBox(
              height: 16,
              width: 16,
            ),
          ),
        ),
      ],
    );
  }
}

extension ListFiller<T> on List<T> {
  List<T> fillBetween(T element) {
    return List.generate(
        length * 2 - 1, (index) => index % 2 == 0 ? this[index ~/ 2] : element);
  }
}

class ShaderDemoList extends StatelessWidget {
  final List<Widget> children;
  const ShaderDemoList({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(
        colorScheme: const ColorScheme.highContrastDark(
          background: Colors.black,
        ),
      ),
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: children.fillBetween(
            const SizedBox(
              height: 32,
            ),
          ),
        ),
      ),
    );
  }
}

class FlutterContent extends StatelessWidget {
  const FlutterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const WelcomeTopSection(),
          const WelcomeText(
            text: 'Let\'s add some noise.',
          ),
          ShaderDemoList(
            children: [
              ShowShaderDemo(
                title: 'White Noise',
                sample: FragmentSamples.whiteNoise,
                uniforms: (matrix) => (time) => FragmentUniforms(
                    transformation: matrix, time: 0),
              ),
              ShowShaderDemo(
                title: 'Colored White Noise',
                sample: FragmentSamples.whiteNoiseColor,
                uniforms: (matrix) => (time) => FragmentUniforms(
                    transformation: matrix, time: 0),
              ),
              ShowShaderDemo(
                title: 'Colored White Noise, 8px cell',
                sample: FragmentSamples.whiteNoiseColorCell,
                uniforms: (matrix) => (time) => FragmentUniforms(
                    transformation: matrix, time: 0),
              ),
            ],
          ),
        ],
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
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
