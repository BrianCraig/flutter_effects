import 'dart:ui';

class Transform2D {
  final Offset translation;
  final double rotation;
  final double scale;
  const Transform2D({
    this.translation = Offset.zero,
    this.rotation = 0,
    this.scale = 1.0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transform2D &&
          runtimeType == other.runtimeType &&
          translation == other.translation &&
          rotation == other.rotation &&
          scale == other.scale;

  Transform2D operator +(Transform2D other) => Transform2D(
        translation: translation + other.translation,
        scale: scale * other.scale,
        rotation: rotation + other.rotation,
      );

  Transform2D clone({
    Offset? translation,
    double? rotation,
    double? scale,
  }) =>
      Transform2D(
        translation: translation ?? this.translation,
        scale: scale ?? this.scale,
        rotation: rotation ?? this.rotation,
      );

  @override
  int get hashCode => translation.hashCode ^ rotation.hashCode ^ scale.hashCode;
}
