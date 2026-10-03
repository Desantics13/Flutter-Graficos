import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../data/sample_data.dart';
import '../../widgets/chart_entry.dart';
import '../../widgets/chart_helpers.dart';
import 'cm_helpers.dart';

/// 10 gráficos básicos con community_charts_flutter.
List<ChartEntry> cmBasicCharts() => [
      ChartEntry(
        title: 'Temperatura de dos ciudades',
        description: 'LineChart con dos series, leyenda y resaltado de puntos.',
        topic: 'Clima',
        library: ChartLibrary.community,
        builder: (_) => const _CmLineCities(),
      ),
      ChartEntry(
        title: 'Estudiantes por carrera',
        description: 'BarChart vertical con etiquetas sobre las barras.',
        topic: 'Educación',
        library: ChartLibrary.community,
        builder: (_) => const _CmBarMajors(),
      ),
      ChartEntry(
        title: 'Ranking de anotadores',
        description: 'BarChart horizontal (vertical: false).',
        topic: 'Deportes',
        library: ChartLibrary.community,
        builder: (_) => const _CmHorizontalBars(),
      ),
      ChartEntry(
        title: 'Géneros de videojuegos',
        description: 'PieChart con etiquetas de arco y leyenda de datos.',
        topic: 'Videojuegos',
        library: ChartLibrary.community,
        builder: (_) => const _CmPie(donut: false),
      ),
      ChartEntry(
        title: 'Presupuesto familiar',
        description: 'Dona con ArcRendererConfig(arcWidth).',
        topic: 'Finanzas personales',
        library: ChartLibrary.community,
        builder: (_) => const _CmPie(donut: true),
      ),
      ChartEntry(
        title: 'Crecimiento poblacional',
        description: 'Área bajo la línea con LineRendererConfig(includeArea).',
        topic: 'Población',
        library: ChartLibrary.community,
        builder: (_) => const _CmArea(),
      ),
      ChartEntry(
        title: 'Edad vs pulso máximo',
        description: 'ScatterPlotChart.',
        topic: 'Salud',
        library: ChartLibrary.community,
        builder: (_) => const _CmScatter(),
      ),
      ChartEntry(
        title: 'Ventas trimestrales',
        description: 'Barras agrupadas con leyenda.',
        topic: 'Ventas',
        library: ChartLibrary.community,
        builder: (_) => const _CmGrouped(),
      ),
      ChartEntry(
        title: 'Mezcla energética por año',
        description: 'Barras apiladas renovable vs fósil.',
        topic: 'Energía',
        library: ChartLibrary.community,
        builder: (_) => const _CmStacked(),
      ),
      ChartEntry(
        title: 'Seguidores diarios',
        description: 'TimeSeriesChart con eje de fechas.',
        topic: 'Redes sociales',
        library: ChartLibrary.community,
        builder: (_) => const _CmTimeSeries(),
      ),
    ];

// 31 ────────────────────────────────────────────────────────────
class _CmLineCities extends StatelessWidget {
  const _CmLineCities();

  @override
  Widget build(BuildContext context) {
    charts.Series<Point2, num> serie(String id, List<double> v, Color c) =>
        charts.Series<Point2, num>(
          id: id,
          colorFn: (_, _) => cmColor(c),
          domainFn: (p, _) => p.x,
          measureFn: (p, _) => p.y,
          data: [for (var i = 0; i < v.length; i++) Point2(i + 1.0, v[i])],
        );

    return charts.LineChart(
      [
        serie('Ciudad andina', SampleData.monthlyTempCity1, ChartColors.blue),
        serie('Ciudad costera', SampleData.monthlyTempCity2, ChartColors.orange),
      ],
      animate: true,
      defaultRenderer: charts.LineRendererConfig(includePoints: true),
      domainAxis: monthAxis(),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          zeroBound: false,
          desiredTickCount: 5,
        ),
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 11),
        ),
      ),
      behaviors: [
        charts.SeriesLegend(position: charts.BehaviorPosition.bottom),
        charts.LinePointHighlighter(
          showHorizontalFollowLine:
              charts.LinePointHighlighterFollowLineType.nearest,
        ),
      ],
    );
  }
}

