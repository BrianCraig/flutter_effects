import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shader_toy/model/fragment_samples.dart';
import 'package:shader_toy/shader_library.dart';

// TODO: it would be good to add a pinch/zoom, could be done using something like 'matrix_gesture_detector' lib.

class ShowShaderDemo extends StatelessWidget {
  final String title;
  final FragmentSamples sample;
  final FragmentShaderPaintCallback uniforms;
  const ShowShaderDemo(
      {super.key,
      required this.title,
      required this.sample,
      required this.uniforms});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 16,
        ),
        FragmentShaderPaint(
          fragmentProgram:
              context.watch<FragmentMap>()[sample]!,
          uniforms: uniforms,
          child: const SizedBox(
            height: 320,
            width: 480,
          ),
        ),
      ],
    );
  }
}
