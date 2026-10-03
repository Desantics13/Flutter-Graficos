import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../data/models.dart';
import '../../data/sample_data.dart';
import '../../widgets/chart_entry.dart';
import '../../widgets/chart_helpers.dart';

const _labelStyle = TextStyle(fontSize: 11);
const _noGrid = MajorGridLines(width: 0);
const _softGrid = MajorGridLines(width: 1, color: Color(0x1F000000));
const _bottomLegend = Legend(
  isVisible: true,
  position: LegendPosition.bottom,
  overflowMode: LegendItemOverflowMode.wrap,
);

/// 10 gráficos básicos con syncfusion_flutter_charts.
List<ChartEntry> sfBasicCharts() => [
      ChartEntry(
        title: 'Cotización de una acción',
        description: 'LineSeries con marcadores y tooltip.',
        topic: 'Finanzas / acciones',
        library: ChartLibrary.syncfusion,
        builder: (_) => const _SfLineStock(),
      ),
      ChartEntry(
        title: 'Nota promedio por materia',
        description: 'ColumnSeries con etiquetas de datos.',
        topic: 'Educación',
        library: ChartLibrary.syncfusion,
        builder: (_) => const _SfColumnGrades(),
      ),
      ChartEntry(
        title: 'Horas jugadas por género',
        description: 'BarSeries (barras horizontales).',
        topic: 'Videojuegos',
        library: ChartLibrary.syncfusion,
        builder: (_) => const _SfBarGames(),
      ),
      ChartEntry(
        title: 'Población por continente',
        description: 'PieSeries con etiquetas externas y explosión.',
        topic: 'Población',
        library: ChartLibrary.syncfusion,
        builder: (_) => const _SfPiePopulation(),
      ),
      ChartEntry(
        title: 'Medios de transporte',
        description: 'DoughnutSeries con anotación central.',
        topic: 'Transporte',
        library: ChartLibrary.syncfusion,
        builder: (_) => const _SfDoughnutTransport(),
      ),
      ChartEntry(
        title: 'Descargas de la app',
        description: 'AreaSeries con degradado.',
        topic: 'Redes sociales / apps',
        library: ChartLibrary.syncfusion,
        builder: (_) => const _SfAreaDownloads(),
      ),
      ChartEntry(
        title: 'Velocidad vs consumo',
        description: 'ScatterSeries de 30 vehículos.',
        topic: 'Transporte',
        library: ChartLibrary.syncfusion,
        builder: (_) => const _SfScatterVehicles(),
      ),
      ChartEntry(
        title: 'Humedad relativa mensual',
        description: 'SplineSeries (curva suavizada).',
        topic: 'Clima',
        library: ChartLibrary.syncfusion,
        builder: (_) => const _SfSplineHumidity(),
      ),
      ChartEntry(
        title: 'Tarifa eléctrica horaria',
        description: 'StepLineSeries (línea escalonada).',
        topic: 'Energía',
        library: ChartLibrary.syncfusion,
        builder: (_) => const _SfStepTariff(),
      ),
      ChartEntry(
        title: 'Medallero por país',
        description: 'StackedColumnSeries con leyenda.',
        topic: 'Deportes',
        library: ChartLibrary.syncfusion,
        builder: (_) => const _SfStackedMedals(),
      ),
    ];

List<Point2> _indexed(List<double> v, {double offset = 1}) =>
    [for (var i = 0; i < v.length; i++) Point2(i + offset, v[i])];

// 11 ────────────────────────────────────────────────────────────
class _SfLineStock extends StatelessWidget {
  const _SfLineStock();

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(4, 12, 12, 4),
      primaryXAxis: const NumericAxis(
        title: AxisTitle(text: 'Día', textStyle: _labelStyle),
        majorGridLines: _noGrid,
        interval: 3,
      ),
      primaryYAxis: const NumericAxis(
        minimum: 98,
        majorGridLines: _softGrid,
        axisLine: AxisLine(width: 0),
        labelFormat: '\${value}',
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<Point2, double>>[
        LineSeries<Point2, double>(
          dataSource: _indexed(SampleData.stockClose20),
          xValueMapper: (p, _) => p.x,
          yValueMapper: (p, _) => p.y,
          color: ChartColors.indigo,
          width: 3,
          markerSettings: const MarkerSettings(isVisible: true, height: 6, width: 6),
        ),
      ],
    );
  }
}

