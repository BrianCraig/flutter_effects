import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

part 'main.g.dart';

late DateTime now;

void main() {
  now = DateTime.now();
  runApp(const FlutterApp());
}

class FlutterApp extends StatelessWidget {
  const FlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Test'),
        ),
        body: ListView(
          children: [
            for (final asset in okAssets)
              SizedBox(
                width: 300,
                height: 300,
                child: Lol(
                  key: Key(asset),
                  asset: asset,
                ),
              ),
          ],
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
              child: ShaderTicker(shader: snap.data!.fragmentShader(),)
            ),
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
