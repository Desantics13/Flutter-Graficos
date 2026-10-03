import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

const _axisStyle = TextStyle(fontSize: 11, color: Color(0xFF616161));

/// Títulos de eje basados en índices enteros (0, 1, 2...) → etiquetas de texto.
AxisTitles indexTitles(List<String> labels, {double reserved = 28}) {
  return AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: reserved,
      interval: 1,
      getTitlesWidget: (v, meta) {
        final i = v.round();
        if ((v - i).abs() > 0.001 || i < 0 || i >= labels.length) {
          return const SizedBox.shrink();
        }
        return SideTitleWidget(
          meta: meta,
          child: Text(labels[i], style: _axisStyle),
        );
      },
    ),
  );
}

/// Títulos de eje numéricos con formato opcional.
AxisTitles valueTitles({
  double? interval,
  double reserved = 40,
  String Function(double)? format,
}) {
  return AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: reserved,
      interval: interval,
      getTitlesWidget: (v, meta) => SideTitleWidget(
        meta: meta,
        child: Text(format?.call(v) ?? meta.formattedValue, style: _axisStyle),
      ),
    ),
  );
}

/// [FlTitlesData] con eje inferior (etiquetas o numérico) e izquierdo numérico.
FlTitlesData flTitles({
  List<String>? bottomLabels,
  double? bottomInterval,
  String Function(double)? bottomFormat,
  double? leftInterval,
  String Function(double)? leftFormat,
  double leftReserved = 40,
  bool showLeft = true,
  bool showBottom = true,
}) {
  return FlTitlesData(
    topTitles: const AxisTitles(),
    rightTitles: const AxisTitles(),
    bottomTitles: !showBottom
        ? const AxisTitles()
        : bottomLabels != null
            ? indexTitles(bottomLabels)
            : valueTitles(
                interval: bottomInterval,
                reserved: 28,
                format: bottomFormat,
              ),
    leftTitles: !showLeft
        ? const AxisTitles()
        : valueTitles(
            interval: leftInterval,
            reserved: leftReserved,
            format: leftFormat,
          ),
  );
}

FlGridData softGrid({bool vertical = false}) => FlGridData(
      drawVerticalLine: vertical,
      getDrawingHorizontalLine: (_) =>
          const FlLine(color: Color(0x1F000000), strokeWidth: 1),
      getDrawingVerticalLine: (_) =>
          const FlLine(color: Color(0x14000000), strokeWidth: 1),
    );

FlBorderData noBorder() => FlBorderData(show: false);

FlBorderData bottomLeftBorder() => FlBorderData(
      show: true,
      border: const Border(
        bottom: BorderSide(color: Color(0x33000000)),
        left: BorderSide(color: Color(0x33000000)),
      ),
    );

LinearGradient fadeGradient(Color c, {double top = 0.45}) => LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [c.withValues(alpha: top), c.withValues(alpha: 0.0)],
    );

const tooltipTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontSize: 12,
);
