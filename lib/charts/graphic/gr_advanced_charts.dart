import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import '../../data/sample_data.dart';
import '../../widgets/chart_entry.dart';
import '../../widgets/chart_helpers.dart';
import 'gr_helpers.dart';

/// 6 gráficos avanzados con graphic.
List<ChartEntry> grAdvancedCharts() => [
      ChartEntry(
        title: 'Mapa de calor de tráfico',
        description: 'PolygonMark con color continuo y selección al tocar.',
        topic: 'Transporte',
        library: ChartLibrary.graphic,
        builder: (_) => const _GrHeatmap(),
      ),
      ChartEntry(
        title: 'Rosa de Nightingale',
        description: 'Barras en coordenadas polares: lluvia mensual.',
        topic: 'Clima',
        library: ChartLibrary.graphic,
        builder: (_) => const _GrNightingale(),
      ),
      ChartEntry(
        title: 'Burbujas: PIB vs esperanza de vida',
        description: 'PointMark con tamaño (población) y color por país.',
        topic: 'Población / economía',
        library: ChartLibrary.graphic,
        builder: (_) => const _GrBubbles(),
      ),
      ChartEntry(
        title: 'Rango de temperatura',
        description: 'Range area: mínima–máxima mensual con tooltip.',
        topic: 'Clima',
        library: ChartLibrary.graphic,
        builder: (_) => const _GrRangeArea(),
      ),
      ChartEntry(
        title: 'Notas por curso (100 % apilado)',
        description: 'Barras apiladas normalizadas al 100 %.',
        topic: 'Educación',
        library: ChartLibrary.graphic,
        builder: (_) => const _GrStacked100(),
      ),
      ChartEntry(
        title: 'Anillos de actividad',
        description: 'Barras radiales (polar transpuesto) interactivas.',
        topic: 'Salud / fitness',
        library: ChartLibrary.graphic,
        builder: (_) => const _GrRadialBars(),
      ),
    ];

// 54 ────────────────────────────────────────────────────────────
class _GrHeatmap extends StatelessWidget {
  const _GrHeatmap();

  @override
  Widget build(BuildContext context) {
    final data = [
      for (var d = 0; d < SampleData.heatDays.length; d++)
        for (var s = 0; s < SampleData.heatSlots.length; s++)
          {
            'day': SampleData.heatDays[d],
            'slot': SampleData.heatSlots[s],
            'value': SampleData.trafficHeat[d][s].round(),
          },
    ];
    return Chart(
      data: data,
      padding: (_) => const EdgeInsets.fromLTRB(40, 16, 16, 30),
      variables: {
        'day': Variable(
          accessor: (Map m) => m['day'] as String,
          scale: OrdinalScale(),
        ),
        'slot': Variable(
          accessor: (Map m) => m['slot'] as String,
          scale: OrdinalScale(),
        ),
        'value': Variable(
          accessor: (Map m) => m['value'] as num,
          scale: LinearScale(min: 0, max: 100),
        ),
      },
      marks: [
        PolygonMark(
          color: ColorEncode(
            variable: 'value',
            values: const [Color(0xFFE8F5E9), Color(0xFFFFC107), Color(0xFFD32F2F)],
            updaters: {
              'tap': {false: (c) => c.withAlpha(120)},
            },
          ),
          label: LabelEncode(
            encoder: (t) => Label(
              '${t['value']}',
              LabelStyle(textStyle: const TextStyle(fontSize: 9)),
            ),
          ),
        ),
      ],
      axes: [
        Defaults.horizontalAxis..grid = null,
        Defaults.verticalAxis..grid = null,
      ],
      selections: {'tap': PointSelection()},
      tooltip: TooltipGuide(),
    );
  }
}

// 55 ────────────────────────────────────────────────────────────
class _GrNightingale extends StatelessWidget {
  const _GrNightingale();

  @override
  Widget build(BuildContext context) {
    final data = [
      for (var i = 0; i < 12; i++)
        {'month': SampleData.months[i], 'rain': SampleData.monthlyRain[i]},
    ];
    return Chart(
      data: data,
      variables: {
        'month': Variable(
          accessor: (Map m) => m['month'] as String,
          scale: OrdinalScale(),
        ),
        'rain': Variable(
          accessor: (Map m) => m['rain'] as num,
          scale: LinearScale(min: 0, max: 150),
        ),
      },
      marks: [
        IntervalMark(
          color: ColorEncode(
            variable: 'rain',
            values: const [Color(0xFFBBDEFB), Color(0xFF0D47A1)],
            updaters: {
              'tap': {false: (c) => c.withAlpha(110)},
            },
          ),
          elevation: ElevationEncode(value: 3),
        ),
      ],
      coord: PolarCoord(startRadius: 0.1),
      axes: [Defaults.circularAxis],
      selections: {'tap': PointSelection(variable: 'month')},
      tooltip: TooltipGuide(),
    );
  }
}

// 56 ────────────────────────────────────────────────────────────
class _GrBubbles extends StatelessWidget {
  const _GrBubbles();

