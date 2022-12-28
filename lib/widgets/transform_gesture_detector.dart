import 'package:flutter/material.dart';
import 'package:shader_toy/model/transform_2d.dart';

class Transform2DGesture extends StatefulWidget {
  final Widget Function(BuildContext context, Transform2D transform2d) builder;

  const Transform2DGesture({super.key, required this.builder});

  @override
  State<Transform2DGesture> createState() => _Transform2DGestureState();
}

class _Transform2DGestureState extends State<Transform2DGesture> {
  Transform2D transform2d = const Transform2D();
  Offset translation = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (details) => {
        setState(() {
          translation += -details.focalPointDelta;
          transform2d = Transform2D(translation: translation);
        })
      },
      child: widget.builder(context, transform2d),
    );
  }
}