// 32 ────────────────────────────────────────────────────────────
class _CmBarMajors extends StatelessWidget {
  const _CmBarMajors();

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      [
        charts.Series<Category, String>(
          id: 'Estudiantes',
          colorFn: (_, i) => cmColor(ChartColors.at(i ?? 0)),
          domainFn: (c, _) => c.label,
          measureFn: (c, _) => c.value,
          labelAccessorFn: (c, _) => c.value.toInt().toString(),
          data: SampleData.studentsByMajor,
        ),
      ],
      animate: true,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 11),
        ),
      ),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 11),
        ),
      ),
    );
  }
}

// 33 ────────────────────────────────────────────────────────────
class _CmHorizontalBars extends StatelessWidget {
  const _CmHorizontalBars();

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      [
        charts.Series<Category, String>(
          id: 'Puntos',
          colorFn: (_, _) => cmColor(ChartColors.pink),
          domainFn: (c, _) => c.label,
          measureFn: (c, _) => c.value,
          labelAccessorFn: (c, _) => c.value.toString(),
          data: SampleData.basketPoints,
        ),
      ],
      vertical: false,
      animate: true,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 11),
        ),
      ),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 11),
        ),
      ),
    );
  }
}

// 34 y 35 ───────────────────────────────────────────────────────
class _CmPie extends StatelessWidget {
  const _CmPie({required this.donut});

  final bool donut;

  @override
  Widget build(BuildContext context) {
    final data = donut ? SampleData.familyBudget : SampleData.gameGenres;
    return charts.PieChart<String>(
      [
        charts.Series<Category, String>(
          id: donut ? 'Presupuesto' : 'Géneros',
          colorFn: (_, i) => cmColor(ChartColors.at(i ?? 0)),
          domainFn: (c, _) => c.label,
          measureFn: (c, _) => c.value,
          labelAccessorFn: (c, _) => '${c.value.toInt()}%',
          data: data,
        ),
      ],
      animate: true,
      defaultRenderer: charts.ArcRendererConfig<String>(
        arcWidth: donut ? 55 : null,
        arcRendererDecorators: [
          charts.ArcLabelDecorator<String>(
            labelPosition: charts.ArcLabelPosition.auto,
            outsideLabelStyleSpec: const charts.TextStyleSpec(fontSize: 11),
          ),
        ],
      ),
      behaviors: [
        charts.DatumLegend<String>(
          position: charts.BehaviorPosition.bottom,
          outsideJustification: charts.OutsideJustification.middleDrawArea,
          desiredMaxColumns: 3,
          entryTextStyle: const charts.TextStyleSpec(fontSize: 11),
        ),
      ],
    );
  }
}

// 36 ────────────────────────────────────────────────────────────
class _CmArea extends StatelessWidget {
  const _CmArea();

  @override
  Widget build(BuildContext context) {
    return charts.LineChart(
      [
        charts.Series<Point2, num>(
          id: 'Población',
          colorFn: (_, _) => cmColor(ChartColors.teal),
          domainFn: (p, _) => p.x,
          measureFn: (p, _) => p.y,
          data: SampleData.cityPopulation,
        ),
      ],
      animate: true,
      defaultRenderer: charts.LineRendererConfig(
        includeArea: true,
        includePoints: true,
        areaOpacity: 0.3,
        strokeWidthPx: 3,
      ),
      domainAxis: charts.NumericAxisSpec(
        tickProviderSpec: const charts.BasicNumericTickProviderSpec(
          zeroBound: false,
          desiredTickCount: 7,
        ),
        tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
          (v) => v?.toInt().toString() ?? '',
        ),
        renderSpec: const charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 11),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
          (v) => '${v?.toStringAsFixed(1)} M',
        ),
        renderSpec: const charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 11),
        ),
      ),
    );
  }
}

