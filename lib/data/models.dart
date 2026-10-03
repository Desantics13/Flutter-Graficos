/// Modelos mínimos que comparten todos los gráficos.
class Category {
  const Category(this.label, this.value);

  final String label;
  final double value;
}

class Point2 {
  const Point2(this.x, this.y);

  final double x;
  final double y;
}

class Bubble {
  const Bubble(this.label, this.x, this.y, this.size);

  final String label;
  final double x;
  final double y;
  final double size;
}

class Candle {
  const Candle(this.date, this.open, this.high, this.low, this.close);

  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;

  bool get isUp => close >= open;
}

class RangeValue {
  const RangeValue(this.label, this.low, this.high);

  final String label;
  final double low;
  final double high;
}

class TimeValue {
  const TimeValue(this.time, this.value);

  final DateTime time;
  final double value;
}
