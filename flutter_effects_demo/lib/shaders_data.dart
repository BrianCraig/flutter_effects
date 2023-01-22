import 'dart:ui' show FragmentProgram;

import 'package:flutter/widgets.dart';

enum ShaderSample {
  SimplexGradient(
    title: 'Simplex Gradients',
    uri: 'packages/flutter_effects/shaders/noise/simplex/2_s.frag',
    controls: [],
    provider: SizedBox(),
  ),
  StepsGradient(
    title: 'Steps Gradients',
    uri: 'packages/flutter_effects/shaders/noise/simplex/2_s.frag',
    controls: [],
    provider: SizedBox(),
  );

  final String uri;
  final String title;
  final List<Widget> controls;
  final Widget provider;

  const ShaderSample({
    required this.uri,
    required this.title,
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
