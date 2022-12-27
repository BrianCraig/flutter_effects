import 'dart:ui' show FragmentProgram;

typedef FragmentMap = Map<FragmentSamples, FragmentProgram>;

enum FragmentSamples {
  noiseGradient("assets/shaders/noise_gradient.glsl"),
  truchetTiling("assets/shaders/truchet_tiling.glsl"),
  debug("assets/shaders/debug.glsl"),
  noiseTypes("assets/shaders/noise_types.glsl"),
  scatteredSemicircles("assets/shaders/scattered_semicircles.glsl"),
  noiseRandomPure("assets/shaders/noise/random_pure.frag");

  final String uri;

  const FragmentSamples(this.uri);
}

Future<FragmentMap> getFragmentPrograms() async {
  final FragmentMap map = {};
  for (var fs in FragmentSamples.values) {
    map[fs] = await FragmentProgram.fromAsset(fs.uri);
  }
  return map;
}