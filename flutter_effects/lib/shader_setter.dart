import 'dart:ui' show Offset, Size, Color, FragmentShader;

import 'package:flutter/rendering.dart' show HSLColor, Matrix4;

extension ShaderSetter on FragmentShader {
  /// Sets the mat4 uniform at [index] to Matrix4 [value].
  /// It takes 16 float spaces.
  void setM4(int index, Matrix4 value) {
    for (var row = 0; row < 4; row++) {
      for (var col = 0; col < 4; col++) {
        setFloat(index + ((row * 4) + col), value.entry(row, col));
      }
    }
  }

  /// Sets the vec2 uniform at [index] to Size [value].
  /// It takes 2 float spaces.
  void setOffset(int index, Offset value) {
    setFloat(index, value.dx);
    setFloat(index + 1, value.dy);
  }

  /// Sets the vec2 uniform at [index] to Size [value].
  /// It takes 2 float spaces.
  void setSize(int index, Size value) {
    setFloat(index, value.width);
    setFloat(index + 1, value.height);
  }

  /// Sets the vec3 uniform at [index] to RGB [value].
  /// It takes 3 float spaces.
  void setRGBColor(int index, Color value) {
    setFloat(index, value.red / 255);
    setFloat(index + 1, value.green / 255);
    setFloat(index + 2, value.blue / 255);
  }

  /// Sets the vec4 uniform at [index] to RGB [value].
  /// It takes 4 float spaces.
  void setRGBAColor(int index, Color value) {
    setFloat(index, value.red / 255);
    setFloat(index + 1, value.green / 255);
    setFloat(index + 2, value.blue / 255);
    setFloat(index + 3, value.opacity);
  }

  /// Sets the vec4 uniform at [index] to HSLA [value].
  /// It takes 4 float spaces.
  void setHSLColor(int index, HSLColor value) {
    setFloat(index, value.hue / 360);
    setFloat(index + 1, value.saturation);
    setFloat(index + 2, value.lightness);
    setFloat(index + 3, value.alpha);
  }
}