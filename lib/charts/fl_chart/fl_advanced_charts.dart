import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../widgets/chart_entry.dart';
import '../../widgets/chart_helpers.dart';
import 'fl_helpers.dart';

/// 7 gráficos avanzados con fl_chart.
List<ChartEntry> flAdvancedCharts() => [
      ChartEntry(
        title: 'Radar de habilidades',
        description: 'Radar comparativo; los chips muestran u ocultan jugadores.',
        topic: 'Deportes',
        library: ChartLibrary.flChart,
        builder: (_) => const _FlRadarSkills(),
      ),
      ChartEntry(
        title: 'Velas japonesas',
        description: 'CandlestickChart con tooltip y zoom/pan horizontal.',
        topic: 'Finanzas / acciones',
        library: ChartLibrary.flChart,
        builder: (_) => const _FlCandles(),
      ),
      ChartEntry(
        title: 'Frecuencia cardíaca en vivo',
        description: 'Datos en tiempo real con Timer; pausa y reanuda.',
        topic: 'Salud',
        library: ChartLibrary.flChart,
        builder: (_) => const _FlRealtimeHeart(),
      ),
      ChartEntry(
        title: 'Temperatura 72 h con zoom',
        description: 'Zoom y desplazamiento (pellizco, rueda o arrastre).',
        topic: 'Clima',
        library: ChartLibrary.flChart,
        builder: (_) => const _FlZoomPan(),
      ),
      ChartEntry(
        title: 'Burbujas: horas vs puntuación',
        description: 'Dispersión con tamaño variable y tooltip al tocar.',
        topic: 'Videojuegos',
        library: ChartLibrary.flChart,
        builder: (_) => const _FlBubbleGames(),
      ),
      ChartEntry(
        title: 'Interacciones por día',
        description: 'Selección táctil y animación al actualizar datos.',
        topic: 'Redes sociales',
        library: ChartLibrary.flChart,
        builder: (_) => const _FlInteractiveBars(),
      ),
      ChartEntry(
        title: 'Producción renovable',
        description: 'Áreas con degradado filtradas por chips.',
        topic: 'Energía',
        library: ChartLibrary.flChart,
        builder: (_) => const _FlEnergyChips(),
      ),
    ];

// 41 ────────────────────────────────────────────────────────────
class _FlRadarSkills extends StatefulWidget {
  const _FlRadarSkills();

  @override
  State<_FlRadarSkills> createState() => _FlRadarSkillsState();
}

class _FlRadarSkillsState extends State<_FlRadarSkills> {
  bool _showA = true;
  bool _showB = true;

  RadarDataSet _set(List<double> v, Color c) => RadarDataSet(
        fillColor: c.withValues(alpha: 0.25),
        borderColor: c,
        borderWidth: 2,
        entryRadius: 3,
        dataEntries: [for (final x in v) RadarEntry(value: x)],
      );

  @override
  Widget build(BuildContext context) {
    final sets = [
      if (_showA) _set(SampleData.playerA, ChartColors.blue),
      if (_showB) _set(SampleData.playerB, ChartColors.orange),
    ];
    return Column(
      children: [
        Wrap(
          spacing: 8,
          children: [
            FilterChip(
              label: const Text('Jugador A'),
              selected: _showA,
              selectedColor: ChartColors.blue.withValues(alpha: 0.25),
              onSelected: (v) => setState(() => _showA = v),
            ),
            FilterChip(
              label: const Text('Jugador B'),
              selected: _showB,
              selectedColor: ChartColors.orange.withValues(alpha: 0.25),
              onSelected: (v) => setState(() => _showB = v),
            ),
          ],
        ),
        Expanded(
          child: sets.isEmpty
              ? const Center(child: Text('Selecciona un jugador'))
              : RadarChart(
                  RadarChartData(
                    dataSets: [
                      // Conjunto invisible que fija la escala 0–100.
                      RadarDataSet(
                        fillColor: Colors.transparent,
                        borderColor: Colors.transparent,
                        entryRadius: 0,
                        borderWidth: 0,
                        dataEntries: [
                          for (var i = 0; i < 6; i++)
                            RadarEntry(value: i == 0 ? 100 : 0),
                        ],
                      ),
                      ...sets,
                    ],
                    radarShape: RadarShape.polygon,
                    tickCount: 4,
                    ticksTextStyle:
                        const TextStyle(fontSize: 9, color: Colors.black38),
                    tickBorderData: const BorderSide(color: Colors.black12),
                    gridBorderData:
                        const BorderSide(color: Colors.black26, width: 1.2),
                    radarBorderData: const BorderSide(color: Colors.black26),
                    titleTextStyle: const TextStyle(fontSize: 12),
                    titlePositionPercentageOffset: 0.12,
                    getTitle: (i, angle) =>
                        RadarChartTitle(text: SampleData.playerSkills[i]),
                  ),
                ),
        ),
      ],
    );
  }
}

// 42 ────────────────────────────────────────────────────────────
class _FlCandles extends StatelessWidget {
  const _FlCandles();

