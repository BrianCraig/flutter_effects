import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:flutter_effects/flutter_effects.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shaders_data.dart';

final shaderSampleProvider = StateProvider<ShaderSample>(
  (ref) => ShaderSample.SimpleGradient,
);

final fragmentProgramsProvider = FutureProvider<FragmentMap>((ref) async {
  return getFragmentPrograms();
});

final transform2DProvider = StateProvider<Transform2D>(
  (_) => const Transform2D(),
);

final colorProvider = StateProvider.family<Color, String>((ref, id) => Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0));
