import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shader_toy/model/transform_2d.dart';

Offset rotate(Offset original, double rotation) {
  double s = sin(rotation);
  double c = cos(rotation);

  return Offset(
      original.dx * c - original.dy * s, original.dx * s + original.dy * c);
}

class Transform2DGesture extends StatefulWidget {
  final Widget Function(BuildContext context, Transform2D transform2d) builder;

  const Transform2DGesture({super.key, required this.builder});

  @override
  State<Transform2DGesture> createState() => _Transform2DGestureState();
}

class _Transform2DGestureState extends State<Transform2DGesture> {
  Offset translation = Offset.zero;

  double currentScale = 1.0;
  double currentRotation = 0.0;

  double totalScale = 1.0;
  double totalRotation = 0.0;

  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  Transform2D get transform2d => Transform2D(
              translation: translation,
              scale: totalScale * currentScale,
              rotation: totalRotation + currentRotation,
            );

  void onDrag(DragUpdateDetails details) {
    setState(() {
      FocusScope.of(context).requestFocus(focusNode);
      final actualScale = totalScale * currentScale;
      final actualRotation = totalRotation + currentRotation;

      translation += rotate(-details.delta, actualRotation) * actualScale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: focusNode,
      autofocus: true,
      onKeyEvent: (key) {
        if(key.character == '+'){
          setState(() {
            totalScale *= .66;
          });
        }
        if(key.character == '-'){
          setState(() {
            totalScale /= .66;
          });
        }
        if(key.character == '7'){
          setState(() {
            totalRotation += pi/12;
          });
        }
        if(key.character == '9'){
          setState(() {
            totalRotation -= pi/12;
          });
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onScaleUpdate: (details) => {
          setState(() {
            FocusScope.of(context).requestFocus(focusNode);
            currentScale = 1 / details.scale;
            currentRotation = -details.rotation;

            final actualScale = totalScale * currentScale;
            final actualRotation = totalRotation + currentRotation;

            translation +=
                rotate(-details.focalPointDelta, actualRotation) * actualScale;
          })
        },
        onScaleEnd: (details) => {
          setState(() {
            totalScale *= currentScale;
            totalRotation += currentRotation;
            currentScale = 1.0;
            currentRotation = 0;
          })
        },
        child: widget.builder(context, transform2d),
      ),
    );
  }
}
