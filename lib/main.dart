import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shader_toy/model/fragment_samples.dart';
import 'package:shader_toy/shader_library.dart';
import 'package:shader_toy/widgets/show_shader_demo.dart';
import 'package:shader_toy/widgets/time_builder.dart';

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
            style: Theme.of(context).textTheme.headlineMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
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
                uniforms: (transform) => [
                  Transform2DUniform(transform: transform),
                ],
              ),
              ShowShaderDemo(
                title: 'Colored White Noise',
                sample: FragmentSamples.whiteNoiseColor,
                uniforms: (transform) => [
                  Transform2DUniform(transform: transform),
                ],
              ),
              ShowShaderDemo(
                title: 'Colored White Noise, 8px cell',
                sample: FragmentSamples.whiteNoiseColorCell,
                uniforms: (transform) => [
                  Transform2DUniform(transform: transform),
                ],
              ),
            ],
          ),
          const WelcomeText(
            text: 'And some Voronoi samples.',
          ),
          ShaderDemoList(
            children: [
              ShowShaderDemo(
                title: 'Voronoi',
                sample: FragmentSamples.voronoi,
                uniforms: (transform) => [
                  Transform2DUniform(transform: transform),
                ],
              ),
              DurationBuilder(
                builder: (_, duration) => ShowShaderDemo(
                  title: 'Time based Voronoi',
                  sample: FragmentSamples.voronoiTime,
                  uniforms: (transform) => [
                    Transform2DUniform(transform: transform),
                    TimeUniforms(value: duration.inSecondsDecimal)
                  ],
                ),
              ),
            ],
          ),
          const WelcomeText(
            text: '2D Gradient noise',
          ),
          ShaderDemoList(
            children: [
              ShowShaderDemo(
                title: 'Nearest Neighbour',
                sample: FragmentSamples.gradientNoise2dNearest,
                uniforms: (transform) => [
                  Transform2DUniform(transform: transform),
                ],
              ),
              ShowShaderDemo(
                title: 'Bilinear Straight Simple',
                sample: FragmentSamples.gradientNoise2dStraightSimple,
                uniforms: (transform) => [
                  Transform2DUniform(transform: transform),
                ],
              ),
              ShowShaderDemo(
                title: 'Bilinear Straight Dot',
                sample: FragmentSamples.gradientNoise2dStraightDot,
                uniforms: (transform) => [
                  Transform2DUniform(transform: transform),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
