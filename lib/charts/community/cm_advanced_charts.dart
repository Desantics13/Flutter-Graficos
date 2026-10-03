import 'dart:async';
import 'dart:math';

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../data/sample_data.dart';
import '../../widgets/chart_entry.dart';
import '../../widgets/chart_helpers.dart';
import 'cm_helpers.dart';

const _tick = charts.TextStyleSpec(fontSize: 11);
const charts.GridlineRendererSpec<num> _grid =
    charts.GridlineRendererSpec<num>(labelStyle: _tick);

/// 6 gráficos avanzados con community_charts_flutter.
List<ChartEntry> cmAdvancedCharts() => [
      ChartEntry(
        title: 'Helados vs temperatura',
        description: 'Combo barras + línea con eje secundario (ejes dobles).',
        topic: 'Ventas / clima',
        library: ChartLibrary.community,
        builder: (_) => const _CmCombo(),
      ),
      ChartEntry(
        title: 'Batería de un auto eléctrico',
        description: 'Gauge (arco parcial) animado; mueve el slider.',
        topic: 'Transporte',
        library: ChartLibrary.community,
        builder: (_) => const _CmGauge(),
      ),
      ChartEntry(
        title: 'Seguidores vs engagement',
        description: 'ScatterPlot con radio variable y etiquetas.',
        topic: 'Redes sociales',
        library: ChartLibrary.community,
        builder: (_) => const _CmBubble(),
      ),
      ChartEntry(
        title: 'Tráfico de red en vivo',
        description: 'Serie en tiempo real con Timer; pausa y reanuda.',
        topic: 'Redes / telecom',
        library: ChartLibrary.community,
        builder: (_) => const _CmRealtime(),
      ),
      ChartEntry(
        title: 'Calidad del aire (AQI)',
        description: 'RangeAnnotation por niveles + selección al arrastrar.',
        topic: 'Salud / ambiente',
        library: ChartLibrary.community,
        builder: (_) => const _CmAirQuality(),
      ),
      ChartEntry(
        title: 'Ventas por región',
        description: 'Barras apiladas; los chips filtran las regiones.',
        topic: 'Ventas',
        library: ChartLibrary.community,
        builder: (_) => const _CmRegionChips(),
      ),
    ];

// 60 ────────────────────────────────────────────────────────────
class _CmCombo extends StatelessWidget {
  const _CmCombo();

  @override
  Widget build(BuildContext context) {
    final bars = charts.Series<Category, String>(
      id: 'Ventas (miles \$)',
      colorFn: (_, _) => cmColor(ChartColors.blue),
      domainFn: (c, _) => c.label,
      measureFn: (c, _) => c.value,
      data: [
        for (var i = 0; i < 12; i++)
          Category(SampleData.months[i], SampleData.iceCreamSales[i]),
      ],
    );
    final line = charts.Series<Category, String>(
      id: 'Temperatura (°C)',
      colorFn: (_, _) => cmColor(ChartColors.red),
      domainFn: (c, _) => c.label,
      measureFn: (c, _) => c.value,
      data: [
        for (var i = 0; i < 12; i++)
          Category(SampleData.months[i], SampleData.iceCreamTemp[i]),
      ],
    )
      ..setAttribute(charts.rendererIdKey, 'customLine')
      ..setAttribute(charts.measureAxisIdKey, 'secondaryMeasureAxisId');

    return charts.OrdinalComboChart(
      [bars, line],
      animate: true,
      defaultRenderer: charts.BarRendererConfig(
        groupingType: charts.BarGroupingType.grouped,
      ),
      customSeriesRenderers: [
        charts.LineRendererConfig(
          customRendererId: 'customLine',
          includePoints: true,
          strokeWidthPx: 3,
        ),
      ],
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(fontSize: 10),
        ),
      ),
      primaryMeasureAxis: const charts.NumericAxisSpec(renderSpec: _grid),
      secondaryMeasureAxis: const charts.NumericAxisSpec(
        renderSpec: _grid,
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredTickCount: 5,
        ),
      ),
      behaviors: [charts.SeriesLegend(position: charts.BehaviorPosition.bottom)],
    );
  }
}

// 61 ────────────────────────────────────────────────────────────
class _CmGauge extends StatefulWidget {
  const _CmGauge();

  @override
  State<_CmGauge> createState() => _CmGaugeState();
}

class _CmGaugeState extends State<_CmGauge> {
  double _level = 72;

  Color get _color {
    if (_level >= 50) return ChartColors.green;
    if (_level >= 20) return ChartColors.amber;
    return ChartColors.red;
  }

