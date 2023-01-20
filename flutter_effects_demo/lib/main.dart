import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'SimplexGradient'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.bottomRight,
          child: ShaderControls(),
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
          height: 16,
        ),
        ShaderControl(
          title: 'rotate',
        ),
        SizedBox(
          height: 16,
        ),
        ShaderControl(
          title: 'scale',
        ),
        SizedBox(
          height: 16,
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
                ShaderControlValue( value: '0.001'),
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
      ),
      onPressed: () {},
      child: Icon(icon),
    );
  }
}
