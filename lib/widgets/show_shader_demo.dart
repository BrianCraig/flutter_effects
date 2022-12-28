import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shader_toy/model/fragment_samples.dart';
import 'package:shader_toy/model/transform_2d.dart';
import 'package:shader_toy/shader_library.dart';
import 'package:shader_toy/widgets/transform_gesture_detector.dart';

// TODO: it would be good to add a pinch/zoom, could be done using something like 'matrix_gesture_detector' lib.

class ShowShaderDemo extends StatelessWidget {
  final String title;
  final FragmentSamples sample;
  final List<CustomUniforms> Function(Transform2D transform2d) uniforms;
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
        Transform2DGesture(
          builder: (context, transform) => FragmentShaderPaint(
            fragmentProgram:
                context.watch<FragmentMap>()[sample]!,
            uniforms: uniforms(transform),
            child: const SizedBox(
              height: 320,
              width: 480,
            ),
          ),
        ),
      ],
    );
  }
}
