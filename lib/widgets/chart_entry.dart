import 'package:flutter/material.dart';

/// Las 4 librerías de graficación del taller.
enum ChartLibrary {
  flChart('fl_chart', Color(0xFF1565C0)),
  syncfusion('Syncfusion', Color(0xFFD84315)),
  graphic('graphic', Color(0xFF2E7D32)),
  community('community_charts', Color(0xFF7B1FA2));

  const ChartLibrary(this.label, this.color);

  final String label;
  final Color color;
}

/// Un gráfico del dashboard: metadatos + constructor del widget.
class ChartEntry {
  const ChartEntry({
    this.number = 0,
    required this.title,
    required this.description,
    required this.topic,
    required this.library,
    required this.builder,
  });

  final int number;
  final String title;
  final String description;

  /// Tema de los datos de ejemplo (clima, finanzas, deportes...).
  final String topic;
  final ChartLibrary library;
  final WidgetBuilder builder;

  ChartEntry withNumber(int n) => ChartEntry(
        number: n,
        title: title,
        description: description,
        topic: topic,
        library: library,
        builder: builder,
      );
}
