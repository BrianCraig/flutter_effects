import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class TimeProvider extends StatefulWidget {
  final Widget child;
  const TimeProvider({
    super.key,
    required this.child,
  });

  @override
  State<TimeProvider> createState() => TimeProviderState();
}

class TimeProviderState extends State<TimeProvider>
    with SingleTickerProviderStateMixin {
  late final Ticker ticker;
  bool justPaused = false;
  Duration total = Duration.zero, delta = Duration.zero;
  Duration lastTotal = Duration.zero;
  double multiplier = 1;

  @override
  void initState() {
    super.initState();
    ticker = createTicker((frameDelta) {
      setState(() {
        if (justPaused) {
          lastTotal = frameDelta;
          justPaused = false;
        }
        Duration diff = (frameDelta - lastTotal) * multiplier;
        lastTotal = frameDelta;
        total += diff;
        delta = diff;
      });
    });
    ticker.start();
  }

  void toggle() {
    ticker.muted = !ticker.muted;
    justPaused = true;
  }

  @override
  Widget build(BuildContext context) {
    return Time(
      tps: this,
      total: total,
      delta: delta,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }
}

class Time extends InheritedWidget {
  final Duration total, delta;

  final TimeProviderState tps;

  const Time({
    super.key,
    required this.tps,
    required this.total,
    required this.delta,
    required super.child,
  });

  void toggle() => tps.toggle();

  bool get isActive => !tps.ticker.muted;

  static Time? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Time>();
  }

  static Time of(BuildContext context) {
    final Time? result = maybeOf(context);
    assert(result != null, 'No Time found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(Time oldWidget) =>
      (total != oldWidget.total) || (delta != oldWidget.delta);
}
