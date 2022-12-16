import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class TimeAnimationBuilder extends StatefulWidget {
  final ValueWidgetBuilder<double> builder;
  const TimeAnimationBuilder({super.key, required this.builder});

  @override
  State<TimeAnimationBuilder> createState() => _TimeAnimationBuilderState();
}

class _TimeAnimationBuilderState extends State<TimeAnimationBuilder>
    with SingleTickerProviderStateMixin {
  late final Ticker ticker;
  late DateTime start;

  @override
  void initState() {
    super.initState();
    start = DateTime.now();
    ticker = createTicker((_) {
      setState(() {});
    });
    ticker.start();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, DateTime.now().difference(start).inMicroseconds.toDouble() / 1e6, null);
  }
}
