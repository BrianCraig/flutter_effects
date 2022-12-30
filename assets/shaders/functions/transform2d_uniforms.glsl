uniform vec2 i_translation;
uniform float i_rotation;
uniform float i_scale;

vec2 rotate(vec2 original, float rotation) {
  float s = sin(rotation);
  float c = cos(rotation);

  return vec2(original.x * c - original.y * s,  original.x * s + original.y * c);
}

vec2 uv_transform2d() {
    // Center the UV
    vec2 uv = FlutterFragCoord() - (i_resolution / 2);

    uv = rotate(uv, i_rotation);

    uv *= i_scale; 

    uv += i_translation; 

    return uv;
}