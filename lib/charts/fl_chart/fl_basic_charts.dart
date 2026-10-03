import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../widgets/chart_entry.dart';
import '../../widgets/chart_helpers.dart';
import 'fl_helpers.dart';

/// 10 gráficos básicos con fl_chart.
List<ChartEntry> flBasicCharts() => [
      ChartEntry(
        title: 'Temperatura semanal',
        description: 'Gráfico de líneas con puntos y tooltip táctil.',
        topic: 'Clima',
        library: ChartLibrary.flChart,
        builder: (_) => const _FlLineTemperature(),
      ),
      ChartEntry(
        title: 'Ventas mensuales',
        description: 'Barras verticales con esquinas redondeadas.',
        topic: 'Ventas',
        library: ChartLibrary.flChart,
        builder: (_) => const _FlBarSales(),
      ),
      ChartEntry(
        title: 'Puntos por jugador',
        description: 'Barras horizontales (chart rotado 90°).',
        topic: 'Deportes',
        library: ChartLibrary.flChart,
        builder: (_) => const _FlHorizontalBars(),
      ),
      ChartEntry(
        title: 'Géneros más escuchados',
        description: 'Gráfico de pastel; toca un sector para resaltarlo.',
        topic: 'Música / streaming',
        library: ChartLibrary.flChart,
        builder: (_) => const _FlPie(donut: false),
      ),
      ChartEntry(
        title: 'Distribución de macronutrientes',
        description: 'Gráfico de dona con valor central.',
        topic: 'Salud',
        library: ChartLibrary.flChart,
        builder: (_) => const _FlPie(donut: true),
      ),
      ChartEntry(
        title: 'Pasos diarios',
        description: 'Área curva (spline) con degradado.',
        topic: 'Fitness',
        library: ChartLibrary.flChart,
        builder: (_) => const _FlAreaSteps(),
      ),
      ChartEntry(
        title: 'Altura vs peso',
        description: 'Dispersión de 40 jugadores.',
        topic: 'Deportes',
        library: ChartLibrary.flChart,
        builder: (_) => const _FlScatterPlayers(),
      ),
      ChartEntry(
        title: 'Goles local vs visitante',
        description: 'Barras agrupadas con leyenda.',
        topic: 'Deportes',
        library: ChartLibrary.flChart,
        builder: (_) => const _FlGroupedGoals(),
      ),
      ChartEntry(
        title: 'Consumo eléctrico por hora',
        description: 'Línea escalonada (step line).',
        topic: 'Energía',
        library: ChartLibrary.flChart,
        builder: (_) => const _FlStepEnergy(),
      ),
      ChartEntry(
        title: 'Ventas apiladas por producto',
        description: 'Columnas apiladas por trimestre.',
        topic: 'Ventas',
        library: ChartLibrary.flChart,
        builder: (_) => const _FlStackedProducts(),
      ),
    ];

// 1 ─────────────────────────────────────────────────────────────
class _FlLineTemperature extends StatelessWidget {
  const _FlLineTemperature();

  @override
  Widget build(BuildContext context) {
    return ChartPad(
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 6,
          minY: 18,
          maxY: 32,
          gridData: softGrid(),
          borderData: noBorder(),
          titlesData: flTitles(
            bottomLabels: SampleData.weekDays,
            leftInterval: 4,
            leftFormat: (v) => '${v.toInt()}°',
            leftReserved: 34,
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => [
                for (final s in spots)
                  LineTooltipItem(
                    '${s.y.toStringAsFixed(0)} °C',
                    tooltipTextStyle,
                  ),
              ],
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < SampleData.weeklyTemp.length; i++)
                  FlSpot(i.toDouble(), SampleData.weeklyTemp[i]),
              ],
              color: ChartColors.orange,
              barWidth: 3,
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}

// 2 ─────────────────────────────────────────────────────────────
class _FlBarSales extends StatelessWidget {
  const _FlBarSales();