  @override
  Widget build(BuildContext context) {
    final data = [
      Category('Carga', _level),
      Category('Vacío', 100 - _level),
    ];
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              charts.PieChart<String>(
                [
                  charts.Series<Category, String>(
                    id: 'Batería',
                    colorFn: (c, _) => c.label == 'Carga'
                        ? cmColor(_color)
                        : cmColor(const Color(0xFFE0E0E0)),
                    domainFn: (c, _) => c.label,
                    measureFn: (c, _) => c.value,
                    data: data,
                  ),
                ],
                animate: true,
                defaultRenderer: charts.ArcRendererConfig<String>(
                  arcWidth: 30,
                  startAngle: 4 / 5 * pi,
                  arcLength: 7 / 5 * pi,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_level.round()}%',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: _color,
                    ),
                  ),
                  Text(
                    '≈ ${(_level * 4.2).round()} km de autonomía',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        Slider(
          value: _level,
          min: 0,
          max: 100,
          divisions: 100,
          label: '${_level.round()}%',
          onChanged: (v) => setState(() => _level = v),
        ),
      ],
    );
  }
}

// 62 ────────────────────────────────────────────────────────────
class _CmBubble extends StatelessWidget {
  const _CmBubble();

  @override
  Widget build(BuildContext context) {
    return charts.ScatterPlotChart(
      [
        charts.Series<Bubble, num>(
          id: 'Formatos',
          colorFn: (_, i) => cmColor(ChartColors.at(i ?? 0).withValues(alpha: 0.75)),
          domainFn: (b, _) => b.x,
          measureFn: (b, _) => b.y,
          radiusPxFn: (b, _) => 6 + b.size * 0.32,
          labelAccessorFn: (b, _) => b.label,
          data: SampleData.socialBubbles,
        ),
      ],
      animate: true,
      defaultRenderer: charts.PointRendererConfig<num>(
        pointRendererDecorators: [
          charts.PointLabelDecorator<num>(
            labelStyleSpec: const charts.TextStyleSpec(fontSize: 10),
            horizontalPadding: -14,
            verticalPadding: 6,
            labelCallback: (d) =>
                charts.PointLabelSpec(label: (d as Bubble).label),
          ),
        ],
      ),
      domainAxis: const charts.NumericAxisSpec(
        viewport: charts.NumericExtents(0, 140),
        renderSpec: _grid,
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        viewport: const charts.NumericExtents(0, 11),
        tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
          (v) => '${v?.toStringAsFixed(0)}%',
        ),
        renderSpec: _grid,
      ),
    );
  }
}

// 63 ────────────────────────────────────────────────────────────
class _CmRealtime extends StatefulWidget {
  const _CmRealtime();

  @override
  State<_CmRealtime> createState() => _CmRealtimeState();
}

class _CmRealtimeState extends State<_CmRealtime> {
  static const _window = 30;
  final _points = <Point2>[];
  final _rnd = Random(4);
  Timer? _timer;
  double _t = 0;
  bool _running = true;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < _window; i++) {
      _push();
    }
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (_running) setState(_push);
    });
  }

  void _push() {
    _t += 1;
    final mbps = 55 + 25 * sin(_t / 5) + (_rnd.nextDouble() - 0.5) * 18;
    _points.add(Point2(_t, mbps.clamp(5, 95).toDouble()));
    if (_points.length > _window) _points.removeAt(0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.wifi, size: 20, color: ChartColors.indigo),
            const SizedBox(width: 6),
            Text(
              '${_points.last.y.toStringAsFixed(1)} Mbps',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const Spacer(),
            IconButton.filledTonal(
              tooltip: _running ? 'Pausar' : 'Reanudar',
              onPressed: () => setState(() => _running = !_running),
              icon: Icon(_running ? Icons.pause : Icons.play_arrow),
            ),
          ],
        ),
        Expanded(
          child: charts.LineChart(
            [
              charts.Series<Point2, num>(
                id: 'Tráfico',
                colorFn: (_, _) => cmColor(ChartColors.indigo),
                domainFn: (p, _) => p.x,
                measureFn: (p, _) => p.y,
                data: List.of(_points),
              ),
            ],
            animate: false,
            defaultRenderer: charts.LineRendererConfig(
              includeArea: true,
              areaOpacity: 0.2,
              strokeWidthPx: 2.5,
            ),
            domainAxis: charts.NumericAxisSpec(
              viewport: charts.NumericExtents(_points.first.x, _points.last.x),
              renderSpec: const charts.NoneRenderSpec(),
            ),
            primaryMeasureAxis: const charts.NumericAxisSpec(
              viewport: charts.NumericExtents(0, 100),
              renderSpec: _grid,
            ),
          ),
        ),
      ],
    );
  }
}

// 64 ────────────────────────────────────────────────────────────
class _CmAirQuality extends StatefulWidget {
  const _CmAirQuality();

  @override
  State<_CmAirQuality> createState() => _CmAirQualityState();
}

class _CmAirQualityState extends State<_CmAirQuality> {
  Point2? _selected;

