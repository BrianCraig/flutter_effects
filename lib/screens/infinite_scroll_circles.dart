import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shader_toy/model/fragment_samples.dart';
import 'package:shader_toy/shader_library.dart';

class InfiniteScrollCirclesScreen extends StatelessWidget {
  const InfiniteScrollCirclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScrollController>(
      create: (_) => ScrollController(),
      child: const Content(),
    );
  }
}

class ScatteredSemicirclesUniforms extends CustomUniforms {
  final Color background;
  final Color line;
  final bool useSmooth;

  ScatteredSemicirclesUniforms({
    required this.background,
    required this.line,
    required this.useSmooth,
  });

  @override
  void setUniforms(int baseIndex, FragmentShader shader) {
    shader.setRGBAColor(baseIndex, background);
    shader.setRGBAColor(baseIndex + 4, line);
    shader.setFloat(baseIndex + 8, useSmooth ? 1.0 : 0.0);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScatteredSemicirclesUniforms &&
          runtimeType == other.runtimeType &&
          background == other.background &&
          line == other.line &&
          useSmooth == other.useSmooth;

  @override
  int get hashCode => background.hashCode ^ line.hashCode ^ useSmooth.hashCode;
}

class Content extends StatelessWidget {
  const Content({super.key});

  @override
  Widget build(BuildContext context) {
    final sc = context.read<ScrollController>();
    final mq = MediaQuery.of(context);
    final divider = mq.size.height * (mq.size.width / mq.size.height);
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red.withAlpha(100),
              Colors.green.withAlpha(100),
              Colors.blue.withAlpha(100),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FragmentShaderPaint(
          fragmentProgram: context
              .watch<FragmentMap>()[FragmentSamples.scatteredSemicircles]!,
          uniforms: (double time) {
            final double sp =
                sc.hasClients ? sc.offset : sc.initialScrollOffset;
            return FragmentUniforms(
              transformation: Matrix4.identity()
                ..translate(
                  0.0,
                  sp / divider,
                ),
              time: time * .02,
              custom: ScatteredSemicirclesUniforms(
                  background: Colors.transparent,
                  line: const Color.fromARGB(255, 255, 255, 255),
                  useSmooth: false),
            );
          },
          child: ListView.builder(
            controller: sc,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text(
                'Hi this is $index, go back.',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