  @override
  Widget build(BuildContext context) {
    return ChartPad(
      child: BarChart(
        BarChartData(
          maxY: 250,
          gridData: softGrid(),
          borderData: noBorder(),
          titlesData: flTitles(
            bottomLabels: SampleData.months,
            leftInterval: 50,
            leftFormat: (v) => '\$${v.toInt()}M',
            leftReserved: 46,
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, gi, rod, ri) => BarTooltipItem(
                '${SampleData.months[group.x]}\n\$${rod.toY.toInt()}M',
                tooltipTextStyle,
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < SampleData.monthlySales.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: SampleData.monthlySales[i],
                    color: ChartColors.blue,
                    width: 14,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// 3 ─────────────────────────────────────────────────────────────
class _FlHorizontalBars extends StatelessWidget {
  const _FlHorizontalBars();

  @override
  Widget build(BuildContext context) {
    final data = SampleData.basketPoints;
    // Con rotationQuarterTurns: 1 el eje X pasa a ser vertical (de arriba a abajo).
    return ChartPad(
      child: BarChart(
        BarChartData(
          rotationQuarterTurns: 1,
          maxY: 32,
          gridData: softGrid(),
          borderData: noBorder(),
          alignment: BarChartAlignment.spaceAround,
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            leftTitles: const AxisTitles(),
            // El chart está rotado 90° en sentido horario: el eje inferior
            // (categorías) queda a la izquierda y el derecho (valores) abajo.
            bottomTitles: indexTitles(data.map((e) => e.label).toList(),
                reserved: 56),
            rightTitles: valueTitles(interval: 8, reserved: 26),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, gi, rod, ri) => BarTooltipItem(
                '${data[group.x].label}: ${rod.toY}',
                tooltipTextStyle,
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < data.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: data[i].value,
                    color: ChartColors.at(i),
                    width: 18,
                    borderRadius:
                        const BorderRadius.horizontal(right: Radius.circular(4)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// 4 y 5 ─────────────────────────────────────────────────────────
class _FlPie extends StatefulWidget {
  const _FlPie({required this.donut});

  final bool donut;

  @override
  State<_FlPie> createState() => _FlPieState();
}

class _FlPieState extends State<_FlPie> {
  int _touched = -1;

  @override
  Widget build(BuildContext context) {
    final data = widget.donut ? SampleData.macros : SampleData.genreShare;
    final total = data.fold<double>(0, (a, b) => a + b.value);
    final legend = {
      for (var i = 0; i < data.length; i++) data[i].label: ChartColors.at(i),
    };

    final pie = PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: widget.donut ? 52 : 0,
        pieTouchData: PieTouchData(
          touchCallback: (event, response) {
            setState(() {
              _touched = (!event.isInterestedForInteractions ||
                      response?.touchedSection == null)
                  ? -1
                  : response!.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        sections: [
          for (var i = 0; i < data.length; i++)
            PieChartSectionData(
              value: data[i].value,
              color: ChartColors.at(i),
              radius: i == _touched ? (widget.donut ? 74 : 112) : (widget.donut ? 62 : 100),
              title: '${(data[i].value / total * 100).round()}%',
              titleStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: i == _touched ? 15 : 12,
              ),
            ),
        ],
      ),
    );

    return ChartWithLegend(
      legend: legend,
      chart: widget.donut
          ? Stack(
              alignment: Alignment.center,
              children: [
                pie,
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('2.100',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    Text('kcal', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            )
          : pie,
    );
  }
}

// 6 ─────────────────────────────────────────────────────────────
class _FlAreaSteps extends StatelessWidget {
  const _FlAreaSteps();

  @override
  Widget build(BuildContext context) {
    final steps = SampleData.dailySteps;
    return ChartPad(
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: steps.length - 1.0,
          minY: 0,
          maxY: 15000,
          gridData: softGrid(),
          borderData: noBorder(),
          titlesData: flTitles(
            bottomInterval: 2,
            bottomFormat: (v) => 'D${v.toInt() + 1}',
            leftInterval: 5000,
            leftFormat: (v) => '${(v / 1000).toStringAsFixed(0)}k',
            leftReserved: 34,
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < steps.length; i++)
                  FlSpot(i.toDouble(), steps[i]),
              ],
              isCurved: true,
              curveSmoothness: 0.3,
              color: ChartColors.green,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: fadeGradient(ChartColors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 7 ─────────────────────────────────────────────────────────────
class _FlScatterPlayers extends StatelessWidget {
  const _FlScatterPlayers();

  @override
  Widget build(BuildContext context) {
    return ChartPad(
      child: ScatterChart(
        ScatterChartData(
          minX: 165,
          maxX: 200,
          minY: 55,
          maxY: 100,
          gridData: softGrid(vertical: true),
          borderData: bottomLeftBorder(),
          titlesData: flTitles(
            bottomInterval: 5,
            bottomFormat: (v) => '${v.toInt()}cm',
            leftInterval: 10,
            leftFormat: (v) => '${v.toInt()}kg',
            leftReserved: 44,
          ),
          scatterSpots: [
            for (final p in SampleData.playersHeightWeight)
              ScatterSpot(
                p.x,
                p.y,
                dotPainter: FlDotCirclePainter(
                  radius: 5,
                  color: ChartColors.purple.withValues(alpha: 0.7),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// 8 ─────────────────────────────────────────────────────────────
class _FlGroupedGoals extends StatelessWidget {
  const _FlGroupedGoals();

  @override
  Widget build(BuildContext context) {
    final teams = SampleData.teamGoals;
    return ChartWithLegend(
      legend: const {
        'Local': ChartColors.blue,
        'Visitante': ChartColors.orange,
      },
      chart: ChartPad(
        child: BarChart(
          BarChartData(
            maxY: 24,
            gridData: softGrid(),
            borderData: noBorder(),
            titlesData: flTitles(
              bottomLabels: teams.map((t) => t.$1).toList(),
              leftInterval: 6,
              leftReserved: 30,
            ),
            barGroups: [
              for (var i = 0; i < teams.length; i++)
                BarChartGroupData(
                  x: i,
                  barsSpace: 4,
                  barRods: [
                    BarChartRodData(
                      toY: teams[i].$2,
                      color: ChartColors.blue,
                      width: 12,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(3)),
                    ),
                    BarChartRodData(
                      toY: teams[i].$3,
                      color: ChartColors.orange,
                      width: 12,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(3)),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// 9 ─────────────────────────────────────────────────────────────
class _FlStepEnergy extends StatelessWidget {
  const _FlStepEnergy();

  @override
  Widget build(BuildContext context) {
    final e = SampleData.hourlyEnergy;
    return ChartPad(
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 23,
          minY: 0,
          maxY: 5,
          gridData: softGrid(),
          borderData: noBorder(),
          titlesData: flTitles(
            bottomInterval: 4,
            bottomFormat: (v) => '${v.toInt()}h',
            leftInterval: 1,
            leftFormat: (v) => '${v.toInt()} kW',
            leftReserved: 46,
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [for (var i = 0; i < e.length; i++) FlSpot(i.toDouble(), e[i])],
              isStepLineChart: true,
              lineChartStepData: const LineChartStepData(stepDirection: 0),
              color: ChartColors.teal,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: ChartColors.teal.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 10 ────────────────────────────────────────────────────────────
class _FlStackedProducts extends StatelessWidget {
  const _FlStackedProducts();

  @override
  Widget build(BuildContext context) {
    final cols = [ChartColors.indigo, ChartColors.orange, ChartColors.teal];
    final names = SampleData.productNames;
    return ChartWithLegend(
      legend: {for (var i = 0; i < names.length; i++) names[i]: cols[i]},
      chart: ChartPad(
        child: BarChart(
          BarChartData(
            maxY: 250,
            gridData: softGrid(),
            borderData: noBorder(),
            titlesData: flTitles(
              bottomLabels: SampleData.quarters,
              leftInterval: 50,
              leftReserved: 34,
            ),
            barGroups: [
              for (var q = 0; q < SampleData.quarterlyByProduct.length; q++)
                () {
                  final vals = SampleData.quarterlyByProduct[q];
                  var acc = 0.0;
                  final items = <BarChartRodStackItem>[];
                  for (var p = 0; p < vals.length; p++) {
                    items.add(BarChartRodStackItem(acc, acc + vals[p], cols[p]));
                    acc += vals[p];
                  }
                  return BarChartGroupData(
                    x: q,
                    barRods: [
                      BarChartRodData(
                        toY: acc,
                        width: 34,
                        rodStackItems: items,
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ],
                  );
                }(),
            ],
          ),
        ),
      ),
    );
  }
}
