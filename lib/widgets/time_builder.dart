import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

typedef WidgetDurationBuilder<T> = Widget Function(
    BuildContext context, Duration time);

class DurationBuilder extends StatefulWidget {
  final WidgetDurationBuilder builder;
  const DurationBuilder({
    super.key,
    required this.builder,
  });

  @override
  State<DurationBuilder> createState() => _DurationBuilderState();
}

class _DurationBuilderState extends State<DurationBuilder> with TickerProviderStateMixin {
  late final Ticker ticker;
  late DateTime start;
  @override
  void initState() {
    super.initState();
    start = DateTime.now();
    ticker = createTicker((_) {

        setState(() {
        });
    });
    ticker.start();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, DateTime.now().difference(start));
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }
}
