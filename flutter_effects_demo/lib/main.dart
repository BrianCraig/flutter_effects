import 'package:flutter/material.dart';
import 'package:flutter_effects_demo/shaders_data.dart';
import 'package:provider/provider.dart';

extension ListFiller<T> on List<T> {
  List<T> fillBetween(T element) {
    return List.generate(
        length * 2 - 1, (index) => index % 2 == 0 ? this[index ~/ 2] : element);
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ValueNotifier(
            ShaderSample.SimplexGradient,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ss = context.watch<ValueNotifier<ShaderSample>>().value;
    return Scaffold(
      appBar: AppBar(
        title: Text(ss.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Expanded(child: ShaderSelector()),
              ShaderControls(),
            ],
          ),
        ),
      ),
    );
  }
}

class ShaderSelector extends StatelessWidget {
  const ShaderSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final ss = context.watch<ValueNotifier<ShaderSample>>();

    return Row(
      children: ShaderSample.values
          .map(
            // ignore: unnecessary_cast
            (sample) => TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(),
                foregroundColor: Colors.black,
              ),
              onPressed: sample == ss.value
                  ? null
                  : () {
                      ss.value = sample;
                    },
              child: Text(sample.title),
            ) as Widget,
          )
          .toList()
          .fillBetween(
            const SizedBox(
              width: 8,
            ),
          ),
    );
  }
}

class ShaderControls extends StatelessWidget {
  const ShaderControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        ShaderControl(
          title: 'translate',
        ),
        SizedBox(
          height: 8,
        ),
        ShaderControl(
          title: 'rotate',
        ),
        SizedBox(
          height: 8,
        ),
        ShaderControl(
          title: 'scale',
        ),
        SizedBox(
          height: 8,
        ),
        ShaderControl(
          title: 'time',
        ),
      ],
    );
  }
}

class ShaderControl extends StatelessWidget {
  final String title;
  const ShaderControl({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.black87,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.black87,
          child: SizedBox(
            width: 280,
            height: 32,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                ShaderControlValue(value: '0.001'),
                SizedBox(
                  width: 8,
                ),
                ShaderControlButton(
                  icon: Icons.remove,
                ),
                SizedBox(
                  width: 8,
                ),
                ShaderControlButton(
                  icon: Icons.add,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ShaderControlValue extends StatelessWidget {
  final String value;

  const ShaderControlValue({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ShaderControlButton extends StatelessWidget {
  final IconData icon;
  const ShaderControlButton({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: Size.zero,
        iconColor: Colors.black,
        shape: const RoundedRectangleBorder(),
      ),
      onPressed: () {},
      child: Icon(icon),
    );
  }
}
