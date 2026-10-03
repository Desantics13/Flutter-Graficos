import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import '../../data/sample_data.dart';
import '../../widgets/chart_entry.dart';
import '../../widgets/chart_helpers.dart';
import 'gr_helpers.dart';

/// 10 gráficos básicos con graphic (gramática de gráficos).
List<ChartEntry> grBasicCharts() => [
      ChartEntry(
        title: 'Precio de Bitcoin (30 días)',
        description: 'LineMark con crosshair y tooltip.',
        topic: 'Finanzas / cripto',
        library: ChartLibrary.graphic,
        builder: (_) => const _GrLineBtc(),
      ),
      ChartEntry(
        title: 'Ventas por categoría',
        description: 'IntervalMark vertical con etiquetas.',
        topic: 'Ventas',
        library: ChartLibrary.graphic,
        builder: (_) => const _GrBarSales(),
      ),
      ChartEntry(
        title: 'Horas de escucha por dispositivo',
        description: 'Barras horizontales (RectCoord transposed).',
        topic: 'Música / streaming',
        library: ChartLibrary.graphic,
        builder: (_) => const _GrHorizontalBars(),
      ),
      ChartEntry(
        title: 'Géneros musicales',
        description: 'Pastel: IntervalMark + coordenadas polares.',
        topic: 'Música / streaming',
        library: ChartLibrary.graphic,
        builder: (_) => const _GrPie(donut: false),
      ),
      ChartEntry(
        title: 'Matriz energética',
        description: 'Dona: PolarCoord con radio interior.',
        topic: 'Energía',
        library: ChartLibrary.graphic,
        builder: (_) => const _GrPie(donut: true),
      ),
      ChartEntry(
        title: 'Visitas diarias',
        description: 'AreaMark suavizada con degradado y línea.',
        topic: 'Redes sociales',
        library: ChartLibrary.graphic,
        builder: (_) => const _GrArea(),
      ),
      ChartEntry(
        title: 'Horas de estudio vs nota',
        description: 'Dispersión con PointMark.',
        topic: 'Educación',
        library: ChartLibrary.graphic,
        builder: (_) => const _GrScatter(),
      ),
      ChartEntry(
        title: 'Goles por equipo',
        description: 'Barras agrupadas con DodgeModifier.',
        topic: 'Deportes',
        library: ChartLibrary.graphic,
        builder: (_) => const _GrGrouped(),
      ),
      ChartEntry(
        title: 'Pasajeros por línea y franja',
        description: 'Barras apiladas con StackModifier.',
        topic: 'Transporte',
        library: ChartLibrary.graphic,
        builder: (_) => const _GrStacked(),
      ),
      ChartEntry(
        title: 'Pulso en reposo (12 semanas)',
        description: 'Línea suave (spline) con puntos.',
        topic: 'Salud / fitness',
        library: ChartLibrary.graphic,
        builder: (_) => const _GrSmoothLine(),
      ),
    ];

// 21 ────────────────────────────────────────────────────────────
class _GrLineBtc extends StatelessWidget {
  const _GrLineBtc();

