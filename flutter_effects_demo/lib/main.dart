import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_effects/flutter_effects.dart';
import 'package:flutter_effects_demo/providers.dart';
import 'package:flutter_effects_demo/shaders_data.dart';
import 'package:flutter_effects_demo/widgets/transform_gesture_detector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension ListFiller<T> on List<T> {
  List<T> fillBetween(T element) {
    return List.generate(max(length * 2 - 1, 0),
        (index) => index % 2 == 0 ? this[index ~/ 2] : element);
  }
}

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programs = ref.watch(FragmentProgramsProvider);
    return MaterialApp(
      title: 'Flutter Effects Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: programs.when(
        data: (_) => const MyHomePage(),
        error: (error, _) => Text(error.toString()),
        loading: () => const Text('loading fragments'),
      ),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ss = ref.watch(ShaderSampleProvider);
    final t2d = ref.watch(Transform2DProvider);
    final programs = ref.watch(FragmentProgramsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(ss.title),
      ),
      body: Transform2DGestureWidget(
        value: t2d,
        onChange: (v) => ref.read(Transform2DProvider.notifier).state = v,
        child: FragmentShaderPaint(
          fragmentProgram: programs.value![ss]!,
          uniforms: [
            Transform2DUniform(transform: t2d),
            const TimeUniforms(value: 1),
          ],
          child: Padding(
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
      ),
    );
  }
}

class ShaderSelector extends ConsumerWidget {
  const ShaderSelector({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final ss = ref.watch(ShaderSampleProvider);
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
              onPressed: sample == ss
                  ? null
                  : () {
                      ref.read(ShaderSampleProvider.notifier).state = sample;
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

class T2DScaleControl extends ConsumerWidget {
  const T2DScaleControl({super.key});

  @override
  Widget build(context, ref) {
    final t2d = ref.watch(Transform2DProvider);
    return ShaderControl(
      title: 'Scale',
      controls: [
        ShaderControlValue(value: t2d.scale.toString()),
        ShaderControlButton(
          onPressed: () {
            ref.read(Transform2DProvider.notifier).state +=
                const Transform2D(scale: 1 / 1.1);
          },
          icon: Icons.remove,
        ),
        ShaderControlButton(
          onPressed: () {
            ref.read(Transform2DProvider.notifier).state +=
                const Transform2D(scale: 1.1);
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