  static String _level(double aqi) =>
      aqi <= 50 ? 'Buena' : (aqi <= 100 ? 'Moderada' : 'Dañina');

  charts.RangeAnnotationSegment<num> _band(
    num from,
    num to,
    Color c,
    String label,
  ) =>
      charts.RangeAnnotationSegment<num>(
        from,
        to,
        charts.RangeAnnotationAxisType.measure,
        color: cmColor(c.withValues(alpha: 0.16)),
        middleLabel: label,
        labelStyleSpec: const charts.TextStyleSpec(fontSize: 10),
        labelAnchor: charts.AnnotationLabelAnchor.end,
        labelDirection: charts.AnnotationLabelDirection.horizontal,
      );

  @override
  Widget build(BuildContext context) {
    final sel = _selected;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            sel == null
                ? 'Toca o arrastra sobre la curva'
                : '${sel.x.toInt()}:00 h · AQI ${sel.y.toInt()} (${_level(sel.y)})',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
        Expanded(
          child: charts.LineChart(
            [
              charts.Series<Point2, num>(
                id: 'AQI',
                colorFn: (_, _) => cmColor(ChartColors.slate),
                domainFn: (p, _) => p.x,
                measureFn: (p, _) => p.y,
                data: [
                  for (var i = 0; i < SampleData.airQuality.length; i++)
                    Point2(i.toDouble(), SampleData.airQuality[i]),
                ],
              ),
            ],
            animate: true,
            defaultRenderer: charts.LineRendererConfig(
              strokeWidthPx: 3,
              includePoints: true,
            ),
            domainAxis: const charts.NumericAxisSpec(
              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                zeroBound: false,
                desiredTickCount: 7,
              ),
              renderSpec: charts.SmallTickRendererSpec(labelStyle: _tick),
            ),
            primaryMeasureAxis: const charts.NumericAxisSpec(
              viewport: charts.NumericExtents(0, 150),
              renderSpec: _grid,
            ),
            selectionModels: [
              charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: (model) {
                  final d = model.selectedDatum;
                  final p = d.isEmpty ? null : d.first.datum as Point2;
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) {
                    if (mounted) setState(() => _selected = p);
                  });
                },
              ),
            ],
            behaviors: [
              charts.RangeAnnotation([
                _band(0, 50, ChartColors.green, 'Buena'),
                _band(50, 100, ChartColors.amber, 'Moderada'),
                _band(100, 150, ChartColors.red, 'Dañina'),
              ]),
              charts.LinePointHighlighter(
                showHorizontalFollowLine:
                    charts.LinePointHighlighterFollowLineType.nearest,
                showVerticalFollowLine:
                    charts.LinePointHighlighterFollowLineType.nearest,
              ),
              charts.SelectNearest(
                eventTrigger: charts.SelectionTrigger.tapAndDrag,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 65 ────────────────────────────────────────────────────────────
class _CmRegionChips extends StatefulWidget {
  const _CmRegionChips();

  @override
  State<_CmRegionChips> createState() => _CmRegionChipsState();
}

class _CmRegionChipsState extends State<_CmRegionChips> {
  final Set<int> _on = {0, 1, 2, 3};

  @override
  Widget build(BuildContext context) {
    final series = <charts.Series<Category, String>>[
      for (final r in _on.toList()..sort())
        charts.Series<Category, String>(
          id: SampleData.regionNames[r],
          colorFn: (_, _) => cmColor(ChartColors.at(r)),
          domainFn: (c, _) => c.label,
          measureFn: (c, _) => c.value,
          data: [
            for (var q = 0; q < 4; q++)
              Category(SampleData.quarters[q], SampleData.regionSales[q][r]),
          ],
        ),
    ];
    return Column(
      children: [
        Wrap(
          spacing: 8,
          children: [
            for (var r = 0; r < SampleData.regionNames.length; r++)
              FilterChip(
                label: Text(SampleData.regionNames[r]),
                selected: _on.contains(r),
                selectedColor: ChartColors.at(r).withValues(alpha: 0.28),
                onSelected: (v) => setState(() {
                  if (v) {
                    _on.add(r);
                  } else if (_on.length > 1) {
                    _on.remove(r);
                  }
                }),
              ),
          ],
        ),
        Expanded(
          child: charts.BarChart(
            series,
            animate: true,
            barGroupingType: charts.BarGroupingType.stacked,
            domainAxis: const charts.OrdinalAxisSpec(
              renderSpec: charts.SmallTickRendererSpec(labelStyle: _tick),
            ),
            primaryMeasureAxis: const charts.NumericAxisSpec(
              viewport: charts.NumericExtents(0, 250),
              renderSpec: _grid,
            ),
            behaviors: [
              charts.SeriesLegend(position: charts.BehaviorPosition.bottom),
            ],
          ),
        ),
      ],
    );
  }
}