  @override
  Widget build(BuildContext context) {
    final candles = SampleData.candles(45, seed: 5);
    return ChartPad(
      child: CandlestickChart(
        CandlestickChartData(
          minX: -1,
          maxX: candles.length.toDouble(),
          gridData: softGrid(),
          borderData: bottomLeftBorder(),
          titlesData: flTitles(
            bottomInterval: 8,
            bottomFormat: (v) {
              final i = v.toInt();
              if (i < 0 || i >= candles.length) return '';
              final d = candles[i].date;
              return '${d.day}/${d.month}';
            },
            leftFormat: (v) => v.toStringAsFixed(0),
            leftReserved: 40,
          ),
          candlestickSpots: [
            for (var i = 0; i < candles.length; i++)
              CandlestickSpot(
                x: i.toDouble(),
                open: candles[i].open,
                high: candles[i].high,
                low: candles[i].low,
                close: candles[i].close,
              ),
          ],
          candlestickPainter: DefaultCandlestickPainter(
            candlestickStyleProvider: (spot, i) {
              final c = spot.isUp ? ChartColors.green : ChartColors.red;
              return CandlestickStyle(
                lineColor: c,
                lineWidth: 1.5,
                bodyStrokeColor: c,
                bodyStrokeWidth: 1,
                bodyFillColor: c,
                bodyWidth: 5,
                bodyRadius: 1,
              );
            },
          ),
          candlestickTouchData: CandlestickTouchData(
            touchTooltipData: CandlestickTouchTooltipData(
              getTooltipItems: (painter, spot, i) {
                const s = TextStyle(color: Colors.white, fontSize: 12);
                return CandlestickTooltipItem(
                  '',
                  textStyle: s,
                  children: [
                    TextSpan(
                      text: 'Apertura ${spot.open.toStringAsFixed(1)}\n'
                          'Máximo ${spot.high.toStringAsFixed(1)}\n'
                          'Mínimo ${spot.low.toStringAsFixed(1)}\n'
                          'Cierre ${spot.close.toStringAsFixed(1)}',
                      style: s,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        transformationConfig: const FlTransformationConfig(
          scaleAxis: FlScaleAxis.horizontal,
          minScale: 1,
          maxScale: 5,
        ),
      ),
    );
  }
}

// 43 ────────────────────────────────────────────────────────────
class _FlRealtimeHeart extends StatefulWidget {
  const _FlRealtimeHeart();

  @override
  State<_FlRealtimeHeart> createState() => _FlRealtimeHeartState();
}

class _FlRealtimeHeartState extends State<_FlRealtimeHeart> {
  static const _window = 40;
  final _points = <FlSpot>[];
  final _rnd = Random(2);
  Timer? _timer;
  double _t = 0;
  bool _running = true;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < _window; i++) {
      _push();
    }
    _timer = Timer.periodic(const Duration(milliseconds: 400), (_) {
      if (_running) setState(_push);
    });
  }

  void _push() {
    _t += 1;
    final bpm = 76 + 12 * sin(_t / 6) + (_rnd.nextDouble() - 0.5) * 7;
    _points.add(FlSpot(_t, bpm));
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
            const Icon(Icons.favorite, color: ChartColors.red, size: 22),
            const SizedBox(width: 6),
            Text(
              '${_points.last.y.round()} bpm',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
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
          child: LineChart(
            duration: Duration.zero,
            LineChartData(
              minX: _points.first.x,
              maxX: _points.last.x,
              minY: 50,
              maxY: 110,
              clipData: const FlClipData.all(),
              gridData: softGrid(),
              borderData: noBorder(),
              lineTouchData: const LineTouchData(enabled: false),
              titlesData: flTitles(
                showBottom: false,
                leftInterval: 20,
                leftReserved: 32,
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: List.of(_points),
                  isCurved: true,
                  color: ChartColors.red,
                  barWidth: 2.5,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: fadeGradient(ChartColors.red, top: 0.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// 44 ────────────────────────────────────────────────────────────
class _FlZoomPan extends StatelessWidget {
  const _FlZoomPan();

  @override
  Widget build(BuildContext context) {
    final t = SampleData.hourlyTemp72;
    return ChartPad(
      child: LineChart(
        transformationConfig: const FlTransformationConfig(
          scaleAxis: FlScaleAxis.horizontal,
          minScale: 1,
          maxScale: 8,
        ),
        LineChartData(
          minX: 0,
          maxX: t.length - 1.0,
          minY: 12,
          maxY: 34,
          clipData: const FlClipData.all(),
          gridData: softGrid(vertical: true),
          borderData: bottomLeftBorder(),
          titlesData: flTitles(
            bottomInterval: 6,
            bottomFormat: (v) => '${v.toInt()}h',
            leftInterval: 5,
            leftFormat: (v) => '${v.toInt()}°',
            leftReserved: 34,
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [for (var i = 0; i < t.length; i++) FlSpot(i.toDouble(), t[i])],
              isCurved: true,
              curveSmoothness: 0.25,
              barWidth: 2.5,
              gradient: const LinearGradient(
                colors: [ChartColors.blue, ChartColors.orange, ChartColors.red],
              ),
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}

// 45 ────────────────────────────────────────────────────────────
class _FlBubbleGames extends StatelessWidget {
  const _FlBubbleGames();

  @override
  Widget build(BuildContext context) {
    final games = SampleData.gameBubbles;
    return ChartPad(
      child: ScatterChart(
        ScatterChartData(
          minX: 0,
          maxX: 20,
          minY: 6,
          maxY: 10,
          gridData: softGrid(vertical: true),
          borderData: bottomLeftBorder(),
          titlesData: flTitles(
            bottomInterval: 4,
            bottomFormat: (v) => '${v.toInt()}h',
            leftInterval: 1,
            leftFormat: (v) => v.toStringAsFixed(0),
            leftReserved: 30,
          ),
          scatterTouchData: ScatterTouchData(
            touchTooltipData: ScatterTouchTooltipData(
              getTooltipItems: (spot) {
                final g = games.firstWhere(
                  (b) => b.x == spot.x && b.y == spot.y,
                  orElse: () => games.first,
                );
                return ScatterTooltipItem(
                  '${g.label}\n${g.size.toStringAsFixed(0)} M jugadores\n'
                  'Nota ${g.y}',
                  textStyle: tooltipTextStyle,
                );
              },
            ),
          ),
          scatterSpots: [
            for (var i = 0; i < games.length; i++)
              ScatterSpot(
                games[i].x,
                games[i].y,
                dotPainter: FlDotCirclePainter(
                  radius: 6 + games[i].size * 1.6,
                  color: ChartColors.at(i).withValues(alpha: 0.65),
                  strokeWidth: 2,
                  strokeColor: ChartColors.at(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// 46 ────────────────────────────────────────────────────────────
class _FlInteractiveBars extends StatefulWidget {
  const _FlInteractiveBars();

  @override
  State<_FlInteractiveBars> createState() => _FlInteractiveBarsState();
}

class _FlInteractiveBarsState extends State<_FlInteractiveBars> {
  List<double> _values = List.of(SampleData.engagementDaily);
  int _touched = -1;
  final _rnd = Random(8);

  void _shuffle() => setState(() {
        _values = [for (var i = 0; i < 7; i++) 800 + _rnd.nextDouble() * 3000];
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.tonalIcon(
            onPressed: _shuffle,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Actualizar datos'),
          ),
        ),
        Expanded(
          child: ChartPad(
            child: BarChart(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              BarChartData(
                maxY: 4000,
                gridData: softGrid(),
                borderData: noBorder(),
                titlesData: flTitles(
                  bottomLabels: SampleData.weekDays,
                  leftInterval: 1000,
                  leftFormat: (v) => '${(v / 1000).toStringAsFixed(0)}k',
                  leftReserved: 32,
                ),
                barTouchData: BarTouchData(
                  touchCallback: (event, resp) => setState(() {
                    _touched = (!event.isInterestedForInteractions ||
                            resp?.spot == null)
                        ? -1
                        : resp!.spot!.touchedBarGroupIndex;
                  }),
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (g, gi, rod, ri) => BarTooltipItem(
                      '${SampleData.weekDays[g.x]}\n${rod.toY.round()} interacciones',
                      tooltipTextStyle,
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < _values.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: _values[i],
                          width: i == _touched ? 26 : 20,
                          color:
                              i == _touched ? ChartColors.pink : ChartColors.purple,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 4000,
                            color: Colors.black.withValues(alpha: 0.05),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 47 ────────────────────────────────────────────────────────────
class _FlEnergyChips extends StatefulWidget {
  const _FlEnergyChips();

  @override
  State<_FlEnergyChips> createState() => _FlEnergyChipsState();
}

class _FlEnergyChipsState extends State<_FlEnergyChips> {
  static const _colors = {
    'Solar': ChartColors.amber,
    'Eólica': ChartColors.teal,
    'Hidro': ChartColors.blue,
  };
  final Set<String> _on = {'Solar', 'Eólica', 'Hidro'};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          children: [
            for (final e in _colors.entries)
              FilterChip(
                label: Text(e.key),
                selected: _on.contains(e.key),
                selectedColor: e.value.withValues(alpha: 0.3),
                onSelected: (v) => setState(() {
                  v ? _on.add(e.key) : _on.remove(e.key);
                }),
              ),
          ],
        ),
        Expanded(
          child: ChartPad(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 80,
                gridData: softGrid(),
                borderData: noBorder(),
                titlesData: flTitles(
                  bottomLabels: SampleData.months,
                  leftInterval: 20,
                  leftFormat: (v) => '${v.toInt()}',
                  leftReserved: 30,
                ),
                lineBarsData: [
                  for (final e in SampleData.energyByType.entries)
                    if (_on.contains(e.key))
                      LineChartBarData(
                        spots: [
                          for (var i = 0; i < e.value.length; i++)
                            FlSpot(i.toDouble(), e.value[i]),
                        ],
                        isCurved: true,
                        color: _colors[e.key],
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: fadeGradient(_colors[e.key]!, top: 0.35),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
