import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_effects/flutter_effects.dart';
import 'package:provider/provider.dart';

Offset rotate(Offset original, double rotation) {
  double s = sin(rotation);
  double c = cos(rotation);

  return Offset(
      original.dx * c - original.dy * s, original.dx * s + original.dy * c);
}

class Transform2DGestureWidget extends StatefulWidget {
  final Widget child;

  const Transform2DGestureWidget({super.key, required this.child});

  @override
  State<Transform2DGestureWidget> createState() => _Transform2DGestureState();
}

class _Transform2DGestureState extends State<Transform2DGestureWidget> {
  // pre-gesture transform
  Transform2D initial = const Transform2D();
  // current modification
  Transform2D current = const Transform2D();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t2d = context.watch<ValueNotifier<Transform2D>>();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: (details) {
        initial = t2d.value;
      },
      onScaleUpdate: (details) {
        setState(() {
          final actualScale = initial.scale / details.scale;
          final actualRotation = initial.rotation - details.rotation;

          current = Transform2D(
            scale: current.scale,
            rotation: current.rotation,
            translation: current.translation +
                rotate(-details.focalPointDelta, actualRotation) * actualScale,
          );

          t2d.value = Transform2D(
            scale: actualScale,
            rotation: actualRotation,
            translation: initial.translation + current.translation,
          );
        });
      },
      onScaleEnd: (details) => {
        setState(() {
          current = const Transform2D();
        })
      },
      child: widget,
    );
  }
}
