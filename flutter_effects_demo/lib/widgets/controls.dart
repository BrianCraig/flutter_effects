import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_effects/flutter_effects.dart';
import 'package:flutter_effects_demo/helpers.dart';
import 'package:flutter_effects_demo/providers.dart';
import 'package:flutter_effects_demo/widgets/time_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColorPicker extends ConsumerWidget {
  final String name;
  const ColorPicker({required this.name, super.key});

  @override
  Widget build(context, ref) {
    return CircleColorPicker(
      controller: CircleColorPickerController(
        initialColor: ref.read(
          colorProvider(name),
        ),
      ),
      onChanged: (color) =>
          ref.read(colorProvider(name).notifier).state = color,
      size: const Size(240, 240),
      strokeWidth: 4,
      thumbSize: 36,
    );
  }
}

alertDialogBuilder(String name) => (BuildContext context) => AlertDialog(
      title: Text('Pick color for $name'),
      content: ColorPicker(name: name),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );

class DialogExample extends StatelessWidget {
  const DialogExample({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Pick color for'),
          content: const Text('AlertDialog description'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Text('Show Dialog'),
    );
  }
}

class ColorControl extends ConsumerWidget {
  final String name;
  const ColorControl({required this.name, super.key});

  @override
  Widget build(context, ref) {
    final color = ref.watch(colorProvider(name));
    return ShaderControl(
      title: name,
      controls: [
        Expanded(
            child: Container(
          color: color,
        )),
        ShaderControlButton(
          icon: Icons.color_lens,
          onPressed: () => showDialog<String>(
            context: context,
            builder: alertDialogBuilder(name),
          ),
        )
      ],
    );
  }
}

class T2DTranslateControl extends ConsumerWidget {
  const T2DTranslateControl({super.key});

  @override
  Widget build(context, ref) {
    final t2d = ref.watch(transform2DProvider);
    return ShaderControl(
      title: 'Translate',
      controls: [
        ShaderControlValue(value: t2d.translation.dx.decimals(3).toString()),
        ShaderControlValue(value: t2d.translation.dy.decimals(3).toString()),
      ],
      onReset: () => ref.read(transform2DProvider.notifier).state =
          t2d.clone(translation: Offset.zero),
    );
  }
}

class T2DRotateControl extends ConsumerWidget {
  const T2DRotateControl({super.key});

  @override
  Widget build(context, ref) {
    final t2d = ref.watch(transform2DProvider);
    return ShaderControl(
      title: 'Rotate',
      controls: [
        ShaderControlValue(value: t2d.rotation.decimals(3).toString()),
        ShaderControlButton(
          onPressed: () {
            ref.read(transform2DProvider.notifier).state +=
                const Transform2D(rotation: 1 / 6 * pi);
          },
          icon: Icons.turn_left,
        ),
        ShaderControlButton(
          onPressed: () {
            ref.read(transform2DProvider.notifier).state +=
                const Transform2D(rotation: -1 / 6 * pi);
          },
          icon: Icons.turn_right,
        )
      ],
      onReset: () =>
          ref.read(transform2DProvider.notifier).state = t2d.clone(rotation: 0),
    );
  }
}

class TimeControl extends ConsumerWidget {
  const TimeControl({super.key});

  @override
  Widget build(context, ref) {
    final time = Time.of(context);
    return ShaderControl(
      title: 'Time',
      controls: [
        ShaderControlValue(
            value: time.total.inSecondsDecimal.decimals(2).toString()),
        ShaderControlButton(
          onPressed: () {
            time.toggle();
            (context as Element).markNeedsBuild();
          },
          icon: time.isActive ? Icons.pause : Icons.play_arrow,
        ),
        ShaderControlButton(
          onPressed: () {
            time.tps.multiplier *= 1 / 1.25;
          },
          icon: Icons.remove,
        ),
        ShaderControlButton(
          onPressed: () {
            time.tps.multiplier *= 1.25;
          },
          icon: Icons.add,
        ),
      ],
      onReset: () => time.total = Duration.zero,
    );
  }
}

class T2DScaleControl extends ConsumerWidget {
  const T2DScaleControl({super.key});

  @override
  Widget build(context, ref) {
    final t2d = ref.watch(transform2DProvider);
    return ShaderControl(
      title: 'Scale',
      controls: [
        ShaderControlValue(value: t2d.scale.decimals(3).toString()),
        ShaderControlButton(
          onPressed: () {
            ref.read(transform2DProvider.notifier).state +=
                const Transform2D(scale: 1 / 1.1);
          },
          icon: Icons.remove,
        ),
        ShaderControlButton(
          onPressed: () {
            ref.read(transform2DProvider.notifier).state +=
                const Transform2D(scale: 1.1);
          },
          icon: Icons.add,
        ),
      ],
      onReset: () =>
          ref.read(transform2DProvider.notifier).state = t2d.clone(scale: 1),
    );
  }
}

class ShaderControl extends StatelessWidget {
  final String title;
  final List<Widget> controls;
  final void Function()? onReset;
  const ShaderControl({
    super.key,
    required this.title,
    required this.controls,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(
              width: 8,
            ),
            if (onReset != null)
              GestureDetector(
                onTap: onReset,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.black87,
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.black87,
          child: SizedBox(
            width: 280,
            height: 32,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: controls.fillBetween(
                const SizedBox(
                  width: 8,
                ),
              ),
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

  final void Function() onPressed;
  const ShaderControlButton({
    super.key,
    required this.icon,
    required this.onPressed,
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
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
