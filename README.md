## Example (~release.10)
[simplescreenrecorder-2022-12-17_22.35.29.webm](https://user-images.githubusercontent.com/4956754/208273096-cadbfde8-f1ac-4cf1-8fcb-dd29eceeafb8.webm)

Releases for `Windows` and `Linux` avaiable on repository.

## Todo
 - ~~Add `FragmentProgram.fromAsset()` loading strategy.~~
 - Add separation logic for Standard + Custom (per-fp) uniforms.
   - ~~Implement~~.
   - Documentate.
 - ~~Define~~ Add documentation for default shader uniforms
   - layout(location = 0) uniform vec2 i_resolution;
   - layout(location = 1) uniform mat4 i_transformation;
   - layout(location = 2) uniform float i_time;
 - Add documentation for own shaders creation.
 - Generate a testing fragment shader, with delimitations, pixel grid and time debugging.
 - Separate package + demo.
 - Licensing and examples for package.

## Example

~~~dart
FragmentProgramBuilder(
  future: FragmentProgram.fromAsset('assets/my_shader.glsl'),
  builder: (BuildContext context, FragmentProgram fragmentProgram) =>
      FragmentShaderPaint(
    fragmentProgram: fragmentProgram,
    uniforms: (double time) => FragmentUniforms(
      transformation: Matrix4.identity(),
      time: time,
      custom: const MyCustomUniforms(
        firstColor: Color.fromRGBO(255, 0, 0, 1.0),
        secondColor: Color.fromRGBO(0, 0, 255, 1.0),
        angle: pi / 2,
      ),
    ),
    child: myChild,
  ),
  child: myChild,
)
~~~