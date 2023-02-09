import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_effects/flutter_effects.dart';
import 'package:flutter_effects_demo/helpers.dart';
import 'package:flutter_effects_demo/providers.dart';
import 'package:flutter_effects_demo/shaders_data.dart';
import 'package:flutter_effects_demo/widgets/time_manager.dart';
import 'package:flutter_effects_demo/widgets/transform_gesture_detector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: TimeProvider(
        child: MyApp(),
      ),
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
    final time = Time.of(context);
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
            TimeUniforms(value: time.total.inSecondsDecimal),
          ],
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        T2DTranslateControl(),
        SizedBox(
          height: 8,
        ),
        T2DRotateControl(),
        SizedBox(
          height: 8,
        ),
        T2DScaleControl(),
        SizedBox(
          height: 8,
        ),
        TimeControl(),
      ],
    );
  }
}

class T2DTranslateControl extends ConsumerWidget {
  const T2DTranslateControl({super.key});

  @override
  Widget build(context, ref) {
    final t2d = ref.watch(Transform2DProvider);
    return ShaderControl(
      title: 'Translate',
      controls: [
        ShaderControlValue(value: t2d.translation.dx.decimals(3).toString()),
        ShaderControlValue(value: t2d.translation.dy.decimals(3).toString()),
      ],
      onReset: () => ref.read(Transform2DProvider.notifier).state =
          t2d.clone(translation: Offset.zero),
    );
  }
}

class T2DRotateControl extends ConsumerWidget {
  const T2DRotateControl({super.key});

  @override
  Widget build(context, ref) {
    final t2d = ref.watch(Transform2DProvider);
    return ShaderControl(
      title: 'Rotate',
      controls: [
        ShaderControlValue(value: t2d.rotation.decimals(3).toString()),
        ShaderControlButton(
          onPressed: () {
            ref.read(Transform2DProvider.notifier).state +=
                const Transform2D(rotation: 1 / 6 * pi);
          },
          icon: Icons.turn_left,
        ),
        ShaderControlButton(
          onPressed: () {
            ref.read(Transform2DProvider.notifier).state +=
                const Transform2D(rotation: -1 / 6 * pi);
          },
          icon: Icons.turn_right,
        )
      ],
      onReset: () =>
          ref.read(Transform2DProvider.notifier).state = t2d.clone(rotation: 0),
    );
  }
}

class TimeControl extends ConsumerWidget {
  const TimeControl({super.key});

  @override
  Widget build(context, ref) {
    final time = Time.of(context);
    return ShaderControl(
      title: 'Time',
      controls: [
        ShaderControlValue(
            value: time.total.inSecondsDecimal.decimals(2).toString()),
        ShaderControlButton(
          onPressed: () {
            time.toggle();
            (context as Element).markNeedsBuild();
          },
          icon: time.isActive ? Icons.pause : Icons.play_arrow,
        ),
        ShaderControlButton(
          onPressed: () {
            time.tps.multiplier *= 1 / 1.25;
          },
          icon: Icons.remove,
        ),
        ShaderControlButton(
          onPressed: () {
            time.tps.multiplier *= 1.25;
          },
          icon: Icons.add,
        ),
      ],
      onReset: () => time.total = Duration.zero,
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
        ShaderControlValue(value: t2d.scale.decimals(3).toString()),
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
        ),
      ],
      onReset: () =>
          ref.read(Transform2DProvider.notifier).state = t2d.clone(scale: 1),
    );
  }
}

class ShaderControl extends StatelessWidget {
  final String title;
  final List<Widget> controls;
  final void Function()? onReset;
  const ShaderControl({
    super.key,
    required this.title,
    required this.controls,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(
              width: 8,
            ),
            if (onReset != null)
              GestureDetector(
                onTap: onReset,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.black87,
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
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
