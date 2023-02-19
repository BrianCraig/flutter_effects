import 'dart:ui' show FragmentProgram;

import 'package:flutter/widgets.dart';
import 'package:flutter_effects/flutter_effects.dart';
import 'package:flutter_effects_demo/providers.dart';
import 'package:flutter_effects_demo/widgets/controls.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<CustomUniforms> noop(WidgetRef _) => [];

List<CustomUniforms> splinesUniforms(WidgetRef ref) => [
      ColorUniforms(
        color: ref.watch(
          colorProvider('background'),
        ),
      ),
      ColorUniforms(
        color: ref.watch(
          colorProvider('line'),
        ),
      ),
    ];

enum ShaderSample {
  SimpleGradient(
    title: 'Simple Gradient',
    uri: 'packages/flutter_effects/shaders/simple_gradient.frag',
    description:
        'Simple time gradient based on the internal generation of Simplex Noise.',
    controls: [],
  ),
  Splines(
    title: 'Splines',
    uri: 'packages/flutter_effects/shaders/splines.frag',
    description: '',
    controls: [
      ColorControl(name: 'background'),
      ColorControl(name: 'line'),
    ],
    uniforms: splinesUniforms,
  ),
  Stripes(
    title: 'Stripes',
    uri: 'packages/flutter_effects/shaders/stripes.frag',
    description: '',
    controls: [
      ColorControl(name: 'background'),
      ColorControl(name: 'line'),
    ],
    uniforms: splinesUniforms,
  );

  final String uri;
  final String title;
  final String description;
  final List<Widget> controls;
  final List<CustomUniforms> Function(WidgetRef) uniforms;

  const ShaderSample({
    required this.uri,
    required this.title,
    required this.description,
    required this.controls,
    this.uniforms = noop,
  });
}

typedef FragmentMap = Map<ShaderSample, FragmentProgram>;

Future<FragmentMap> getFragmentPrograms() async {
  final FragmentMap map = {};
  for (var fs in ShaderSample.values) {
    map[fs] = await FragmentProgram.fromAsset(fs.uri);
  }
  return map;
}
