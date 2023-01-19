import 'package:flutter/material.dart';
import 'package:flutter_effects/model/fragment_samples.dart';
import 'package:flutter_effects/model/transform_2d.dart';
import 'package:flutter_effects/shader_library.dart';
import 'package:flutter_effects/widgets/transform_gesture_detector.dart';
import 'package:provider/provider.dart';

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
            fragmentProgram: context.watch<FragmentMap>()[sample]!,
            uniforms: uniforms(transform),
            child: SizedBox(
              height: 320,
              width: 480,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: const Color.fromRGBO(255, 255, 255, 0.8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Translation: ${transform.translation}'),
                      Text('Scale: ${transform.scale}'),
                      Text('Rotation: ${transform.rotation}'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
