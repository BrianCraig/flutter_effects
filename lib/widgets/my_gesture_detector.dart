import 'package:flutter/material.dart';

class MatrixGesture extends StatefulWidget {
  final Widget Function(BuildContext context, Matrix4 matrix) builder;
  const MatrixGesture({super.key, required this.builder});

  @override
  State<MatrixGesture> createState() => _MatrixGestureState();
}

class _MatrixGestureState extends State<MatrixGesture> {
  late Matrix4 matrix = Matrix4.identity();
  Offset translation = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (details) => {
        setState(() {
          translation += details.focalPointDelta * -.01;
          matrix = Matrix4.identity()..translate(translation.dx, translation.dy);
        })
      },
      child: widget.builder(context, matrix),
    );
  }
}
