import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_effects/flutter_effects.dart';
import 'package:flutter_effects_demo/shaders_data.dart';
import 'package:provider/provider.dart';

extension ListFiller<T> on List<T> {
  List<T> fillBetween(T element) {
    return List.generate(
        max(length * 2 - 1, 0), (index) => index % 2 == 0 ? this[index ~/ 2] : element);
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ValueNotifier(
            ShaderSample.SimplexGradient,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Effects Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ss = context.watch<ValueNotifier<ShaderSample>>().value;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ValueNotifier(
            const Transform2D(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ValueNotifier(
            Duration.zero,
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(ss.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Expanded(child: ShaderSelector()),
                ShaderControls(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShaderSelector extends StatelessWidget {
  const ShaderSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final ss = context.watch<ValueNotifier<ShaderSample>>();

    return Row(
      children: ShaderSample.values
          .map(
            // ignore: unnecessary_cast
            (sample) => TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(),
                foregroundColor: Colors.black,
              ),
              onPressed: sample == ss.value
                  ? null
                  : () {
                      ss.value = sample;
                    },
              child: Text(sample.title),
            ) as Widget,
          )
          .toList()
          .fillBetween(
            const SizedBox(
              width: 8,
            ),
          ),
    );
  }
}

class ShaderControls extends StatelessWidget {
  const ShaderControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        ShaderControl(
          title: 'translate',
          controls: [],
        ),
        SizedBox(
          height: 8,
        ),
        ShaderControl(
          title: 'rotate',
          controls: [],
        ),
        SizedBox(
          height: 8,
        ),
        T2DScaleControl(),
        SizedBox(
          height: 8,
        ),
        ShaderControl(
          title: 'time',
          controls: [],
        ),
      ],
    );
  }
}

class T2DScaleControl extends StatelessWidget {
  const T2DScaleControl({super.key});

  @override
  Widget build(BuildContext context) {
    final t2d = context.watch<ValueNotifier<Transform2D>>();
    return ShaderControl(
      title: 'Scale',
      controls: [
        ShaderControlValue(value: t2d.value.scale.toString()),
        ShaderControlButton(
          onPressed: () {
            t2d.value += const Transform2D(scale: 1 / 1.1);
          },
          icon: Icons.remove,
        ),
        ShaderControlButton(
          onPressed: () {
            t2d.value += const Transform2D(scale: 1.1);
          },
          icon: Icons.add,
        )
      ],
    );
  }
}

class ShaderControl extends StatelessWidget {
  final String title;
  final List<Widget> controls;
  const ShaderControl({
    super.key,
    required this.title,
    required this.controls,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.black87,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.black87,
          child: SizedBox(
            width: 280,
            height: 32,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: controls.fillBetween(
                const SizedBox(
                  width: 8,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ShaderControlValue extends StatelessWidget {
  final String value;

  const ShaderControlValue({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ShaderControlButton extends StatelessWidget {
  final IconData icon;

  final void Function() onPressed;
  const ShaderControlButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: Size.zero,
        iconColor: Colors.black,
        shape: const RoundedRectangleBorder(),
      ),
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
