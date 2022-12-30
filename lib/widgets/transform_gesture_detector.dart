import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shader_toy/model/transform_2d.dart';

Offset rotate(Offset original, double rotation) {
  double s = sin(rotation);
  double c = cos(rotation);

  return Offset(original.dx * c - original.dy * s,  original.dx * s + original.dy * c);
}

class Transform2DGesture extends StatefulWidget {
  final Widget Function(BuildContext context, Transform2D transform2d) builder;

  const Transform2DGesture({super.key, required this.builder});

  @override
  State<Transform2DGesture> createState() => _Transform2DGestureState();
}

class _Transform2DGestureState extends State<Transform2DGesture> {
  Transform2D transform2d = const Transform2D();
  Offset translation = Offset.zero;

  double currentScale = 1.0;
  double currentRotation = 0.0;

  double totalScale = 1.0;
  double totalRotation = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (details) => {
        setState(() {
          currentScale = 1/details.scale;
          currentRotation = -details.rotation;

          final actualScale = totalScale * currentScale;
          final actualRotation = totalRotation + currentRotation;

          translation += rotate(-details.focalPointDelta, actualRotation) * actualScale;

          transform2d = Transform2D(
            translation: translation,
            scale: actualScale,
            rotation: actualRotation,
          );
        })
      },
      onScaleEnd: (details) => {
        setState(() {
          totalScale *= currentScale;
          totalRotation += currentRotation;
        })
      },
      child: widget.builder(context, transform2d),
    );
  }
}
