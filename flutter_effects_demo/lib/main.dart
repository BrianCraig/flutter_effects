import 'package:flutter/material.dart';
import 'package:flutter_effects/flutter_effects.dart';
import 'package:flutter_effects_demo/helpers.dart';
import 'package:flutter_effects_demo/providers.dart';
import 'package:flutter_effects_demo/shaders_data.dart';
import 'package:flutter_effects_demo/widgets/controls.dart';
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
            ...(ss.uniforms(ref)),
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

class ShaderControls extends ConsumerWidget {
  const ShaderControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ss = ref.watch(ShaderSampleProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const T2DTranslateControl(),
        const T2DRotateControl(),
        const T2DScaleControl(),
        const TimeControl(),
        ...ss.controls,
      ].fillBetween(
        const SizedBox(
          height: 8,
        ),
      ),
    );
  }
}
