import 'dart:ui' show FragmentProgram;

typedef FragmentMap = Map<FragmentSamples, FragmentProgram>;

enum FragmentSamples {
  //noiseGradient("assets/shaders/noise_gradient.glsl"),
  //truchetTiling("assets/shaders/truchet_tiling.glsl"),
  //debug("assets/shaders/debug.glsl"),
  //noiseTypes("assets/shaders/noise_types.glsl"),
  //scatteredSemicircles("assets/shaders/scattered_semicircles.glsl"),
  whiteNoise("assets/shaders/noise/white_noise.frag"),
  whiteNoiseColor("assets/shaders/noise/white_noise_color.frag"),
  whiteNoiseColorCell("assets/shaders/noise/white_noise_color_cell.frag"),
  voronoi("assets/shaders/voronoi/voronoi.frag"),
  voronoiTime("assets/shaders/voronoi/voronoi_time.frag"),
  gradientNoise2dNearest("assets/shaders/noise/gradient/2d/nearest.frag"),
  gradientNoise2dStraightSimple("assets/shaders/noise/gradient/2d/straight_simple.frag"),
  gradientNoise2dStraightDot("assets/shaders/noise/gradient/2d/straight_dot.frag");

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