import 'package:flutter/material.dart';
import 'package:flutter_effects/flutter_effects.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shaders_data.dart';

final ShaderSampleProvider = StateProvider<ShaderSample>(
  (ref) => ShaderSample.SimpleGradient,
);

final FragmentProgramsProvider = FutureProvider<FragmentMap>((ref) async {
  return getFragmentPrograms();
});

final Transform2DProvider = StateProvider<Transform2D>(
  (_) => const Transform2D(),
);

final colorProvider = StateProvider.family<Color, String>((ref, id) => Colors.black);
