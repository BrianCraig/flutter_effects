import 'dart:io';

void main(List<String> args) {
  compile();
}

List<String> outputs = [
  'metal-desktop',
  'metal-ios',
  'opengl-desktop',
  'opengl-es',
  'runtime-stage-gles',
  'runtime-stage-metal',
  'sksl',
  'vulkan',
];

/// Executes the compilation process
Future<void> compile() async {
  /// Determine the project directory
  final directory = Directory('${Directory.current.path}/assets');

  /// Pick compiler and writer
  /// General single pass
  for (final file in directory.allGlslFiles) {
    try {
      final res = await Process.run(
        '/home/bri/sdk/flutter/bin/cache/artifacts/engine/linux-x64/impellerc',
        [
          '--input-type=frag',
        ],
      );

      print(res.stderr.toString());
      print(res.stdout.toString());
      print(res.exitCode);
    } catch (e) {
      print(e);
    } finally {
      print('correctly compiled: $file');
    }
  }
}

extension FindGlslFiles on Directory {
  /// Returns recursively all .glsl files
  List<File> get allGlslFiles => listSync(recursive: true)
      .where((entity) => entity is File && entity.path.endsWith('.glsl'))
      .map((e) => e as File)
      .toList();
}
