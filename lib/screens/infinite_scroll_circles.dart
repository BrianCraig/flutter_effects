import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shader_toy/main.dart';
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

class Content extends StatelessWidget {
  const Content({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FragmentShaderPaint(
        fragmentProgram:
            context.watch<FragmentMap>()[FragmentSamples.noiseTypes]!,
        uniforms: (BuildContext context, double time) {
          final sc =context.read<ScrollController>();
          final double sp = sc.hasClients ? sc.offset : sc.initialScrollOffset;
          return FragmentUniforms(
              transformation: Matrix4.identity()
                ..translate(0.0, sp / 600),
              time: time);
        },
        child: ListView.builder(
          itemCount: 100,
          controller: context.read<ScrollController>(),
          itemBuilder: (context, index) => Text('Hi this is $index'),
        ),
      ),
    );
  }
}
