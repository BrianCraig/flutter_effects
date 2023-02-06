import 'dart:math';

extension Decimals on double {
  double decimals(int places) {
    num mod = pow(10.0, places);
    return ((this * mod).round().toDouble() / mod);
  }
}

extension ListFiller<T> on List<T> {
  List<T> fillBetween(T element) {
    return List.generate(
        max(length * 2 - 1, 0), (index) => index % 2 == 0 ? this[index ~/ 2] : element);
  }
}