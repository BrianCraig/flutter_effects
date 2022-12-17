import 'package:flutter/material.dart';
import 'package:shader_toy/main.dart';
import 'package:shader_toy/shaders/truchet_tiling.dart';
import 'package:shader_toy/time_animation_builder.dart';

class TruchetTillingScreen extends StatelessWidget {
  const TruchetTillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TimeAnimationBuilder(
        builder: (context, double time, child) => TruchetTilingPaint(
          fragmentProgram: truchetTilingProgram,
          time: time,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Truchet Tilling Shader',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Align(
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tight(const Size(400, 60)),
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, ),
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
          ),
        ),
      ),
    );
  }
}
