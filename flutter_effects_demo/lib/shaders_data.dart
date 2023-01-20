import 'package:flutter/widgets.dart';

enum ShaderSample {
  SimplexGradient(
    title: 'Simplex Gradients',
    uri: '',
    controls: [],
    provider: SizedBox(),
  ),
  StepsGradient(
    title: 'Steps Gradients',
    uri: '',
    controls: [],
    provider: SizedBox(),
  );

  final String uri;
  final String title;
  final List<Widget> controls;
  final Widget provider;

  const ShaderSample({
    required this.uri,
    required this.title,
    required this.controls,
    required this.provider,
  });
}
