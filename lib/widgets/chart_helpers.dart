import 'package:flutter/material.dart';

/// Paleta compartida por todos los gráficos.
class ChartColors {
  static const blue = Color(0xFF1E88E5);
  static const orange = Color(0xFFFB8C00);
  static const green = Color(0xFF43A047);
  static const red = Color(0xFFE53935);
  static const purple = Color(0xFF8E24AA);
  static const teal = Color(0xFF00897B);
  static const pink = Color(0xFFD81B60);
  static const amber = Color(0xFFFFB300);
  static const indigo = Color(0xFF3949AB);
  static const slate = Color(0xFF546E7A);

  static const palette = <Color>[
    blue,
    orange,
    green,
    purple,
    teal,
    pink,
    amber,
    indigo,
    red,
    slate,
  ];

  static Color at(int i) => palette[i % palette.length];
}

/// Leyenda simple (punto de color + etiqueta) para gráficos sin leyenda propia.
class LegendRow extends StatelessWidget {
  const LegendRow({super.key, required this.items});

  final Map<String, Color> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 4,
      alignment: WrapAlignment.center,
      children: [
        for (final e in items.entries)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: e.value, shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
              Text(e.key, style: const TextStyle(fontSize: 12)),
            ],
          ),
      ],
    );
  }
}

/// Gráfico + leyenda debajo.
class ChartWithLegend extends StatelessWidget {
  const ChartWithLegend({super.key, required this.chart, required this.legend});

  final Widget chart;
  final Map<String, Color> legend;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: chart),
        const SizedBox(height: 6),
        LegendRow(items: legend),
      ],
    );
  }
}

/// Placeholder de padding uniforme para los gráficos.
class ChartPad extends StatelessWidget {
  const ChartPad({super.key, required this.child, this.right = 8});

  final Widget child;
  final double right;

  @override
  Widget build(BuildContext context) =>
      Padding(padding: EdgeInsets.fromLTRB(0, 8, right, 0), child: child);
}
