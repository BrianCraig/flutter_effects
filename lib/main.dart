import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shader_toy/shader_decoration.dart';

part 'main.g.dart';

late DateTime now;

late FragmentProgram fp;

void main() async {
  now = DateTime.now();
  fp = await FragmentProgram.fromAsset('assets/flutter-shaders/red-original-lol.glsl');
  runApp(const FlutterApp());
}

const bigText = '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit. In a neque mi. Nam ornare fringilla lorem, sed condimentum lorem gravida quis. Ut non mollis nunc, quis lobortis est. Aliquam vel rutrum felis, vel blandit diam. Duis maximus nisl elit. Mauris blandit ac tortor a hendrerit. Praesent pretium ligula non risus tincidunt, sed luctus nunc condimentum. Sed vel cursus leo. Phasellus euismod enim ut nisl semper, a facilisis justo ultrices. Mauris at iaculis tellus, at dignissim risus. Morbi neque justo, viverra eget ipsum sed, bibendum consectetur libero. Vestibulum aliquam fringilla auctor. Vivamus quam neque, iaculis at nunc vel, gravida scelerisque sem. Etiam efficitur luctus eros, volutpat sodales massa varius sed. Pellentesque nec vehicula ipsum. Maecenas consectetur tellus sit amet quam tempus cursus.

Donec finibus lectus non eros condimentum, semper consequat ex interdum. Duis eget diam eget tellus porta dictum. Fusce sodales pretium odio ac vehicula. Phasellus rhoncus sapien in fringilla mattis. Donec elit quam, luctus vel lorem id, dictum rutrum velit. Aenean eleifend ut sapien et porttitor. Phasellus ipsum ex, viverra ut orci eu, vestibulum tincidunt ex. Etiam est turpis, fermentum at venenatis et, commodo eget lectus. Donec mattis suscipit magna, in vehicula justo molestie eu.

Donec eu dolor posuere, convallis ex vitae, feugiat nunc. Aenean augue lacus, sollicitudin vitae ligula ac, consectetur ornare urna. Aliquam erat volutpat. Nam sapien quam, condimentum ac ligula at, elementum accumsan sem. Duis vitae dui non nisi lacinia lacinia congue quis purus. Pellentesque dictum ipsum vel ullamcorper dapibus. Etiam pretium bibendum sagittis.

Nullam gravida tincidunt est quis ultrices. Fusce at posuere tortor, sit amet convallis lacus. Nullam id interdum diam. Vestibulum euismod turpis in turpis tempus, eu lobortis lectus commodo. Nunc id ligula tristique, elementum est nec, varius tortor. Vestibulum vitae aliquam sem. Vestibulum dictum lobortis placerat.

Vivamus faucibus augue a tristique finibus. In sollicitudin massa sodales sollicitudin porta. Integer at feugiat est. Pellentesque sem mi, varius eget lorem ut, feugiat varius ligula. Morbi sit amet dapibus erat, ut laoreet eros. Nunc pulvinar sem a diam tempus sollicitudin. Curabitur pretium, ex a mattis accumsan, dolor felis accumsan metus, vitae lacinia nibh orci quis erat. Integer ullamcorper orci eu ante fermentum fermentum. Nulla dignissim ipsum in libero euismod, iaculis cursus ipsum interdum. Fusce purus elit, volutpat non risus at, egestas aliquet felis. Morbi elementum interdum orci, a sollicitudin purus consectetur nec. Suspendisse semper risus a nisi congue porta. Aenean sit amet lobortis velit. Maecenas ac tellus purus.
''';

class FlutterApp extends StatelessWidget {
  const FlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Test'),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const Text(bigText),
              for (final asset in okAssets)
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Lol(
                    key: Key(asset),
                    asset: asset,
                  ),
                ),
              Container(
                decoration: ShaderDecoration(fragmentProgram: fp),
                child: const Text(bigText),
              ),
              const Text(bigText),
              const Text(bigText),
              const Text(bigText),
            ],
          ),
        ),
      ),
    );
  }
}

class Lol extends StatelessWidget {
  final String asset;
  const Lol({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    final program = FragmentProgram.fromAsset(asset);

    return FutureBuilder<FragmentProgram>(
      builder: (_, snap) {
        if (snap.hasError) {
          return Text(
            snap.error.toString(),
            textDirection: TextDirection.ltr,
          );
        }
        if (!snap.hasData) return Container();
        return Column(
          children: [
            Text('$asset worked fine'),
            Flexible(
                child: ShaderTicker(
              shader: snap.data!.fragmentShader(),
            )),
          ],
        );
      },
      future: program,
    );
  }
}

class ShaderTicker extends StatefulWidget {
  const ShaderTicker({
    Key? key,
    required this.shader,
  }) : super(key: key);

  final FragmentShader shader;
  @override
  _ShaderTickerState createState() => _ShaderTickerState();
}

class _ShaderTickerState extends State<ShaderTicker>
    with SingleTickerProviderStateMixin {
  late final Ticker ticker;
  Duration changed = Duration.zero;

  @override
  void initState() {
    super.initState();
    ticker = createTicker((elapsed) {
      setState(() {
        changed = elapsed;
      });
    });
    ticker.start();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ShaderPainter(
        shader: widget.shader,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class ShaderPainter extends CustomPainter {
  final FragmentShader shader;

  ShaderPainter({required this.shader});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) {
      return;
    }
    shader.setFloat(
        0, now.difference(DateTime.now()).inMilliseconds.toDouble() / 1000);
    shader.setFloat(1, 1 / size.width);
    shader.setFloat(2, 1 / size.height);
    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
