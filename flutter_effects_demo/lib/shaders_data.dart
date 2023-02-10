import 'dart:ui' show FragmentProgram;

import 'package:flutter/widgets.dart';

enum ShaderSample {
  SimpleGradient(
    title: 'Simple Gradient',
    uri: 'packages/flutter_effects/shaders/simple_gradient.frag',
    description: 'Simple time gradient based on the internal generation of Simplex Noise.',
    controls: [],
    provider: SizedBox(),
  ),
  Splines(
    title: 'Splines',
    uri: 'packages/flutter_effects/shaders/splines.frag',
    description: '',
    controls: [],
    provider: SizedBox(),
  );

  final String uri;
  final String title;
  final String description;
  final List<Widget> controls;
  final Widget provider;

  const ShaderSample({
    required this.uri,
    required this.title,
    required this.description,
    required this.controls,
    required this.provider,
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