// 37 ────────────────────────────────────────────────────────────
class _CmScatter extends StatelessWidget {
  const _CmScatter();

  @override
  Widget build(BuildContext context) {
    return charts.ScatterPlotChart(
      [
        charts.Series<Point2, num>(
          id: 'Pulso máximo',
          colorFn: (_, _) => cmColor(ChartColors.red),
          domainFn: (p, _) => p.x,
          measureFn: (p, _) => p.y,
          radiusPxFn: (_, _) => 6,
          data: SampleData.ageMaxHr,
        ),
      ],
      animate: true,
      domainAxis: const charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          zeroBound: false,
          desiredTickCount: 6,
        ),
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 11),
        ),
      ),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          zeroBound: false,
          desiredTickCount: 5,
        ),
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 11),
        ),
      ),
    );
  }
}

// 38 ────────────────────────────────────────────────────────────
class _CmGrouped extends StatelessWidget {
  const _CmGrouped();

  @override
  Widget build(BuildContext context) {
    charts.Series<Category, String> serie(String id, List<double> v, Color c) =>
        charts.Series<Category, String>(
          id: id,
          colorFn: (_, _) => cmColor(c),
          domainFn: (d, _) => d.label,
          measureFn: (d, _) => d.value,
          data: [
            for (var i = 0; i < v.length; i++) Category(SampleData.quarters[i], v[i]),
          ],
        );

    return charts.BarChart(
      [
        serie('2025', SampleData.salesTwoYearsA, ChartColors.slate),
        serie('2026', SampleData.salesTwoYearsB, ChartColors.indigo),
      ],
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
      behaviors: [charts.SeriesLegend(position: charts.BehaviorPosition.bottom)],
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 11),
        ),
      ),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 11),
        ),
      ),
    );
  }
}

// 39 ────────────────────────────────────────────────────────────
class _CmStacked extends StatelessWidget {
  const _CmStacked();

  @override
  Widget build(BuildContext context) {
    charts.Series<Category, String> serie(String id, List<double> v, Color c) =>
        charts.Series<Category, String>(
          id: id,
          colorFn: (_, _) => cmColor(c),
          domainFn: (d, _) => d.label,
          measureFn: (d, _) => d.value,
          data: [
            for (var i = 0; i < v.length; i++)
              Category(SampleData.energyMixYears[i], v[i]),
          ],
        );

    return charts.BarChart(
      [
        serie('Renovable', SampleData.energyMixRenewable, ChartColors.green),
        serie('Fósil', SampleData.energyMixFossil, ChartColors.slate),
      ],
      animate: true,
      barGroupingType: charts.BarGroupingType.stacked,
      behaviors: [charts.SeriesLegend(position: charts.BehaviorPosition.bottom)],
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 11),
        ),
      ),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 11),
        ),
      ),
    );
  }
}

// 40 ────────────────────────────────────────────────────────────
class _CmTimeSeries extends StatelessWidget {
  const _CmTimeSeries();

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      [
        charts.Series<TimeValue, DateTime>(
          id: 'Seguidores',
          colorFn: (_, _) => cmColor(ChartColors.purple),
          domainFn: (d, _) => d.time,
          measureFn: (d, _) => d.value,
          data: SampleData.dailyFollowers,
        ),
      ],
      animate: true,
      defaultRenderer: charts.LineRendererConfig(
        includeArea: true,
        areaOpacity: 0.15,
        strokeWidthPx: 3,
      ),
      domainAxis: const charts.DateTimeAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 11),
        ),
      ),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          zeroBound: false,
          desiredTickCount: 5,
        ),
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 11),
        ),
      ),
      behaviors: [
        charts.LinePointHighlighter(
          showHorizontalFollowLine:
              charts.LinePointHighlighterFollowLineType.nearest,
          showVerticalFollowLine:
              charts.LinePointHighlighterFollowLineType.nearest,
        ),
        charts.SelectNearest(eventTrigger: charts.SelectionTrigger.tapAndDrag),
      ],
    );
  }
}