  @override
  Widget build(BuildContext context) {
    final p = SampleData.btcPrice;
    final data = [
      for (var i = 0; i < p.length; i++) {'day': i + 1, 'price': p[i]},
    ];
    return Chart(
      data: data,
      padding: (_) => const EdgeInsets.fromLTRB(52, 16, 16, 28),
      variables: {
        'day': Variable(
          accessor: (Map m) => m['day'] as num,
          scale: LinearScale(min: 1, max: 30, tickCount: 7),
        ),
        'price': Variable(
          accessor: (Map m) => m['price'] as num,
          scale: LinearScale(min: 55000, tickCount: 5, niceRange: false),
        ),
      },
      marks: [
        LineMark(
          size: SizeEncode(value: 2.5),
          color: ColorEncode(value: ChartColors.orange),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      selections: {
        'touch': PointSelection(
          on: {GestureType.hover, GestureType.tap},
          dim: Dim.x,
        ),
      },
      tooltip: TooltipGuide(followPointer: [true, true]),
      crosshair: CrosshairGuide(followPointer: [true, false]),
    );
  }
}

// 22 ────────────────────────────────────────────────────────────
class _GrBarSales extends StatelessWidget {
  const _GrBarSales();

  @override
  Widget build(BuildContext context) {
    return Chart(
      data: categoryRows(SampleData.salesByCategory),
      padding: (_) => const EdgeInsets.fromLTRB(40, 20, 16, 30),
      variables: {
        'label': Variable(
          accessor: (Map m) => m['label'] as String,
          scale: OrdinalScale(tickCount: 6),
        ),
        'value': Variable(
          accessor: (Map m) => m['value'] as num,
          scale: LinearScale(min: 0, max: 360, tickCount: 5),
        ),
      },
      marks: [
        IntervalMark(
          label: LabelEncode(
            encoder: (t) => Label(
              '${t['value']}',
              LabelStyle(
                textStyle: const TextStyle(fontSize: 10),
                offset: const Offset(0, -4),
              ),
            ),
          ),
          color: ColorEncode(
            variable: 'label',
            values: ChartColors.palette,
          ),
          elevation: ElevationEncode(value: 0, updaters: {
            'tap': {true: (_) => 5},
          }),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      selections: {'tap': PointSelection(variable: 'label')},
      tooltip: TooltipGuide(),
    );
  }
}

// 23 ────────────────────────────────────────────────────────────
class _GrHorizontalBars extends StatelessWidget {
  const _GrHorizontalBars();

  @override
  Widget build(BuildContext context) {
    final rows = categoryRows(SampleData.listeningByDevice)..sort(
        (a, b) => (a['value'] as num).compareTo(b['value'] as num),
      );
    return Chart(
      data: rows,
      coord: RectCoord(transposed: true),
      padding: (_) => const EdgeInsets.fromLTRB(110, 8, 30, 28),
      variables: {
        'label': Variable(
          accessor: (Map m) => m['label'] as String,
          scale: OrdinalScale(),
        ),
        'value': Variable(
          accessor: (Map m) => m['value'] as num,
          scale: LinearScale(min: 0, max: 600, tickCount: 4),
        ),
      },
      marks: [
        IntervalMark(
          label: LabelEncode(
            encoder: (t) => Label(
              '${t['value']}',
              LabelStyle(textStyle: const TextStyle(fontSize: 10)),
            ),
          ),
          color: ColorEncode(value: ChartColors.teal),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    );
  }
}

// 24 y 25 ───────────────────────────────────────────────────────
class _GrPie extends StatelessWidget {
  const _GrPie({required this.donut});

  final bool donut;

  @override
  Widget build(BuildContext context) {
    final src = donut ? SampleData.energySources : SampleData.genreShare;
    return ChartWithLegend(
      legend: {
        for (var i = 0; i < src.length; i++) src[i].label: ChartColors.at(i),
      },
      chart: Chart(
        data: categoryRows(src),
        variables: {
          'label': Variable(accessor: (Map m) => m['label'] as String),
          'value': Variable(accessor: (Map m) => m['value'] as num),
        },
        transforms: [Proportion(variable: 'value', as: 'percent')],
        marks: [
          IntervalMark(
            position: Varset('percent') / Varset('label'),
            modifiers: [StackModifier()],
            color: ColorEncode(
              variable: 'label',
              values: ChartColors.palette,
            ),
            label: LabelEncode(
              encoder: (t) => Label(
                '${((t['percent'] as num) * 100).round()}%',
                LabelStyle(
                  textStyle: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            elevation: ElevationEncode(value: 3),
          ),
        ],
        coord: PolarCoord(
          transposed: true,
          dimCount: 1,
          startRadius: donut ? 0.5 : 0,
        ),
      ),
    );
  }
}

// 26 ────────────────────────────────────────────────────────────
class _GrArea extends StatelessWidget {
  const _GrArea();

  @override
  Widget build(BuildContext context) {
    final v = SampleData.dailyVisits;
    final data = [
      for (var i = 0; i < v.length; i++) {'day': i + 1, 'visits': v[i]},
    ];
    final vars = {
      'day': Variable(
        accessor: (Map m) => m['day'] as num,
        scale: LinearScale(min: 1, max: 14, tickCount: 7),
      ),
      'visits': Variable(
        accessor: (Map m) => m['visits'] as num,
        scale: LinearScale(min: 0, max: 800, tickCount: 5),
      ),
    };
    return Chart(
      data: data,
      variables: vars,
      padding: (_) => const EdgeInsets.fromLTRB(44, 16, 16, 28),
      marks: [
        AreaMark(
          shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
          gradient: GradientEncode(
            value: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ChartColors.pink.withAlpha(150),
                ChartColors.pink.withAlpha(10),
              ],
            ),
          ),
        ),
        LineMark(
          shape: ShapeEncode(value: BasicLineShape(smooth: true)),
          size: SizeEncode(value: 2.5),
          color: ColorEncode(value: ChartColors.pink),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    );
  }
}

// 27 ────────────────────────────────────────────────────────────
class _GrScatter extends StatelessWidget {
  const _GrScatter();

  @override
  Widget build(BuildContext context) {
    final data = [
      for (final p in SampleData.studyHoursScore)
        {'hours': p.x, 'score': p.y},
    ];
    return Chart(
      data: data,
      padding: (_) => const EdgeInsets.fromLTRB(40, 16, 16, 30),
      variables: {
        'hours': Variable(
          accessor: (Map m) => m['hours'] as num,
          scale: LinearScale(min: 0, max: 16, tickCount: 5),
        ),
        'score': Variable(
          accessor: (Map m) => m['score'] as num,
          scale: LinearScale(min: 1, max: 5, tickCount: 5),
        ),
      },
      marks: [
        PointMark(
          size: SizeEncode(value: 9),
          color: ColorEncode(value: ChartColors.indigo.withAlpha(170)),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    );
  }
}

// 28 ────────────────────────────────────────────────────────────
class _GrGrouped extends StatelessWidget {
  const _GrGrouped();

  @override
  Widget build(BuildContext context) {
    final data = [
      for (final t in SampleData.teamGoals) ...[
        {'team': t.$1, 'goals': t.$2, 'side': 'Local'},
        {'team': t.$1, 'goals': t.$3, 'side': 'Visitante'},
      ],
    ];
    return ChartWithLegend(
      legend: const {'Local': ChartColors.blue, 'Visitante': ChartColors.orange},
      chart: Chart(
        data: data,
        padding: (_) => const EdgeInsets.fromLTRB(36, 12, 12, 30),
        variables: {
          'team': Variable(
            accessor: (Map m) => m['team'] as String,
            scale: OrdinalScale(),
          ),
          'goals': Variable(
            accessor: (Map m) => m['goals'] as num,
            scale: LinearScale(min: 0, max: 24, tickCount: 5),
          ),
          'side': Variable(accessor: (Map m) => m['side'] as String),
        },
        marks: [
          IntervalMark(
            position: Varset('team') * Varset('goals') / Varset('side'),
            color: ColorEncode(
              variable: 'side',
              values: const [ChartColors.blue, ChartColors.orange],
            ),
            modifiers: [DodgeModifier()],
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    );
  }
}

// 29 ────────────────────────────────────────────────────────────
class _GrStacked extends StatelessWidget {
  const _GrStacked();

  @override
  Widget build(BuildContext context) {
    const lines = ['Línea 1', 'Línea 2', 'Línea 3'];
    const cols = [ChartColors.indigo, ChartColors.teal, ChartColors.amber];
    final data = [
      for (final (slot, vals) in SampleData.passengersByHour)
        for (var i = 0; i < 3; i++)
          {'slot': slot, 'pax': vals[i], 'line': lines[i]},
    ];
    return ChartWithLegend(
      legend: {for (var i = 0; i < 3; i++) lines[i]: cols[i]},
      chart: Chart(
        data: data,
        padding: (_) => const EdgeInsets.fromLTRB(36, 12, 12, 30),
        variables: {
          'slot': Variable(
            accessor: (Map m) => m['slot'] as String,
            scale: OrdinalScale(),
          ),
          'pax': Variable(
            accessor: (Map m) => m['pax'] as num,
            scale: LinearScale(min: 0, max: 110, tickCount: 5),
          ),
          'line': Variable(accessor: (Map m) => m['line'] as String),
        },
        marks: [
          IntervalMark(
            position: Varset('slot') * Varset('pax') / Varset('line'),
            color: ColorEncode(variable: 'line', values: cols),
            modifiers: [StackModifier()],
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    );
  }
}

// 30 ────────────────────────────────────────────────────────────
class _GrSmoothLine extends StatelessWidget {
  const _GrSmoothLine();

  @override
  Widget build(BuildContext context) {
    final v = SampleData.restingHr;
    final data = [
      for (var i = 0; i < v.length; i++) {'week': i + 1, 'bpm': v[i]},
    ];
    return Chart(
      data: data,
      padding: (_) => const EdgeInsets.fromLTRB(40, 16, 16, 30),
      variables: {
        'week': Variable(
          accessor: (Map m) => m['week'] as num,
          scale: LinearScale(min: 1, max: 12, tickCount: 6),
        ),
        'bpm': Variable(
          accessor: (Map m) => m['bpm'] as num,
          scale: LinearScale(min: 60, max: 75, tickCount: 4),
        ),
      },
      marks: [
        LineMark(
          shape: ShapeEncode(value: BasicLineShape(smooth: true)),
          size: SizeEncode(value: 3),
          color: ColorEncode(value: ChartColors.red),
        ),
        PointMark(
          size: SizeEncode(value: 7),
          color: ColorEncode(value: ChartColors.red),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    );
  }
}
