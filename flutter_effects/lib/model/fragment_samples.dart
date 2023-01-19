import 'dart:ui' show FragmentProgram;

typedef FragmentMap = Map<FragmentSamples, FragmentProgram>;

enum FragmentSamples {
  //noiseGradient("lib/shaders/noise_gradient.glsl"),
  //truchetTiling("lib/shaders/truchet_tiling.glsl"),
  //debug("lib/shaders/debug.glsl"),
  //noiseTypes("lib/shaders/noise_types.glsl"),
  //scatteredSemicircles("lib/shaders/scattered_semicircles.glsl"),
  whiteNoise("lib/shaders/noise/white_noise.frag"),
  whiteNoiseColor("lib/shaders/noise/white_noise_color.frag"),
  whiteNoiseColorCell("lib/shaders/noise/white_noise_color_cell.frag"),
  voronoi("lib/shaders/voronoi/voronoi.frag"),
  voronoiTime("lib/shaders/voronoi/voronoi_time.frag"),
  gradientNoise2dNearest("lib/shaders/noise/gradient/2d/nearest.frag"),
  gradientNoise2dStraightSimple(
      "lib/shaders/noise/gradient/2d/straight_simple.frag"),
  gradientNoise2dStraightDot(
      "lib/shaders/noise/gradient/2d/straight_dot.frag"),
  simplex3d("lib/shaders/noise/simplex/2_s.frag"),
  gradientClouds("lib/shaders/gradient_clouds.frag");

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