  @override
  Widget build(BuildContext context) {
    final data = [
      for (final b in SampleData.countryBubbles)
        {'country': b.label, 'gdp': b.x, 'life': b.y, 'pop': b.size},
    ];
    return Chart(
      data: data,
      padding: (_) => const EdgeInsets.fromLTRB(40, 16, 16, 34),
      variables: {
        'country': Variable(accessor: (Map m) => m['country'] as String),
        'gdp': Variable(
          accessor: (Map m) => m['gdp'] as num,
          scale: LinearScale(min: 4, max: 20, tickCount: 5),
        ),
        'life': Variable(
          accessor: (Map m) => m['life'] as num,
          scale: LinearScale(min: 70, max: 82, tickCount: 5),
        ),
        'pop': Variable(
          accessor: (Map m) => m['pop'] as num,
          scale: LinearScale(min: 0, max: 220),
        ),
      },
      marks: [
        PointMark(
          position: Varset('gdp') * Varset('life'),
          size: SizeEncode(variable: 'pop', values: [14, 60]),
          color: ColorEncode(
            variable: 'country',
            values: [for (final c in ChartColors.palette) c.withAlpha(185)],
          ),
          label: LabelEncode(
            encoder: (t) => Label(
              '${t['country']}',
              LabelStyle(textStyle: const TextStyle(fontSize: 9)),
            ),
          ),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      selections: {'tap': PointSelection()},
      tooltip: TooltipGuide(),
    );
  }
}

// 57 ────────────────────────────────────────────────────────────
class _GrRangeArea extends StatelessWidget {
  const _GrRangeArea();

  @override
  Widget build(BuildContext context) {
    final data = [
      for (final r in SampleData.monthlyTempRange)
        {'month': r.label, 'low': r.low, 'high': r.high},
    ];
    return Chart(
      data: data,
      padding: (_) => const EdgeInsets.fromLTRB(40, 16, 16, 30),
      variables: {
        'month': Variable(
          accessor: (Map m) => m['month'] as String,
          scale: OrdinalScale(tickCount: 12),
        ),
        'low': Variable(
          accessor: (Map m) => m['low'] as num,
          scale: LinearScale(min: 8, max: 30, tickCount: 5),
        ),
        'high': Variable(
          accessor: (Map m) => m['high'] as num,
          scale: LinearScale(min: 8, max: 30, tickCount: 5),
        ),
      },
      marks: [
        AreaMark(
          position: Varset('month') * (Varset('low') + Varset('high')),
          shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
          color: ColorEncode(value: ChartColors.orange.withAlpha(110)),
        ),
        LineMark(
          position: Varset('month') * Varset('high'),
          shape: ShapeEncode(value: BasicLineShape(smooth: true)),
          size: SizeEncode(value: 2),
          color: ColorEncode(value: ChartColors.red),
        ),
        LineMark(
          position: Varset('month') * Varset('low'),
          shape: ShapeEncode(value: BasicLineShape(smooth: true)),
          size: SizeEncode(value: 2),
          color: ColorEncode(value: ChartColors.blue),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      selections: {
        'touch': PointSelection(
          on: {GestureType.hover, GestureType.tap},
          dim: Dim.x,
        ),
      },
      tooltip: TooltipGuide(followPointer: [true, false]),
      crosshair: CrosshairGuide(followPointer: [true, false]),
    );
  }
}

// 58 ────────────────────────────────────────────────────────────
class _GrStacked100 extends StatelessWidget {
  const _GrStacked100();

  @override
  Widget build(BuildContext context) {
    const cols = [
      ChartColors.green,
      ChartColors.blue,
      ChartColors.amber,
      ChartColors.red,
    ];
    final data = <Map<String, dynamic>>[];
    SampleData.gradesByCourse.forEach((course, vals) {
      final total = vals.fold<double>(0, (a, b) => a + b);
      for (var i = 0; i < vals.length; i++) {
        data.add({
          'course': course,
          'band': SampleData.gradeBands[i],
          'pct': vals[i] / total * 100,
        });
      }
    });
    return ChartWithLegend(
      legend: {
        for (var i = 0; i < cols.length; i++) SampleData.gradeBands[i]: cols[i],
      },
      chart: Chart(
        data: data,
        padding: (_) => const EdgeInsets.fromLTRB(40, 12, 12, 30),
        variables: {
          'course': Variable(
            accessor: (Map m) => m['course'] as String,
            scale: OrdinalScale(),
          ),
          'pct': Variable(
            accessor: (Map m) => m['pct'] as num,
            scale: LinearScale(min: 0, max: 100, tickCount: 5),
          ),
          'band': Variable(accessor: (Map m) => m['band'] as String),
        },
        marks: [
          IntervalMark(
            position: Varset('course') * Varset('pct') / Varset('band'),
            color: ColorEncode(variable: 'band', values: cols),
            modifiers: [StackModifier()],
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        selections: {'tap': PointSelection(variable: 'course')},
        tooltip: TooltipGuide(),
      ),
    );
  }
}

// 59 ────────────────────────────────────────────────────────────
class _GrRadialBars extends StatelessWidget {
  const _GrRadialBars();

  @override
  Widget build(BuildContext context) {
    const cols = [
      ChartColors.red,
      ChartColors.green,
      ChartColors.blue,
      ChartColors.amber,
    ];
    final src = SampleData.activityRings;
    return ChartWithLegend(
      legend: {for (var i = 0; i < src.length; i++) src[i].label: cols[i]},
      chart: Chart(
        data: categoryRows(src),
        variables: {
          'label': Variable(
            accessor: (Map m) => m['label'] as String,
            scale: OrdinalScale(),
          ),
          'value': Variable(
            accessor: (Map m) => m['value'] as num,
            scale: LinearScale(min: 0, max: 100),
          ),
        },
        marks: [
          IntervalMark(
            size: SizeEncode(value: 16),
            color: ColorEncode(variable: 'label', values: cols),
            label: LabelEncode(
              encoder: (t) => Label(
                '${t['value']}%',
                LabelStyle(
                  textStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            elevation: ElevationEncode(value: 0, updaters: {
              'tap': {true: (_) => 6},
            }),
          ),
        ],
        coord: PolarCoord(
          transposed: true,
          startRadius: 0.2,
          endAngle: 3 * pi / 2,
        ),
        selections: {'tap': PointSelection(variable: 'label')},
        tooltip: TooltipGuide(),
      ),
    );
  }
}
