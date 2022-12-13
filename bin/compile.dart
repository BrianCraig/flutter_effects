import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  compile();
}

List<String> platforms = [
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

  List<dynamic> jsonOutput = [];
  List<String> okAssets = [];

  for (final file in directory.allGlslFiles) {
    int totalOk = 0;
    int totalError = 0;
    List<Map<String, dynamic>> status = [];

    for (final platform in platforms) {
      for (final json in [false, true]) {
        for (final iplr in [false, true]) {
          try {
            final baseName =
                '${file.absolute.path}.$platform.${iplr ? 'iplr' : 'no-iplr'}.${json ? 'json' : 'no-json'}';
            final res = await Process.run(
              '/home/bri/sdk/flutter/bin/cache/artifacts/engine/linux-x64/impellerc',
              [
                '--$platform',
                '--input=${file.absolute.path}',
                '--input-type=frag',
                '--sl=$baseName',
                '--spirv=$baseName.spirv',
                if (json) '--json',
                if (iplr) '--iplr'
              ],
            );
            if (res.exitCode == 0) {
              totalOk++;
              final assetUri =
                  '${file.path.replaceFirst(Directory.current.path, '').replaceFirst('/', '')}.$platform.${iplr ? 'iplr' : 'no-iplr'}.${json ? 'json' : 'no-json'}';
              okAssets.add(assetUri);
            } else {
              totalError++;
            }
            Map<String, dynamic> runInfo = {
              'status': res.exitCode == 0,
              'exitCode': res.exitCode,
              'platform': platform,
              'json': json,
              'iplr': iplr,
              'stderr': res.stderr.toString(),
              'stdout': res.stdout.toString(),
            };
            status.add(runInfo);
            print('$baseName ${res.exitCode == 0 ? 'ok' : 'fail'}');
          } catch (e) {
            final baseName =
                '${file.absolute.path}.$platform.${iplr ? 'iplr' : 'no-iplr'}.${json ? 'json' : 'no-json'}';
            print('error while compiling $baseName : $e');
          }
        }
      }
    }
    jsonOutput.add({
      'totalOk': totalOk,
      'totalError': totalError,
      'file': file.absolute.path,
      'status': status,
    });
  }
  File('shader-compilation.json').openWrite(mode: FileMode.write)
    ..write(jsonEncode(jsonOutput))
    ..close();

  File('shader-ok.json').openWrite(mode: FileMode.write)
    ..write(jsonEncode(okAssets))
    ..close();
}

extension FindGlslFiles on Directory {
  /// Returns recursively all .glsl files
  List<File> get allGlslFiles => listSync(recursive: true)
      .where((entity) => entity is File && entity.path.endsWith('.glsl'))
      .map((e) => e as File)
      .toList();
}
