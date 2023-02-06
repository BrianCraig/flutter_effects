import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_effects/flutter_effects.dart';

Offset rotate(Offset original, double rotation) {
  double s = sin(rotation);
  double c = cos(rotation);

  return Offset(
      original.dx * c - original.dy * s, original.dx * s + original.dy * c);
}

class Transform2DGestureWidget extends StatefulWidget {
  final Widget child;
  final void Function(Transform2D) onChange;
  final Transform2D value;

  const Transform2DGestureWidget(
      {super.key,
      required this.child,
      required this.onChange,
      required this.value});

  @override
  State<Transform2DGestureWidget> createState() => _Transform2DGestureState();
}

class _Transform2DGestureState extends State<Transform2DGestureWidget> {
  // pre-gesture transform
  Transform2D initial = const Transform2D();

  Transform2D current = const Transform2D();


  @override
  void initState() {
    initial = widget.value;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: (details) {
        initial = widget.value;
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

          widget.onChange(
            Transform2D(
              scale: actualScale,
              rotation: actualRotation,
              translation: initial.translation + current.translation,
            ),
          );
        });
      },
      onScaleEnd: (details) => {
        setState(() {
          current = const Transform2D();
        })
      },
      child: widget.child,
    );
  }
}
