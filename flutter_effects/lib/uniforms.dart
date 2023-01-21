import 'dart:ui' show Color, FragmentShader;

import 'package:flutter/rendering.dart' show Matrix4;
import 'package:flutter_effects/shader_setter.dart';
import 'package:flutter_effects/transform_2d.dart';

abstract class CustomUniforms {
  const CustomUniforms();

  void setUniforms(int baseIndex, FragmentShader shader);

  int get size;
}

class EmptyCustomUniforms extends CustomUniforms {
  const EmptyCustomUniforms();

  @override
  void setUniforms(int baseIndex, FragmentShader shader) {}

  @override
  get size => 0;
}

class FloatUniforms extends CustomUniforms {
  final double value;
  const FloatUniforms({this.value = 0.0});

  @override
  void setUniforms(int baseIndex, FragmentShader shader) {
    shader.setFloat(baseIndex, value);
  }

  @override
  int get size => 1;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FloatUniforms &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

typedef TimeUniforms = FloatUniforms;

class TransformUniforms extends CustomUniforms {
  final Matrix4 matrix;
  const TransformUniforms({required this.matrix});

  @override
  void setUniforms(int baseIndex, FragmentShader shader) {
    shader.setM4(baseIndex, matrix);
  }

  @override
  int get size => 16;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransformUniforms &&
          runtimeType == other.runtimeType &&
          matrix == other.matrix;

  @override
  int get hashCode => matrix.hashCode;
}

class ColorUniforms extends CustomUniforms {
  final Color color;
  const ColorUniforms({required this.color});

  @override
  void setUniforms(int baseIndex, FragmentShader shader) {
    shader.setRGBAColor(baseIndex, color);
  }

  @override
  int get size => 4;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorUniforms &&
          runtimeType == other.runtimeType &&
          color == other.color;

  @override
  int get hashCode => color.hashCode;
}

class Transform2DUniform extends CustomUniforms {
  final Transform2D transform;
  const Transform2DUniform({
    this.transform = const Transform2D()});

  @override
  void setUniforms(int baseIndex, FragmentShader shader) {
    shader.setOffset(baseIndex, transform.translation);
    shader.setFloat(baseIndex + 2, transform.rotation);
    shader.setFloat(baseIndex + 3, transform.scale);
  }

  @override
  int get size => 4;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transform2DUniform &&
          runtimeType == other.runtimeType &&
          transform == other.transform ;

  @override
  int get hashCode => transform.hashCode;
}