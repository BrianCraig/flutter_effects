
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shader_toy/main.dart';
import 'package:shader_toy/shader_library.dart';

class NoiseTypesScreen extends StatelessWidget {
  const NoiseTypesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var container = Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Noise Types',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints.tight(const Size(400, 60)),
              child: OutlinedButton(
                onPressed: () => Navigator.pop(
                  context,
                ),
                style: const ButtonStyle(),
                child: Text(
                  'Back',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          )
        ],
      ),
    );

    return Scaffold(
      body: FragmentShaderPaint(
        fragmentProgram:
            context.watch<FragmentMap>()[FragmentSamples.noiseTypes]!,
        uniforms: (BuildContext context, double time) => FragmentUniforms(
          transformation: Matrix4.identity()..scale(1.8),
          time: time * 0.5,
        ),
        child: container,
      ),
    );
  }
}