// 12 ────────────────────────────────────────────────────────────
class _SfColumnGrades extends StatelessWidget {
  const _SfColumnGrades();

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(4, 12, 12, 4),
      palette: ChartColors.palette,
      primaryXAxis: const CategoryAxis(
        majorGridLines: _noGrid,
        labelStyle: TextStyle(fontSize: 10),
        labelIntersectAction: AxisLabelIntersectAction.rotate45,
      ),
      primaryYAxis: const NumericAxis(
        minimum: 0,
        maximum: 5,
        interval: 1,
        majorGridLines: _softGrid,
        axisLine: AxisLine(width: 0),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<Category, String>>[
        ColumnSeries<Category, String>(
          dataSource: SampleData.subjectGrades,
          xValueMapper: (c, _) => c.label,
          yValueMapper: (c, _) => c.value,
          pointColorMapper: (c, i) => ChartColors.at(i),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}

// 13 ────────────────────────────────────────────────────────────
class _SfBarGames extends StatelessWidget {
  const _SfBarGames();

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(4, 12, 12, 4),
      primaryXAxis: const CategoryAxis(
        isInversed: true,
        majorGridLines: _noGrid,
        labelStyle: _labelStyle,
      ),
      primaryYAxis: const NumericAxis(
        majorGridLines: _softGrid,
        axisLine: AxisLine(width: 0),
        title: AxisTitle(text: 'Millones de horas', textStyle: _labelStyle),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<Category, String>>[
        BarSeries<Category, String>(
          dataSource: SampleData.topGames,
          xValueMapper: (c, _) => c.label,
          yValueMapper: (c, _) => c.value,
          pointColorMapper: (c, i) => ChartColors.at(i + 2),
          borderRadius: const BorderRadius.horizontal(right: Radius.circular(5)),
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

// 14 ────────────────────────────────────────────────────────────
class _SfPiePopulation extends StatelessWidget {
  const _SfPiePopulation();

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      palette: ChartColors.palette,
      legend: _bottomLegend,
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CircularSeries<Category, String>>[
        PieSeries<Category, String>(
          dataSource: SampleData.populationContinents,
          xValueMapper: (c, _) => c.label,
          yValueMapper: (c, _) => c.value,
          explode: true,
          explodeIndex: 0,
          radius: '70%',
          dataLabelMapper: (c, _) => '${c.value.toInt()} M',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            textStyle: TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }
}

// 15 ────────────────────────────────────────────────────────────
class _SfDoughnutTransport extends StatelessWidget {
  const _SfDoughnutTransport();

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      palette: ChartColors.palette,
      legend: _bottomLegend,
      tooltipBehavior: TooltipBehavior(enable: true),
      annotations: const <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: Text(
            'Viajes\nurbanos',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
      series: <CircularSeries<Category, String>>[
        DoughnutSeries<Category, String>(
          dataSource: SampleData.transportMode,
          xValueMapper: (c, _) => c.label,
          yValueMapper: (c, _) => c.value,
          innerRadius: '58%',
          radius: '85%',
          dataLabelMapper: (c, _) => '${c.value.toInt()}%',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// 16 ────────────────────────────────────────────────────────────
class _SfAreaDownloads extends StatelessWidget {
  const _SfAreaDownloads();

  static const _downloads = [
    12.0, 15.0, 19.0, 26.0, 31.0, 38.0, 47.0, 52.0, 61.0, 70.0, 84.0, 102.0, //
  ];

  @override
  Widget build(BuildContext context) {
    final data = [
      for (var i = 0; i < 12; i++) Category(SampleData.months[i], _downloads[i]),
    ];
    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(4, 12, 12, 4),
      primaryXAxis: const CategoryAxis(majorGridLines: _noGrid),
      primaryYAxis: const NumericAxis(
        majorGridLines: _softGrid,
        axisLine: AxisLine(width: 0),
        labelFormat: '{value}k',
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<Category, String>>[
        AreaSeries<Category, String>(
          dataSource: data,
          xValueMapper: (c, _) => c.label,
          yValueMapper: (c, _) => c.value,
          borderColor: ChartColors.pink,
          borderWidth: 2.5,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ChartColors.pink.withValues(alpha: 0.55),
              ChartColors.pink.withValues(alpha: 0.03),
            ],
          ),
        ),
      ],
    );
  }
}

// 17 ────────────────────────────────────────────────────────────
class _SfScatterVehicles extends StatelessWidget {
  const _SfScatterVehicles();

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(4, 12, 12, 4),
      primaryXAxis: const NumericAxis(
        title: AxisTitle(text: 'Velocidad (km/h)', textStyle: _labelStyle),
        majorGridLines: _softGrid,
        minimum: 20,
        maximum: 140,
        interval: 20,
      ),
      primaryYAxis: const NumericAxis(
        title: AxisTitle(text: 'L/100 km', textStyle: _labelStyle),
        majorGridLines: _softGrid,
        minimum: 0,
        maximum: 12,
        interval: 2,
        axisLine: AxisLine(width: 0),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<Point2, double>>[
        ScatterSeries<Point2, double>(
          dataSource: SampleData.speedConsumption,
          xValueMapper: (p, _) => p.x,
          yValueMapper: (p, _) => p.y,
          color: ChartColors.teal.withValues(alpha: 0.75),
          markerSettings: const MarkerSettings(height: 10, width: 10),
        ),
      ],
    );
  }
}

// 18 ────────────────────────────────────────────────────────────
class _SfSplineHumidity extends StatelessWidget {
  const _SfSplineHumidity();

  @override
  Widget build(BuildContext context) {
    final data = [
      for (var i = 0; i < 12; i++)
        Category(SampleData.months[i], SampleData.humidity12[i]),
    ];
    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(4, 12, 12, 4),
      primaryXAxis: const CategoryAxis(majorGridLines: _noGrid),
      primaryYAxis: const NumericAxis(
        minimum: 30,
        maximum: 100,
        majorGridLines: _softGrid,
        axisLine: AxisLine(width: 0),
        labelFormat: '{value}%',
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<Category, String>>[
        SplineSeries<Category, String>(
          dataSource: data,
          xValueMapper: (c, _) => c.label,
          yValueMapper: (c, _) => c.value,
          color: ChartColors.blue,
          width: 3,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      ],
    );
  }
}

// 19 ────────────────────────────────────────────────────────────
class _SfStepTariff extends StatelessWidget {
  const _SfStepTariff();

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(4, 12, 12, 4),
      primaryXAxis: const NumericAxis(
        minimum: 0,
        maximum: 23,
        interval: 4,
        majorGridLines: _noGrid,
        labelFormat: '{value}h',
      ),
      primaryYAxis: const NumericAxis(
        minimum: 0,
        maximum: 0.35,
        interval: 0.1,
        majorGridLines: _softGrid,
        axisLine: AxisLine(width: 0),
        labelFormat: '\${value}',
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<Point2, double>>[
        StepLineSeries<Point2, double>(
          dataSource: _indexed(SampleData.energyTariff, offset: 0),
          xValueMapper: (p, _) => p.x,
          yValueMapper: (p, _) => p.y,
          color: ChartColors.amber,
          width: 3,
        ),
      ],
    );
  }
}

// 20 ────────────────────────────────────────────────────────────
class _SfStackedMedals extends StatelessWidget {
  const _SfStackedMedals();

  @override
  Widget build(BuildContext context) {
    const m = SampleData.medals;
    StackedColumnSeries<(String, double, double, double), String> serie(
      String name,
      Color color,
      double Function((String, double, double, double)) pick,
    ) =>
        StackedColumnSeries<(String, double, double, double), String>(
          name: name,
          color: color,
          dataSource: m,
          xValueMapper: (d, _) => d.$1,
          yValueMapper: (d, _) => pick(d),
        );

    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(4, 12, 12, 4),
      legend: _bottomLegend,
      primaryXAxis: const CategoryAxis(majorGridLines: _noGrid),
      primaryYAxis: const NumericAxis(
        majorGridLines: _softGrid,
        axisLine: AxisLine(width: 0),
      ),
      tooltipBehavior: TooltipBehavior(enable: true, shared: true),
      series: <CartesianSeries<(String, double, double, double), String>>[
        serie('Oro', const Color(0xFFFFB300), (d) => d.$2),
        serie('Plata', const Color(0xFF90A4AE), (d) => d.$3),
        serie('Bronce', const Color(0xFF8D6E63), (d) => d.$4),
      ],
    );
  }
}
