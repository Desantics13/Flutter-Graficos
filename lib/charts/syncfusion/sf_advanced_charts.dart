import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

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

/// 6 gráficos avanzados con syncfusion_flutter_charts (+ sparkcharts).
List<ChartEntry> sfAdvancedCharts() => [
      ChartEntry(
        title: 'Velas con zoom y trackball',
        description: 'CandleSeries; arrastra para desplazar, rueda para zoom.',
        topic: 'Finanzas / acciones',
        library: ChartLibrary.syncfusion,
        builder: (_) => const _SfCandles(),
      ),
      ChartEntry(
        title: 'OHLC con crosshair',
        description: 'HiloOpenCloseSeries con cruz de lectura al tocar.',
        topic: 'Finanzas / acciones',
        library: ChartLibrary.syncfusion,
        builder: (_) => const _SfOhlc(),
      ),
      ChartEntry(
        title: 'Flujo de caja (cascada)',
        description: 'WaterfallSeries con total y conectores.',
        topic: 'Finanzas personales',
        library: ChartLibrary.syncfusion,
        builder: (_) => const _SfWaterfall(),
      ),
      ChartEntry(
        title: 'Embudo de conversión',
        description: 'SfFunnelChart con etiquetas y tooltip.',
        topic: 'Ventas e-commerce',
        library: ChartLibrary.syncfusion,
        builder: (_) => const _SfFunnel(),
      ),
      ChartEntry(
        title: 'Pirámide alimenticia',
        description: 'SfPyramidChart con selección de segmentos.',
        topic: 'Salud',
        library: ChartLibrary.syncfusion,
        builder: (_) => const _SfPyramid(),
      ),
      ChartEntry(
        title: 'Panel de sparklines',
        description: 'SfSparkLine, Area, Bar y WinLoss (sparkcharts).',
        topic: 'Ventas / KPIs',
        library: ChartLibrary.syncfusion,
        builder: (_) => const _SfSparkPanel(),
      ),
    ];

// 48 ────────────────────────────────────────────────────────────
class _SfCandles extends StatelessWidget {
  const _SfCandles();

  @override
  Widget build(BuildContext context) {
    final data = SampleData.candles(70, seed: 12, start: 80);
    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(4, 12, 12, 4),
      primaryXAxis: const DateTimeAxis(
        majorGridLines: _noGrid,
        autoScrollingDelta: 28,
        autoScrollingDeltaType: DateTimeIntervalType.days,
        autoScrollingMode: AutoScrollingMode.end,
        labelStyle: _labelStyle,
      ),
      primaryYAxis: const NumericAxis(
        majorGridLines: _softGrid,
        axisLine: AxisLine(width: 0),
        labelStyle: _labelStyle,
      ),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        enablePanning: true,
        enableMouseWheelZooming: true,
        zoomMode: ZoomMode.x,
      ),
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipSettings: const InteractiveTooltip(format: 'point.x'),
      ),
      series: <CartesianSeries<Candle, DateTime>>[
        CandleSeries<Candle, DateTime>(
          dataSource: data,
          xValueMapper: (c, _) => c.date,
          lowValueMapper: (c, _) => c.low,
          highValueMapper: (c, _) => c.high,
          openValueMapper: (c, _) => c.open,
          closeValueMapper: (c, _) => c.close,
          bullColor: ChartColors.green,
          bearColor: ChartColors.red,
          enableSolidCandles: true,
        ),
      ],
    );
  }
}

// 49 ────────────────────────────────────────────────────────────
class _SfOhlc extends StatelessWidget {
  const _SfOhlc();

  @override
  Widget build(BuildContext context) {
    final data = SampleData.candles(30, seed: 41, start: 150);
    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(4, 12, 12, 4),
      primaryXAxis: const DateTimeAxis(
        majorGridLines: _noGrid,
        labelStyle: _labelStyle,
      ),
      primaryYAxis: const NumericAxis(
        majorGridLines: _softGrid,
        axisLine: AxisLine(width: 0),
        labelStyle: _labelStyle,
      ),
      crosshairBehavior: CrosshairBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        lineType: CrosshairLineType.both,
        lineColor: ChartColors.slate,
      ),
      series: <CartesianSeries<Candle, DateTime>>[
        HiloOpenCloseSeries<Candle, DateTime>(
          dataSource: data,
          xValueMapper: (c, _) => c.date,
          lowValueMapper: (c, _) => c.low,
          highValueMapper: (c, _) => c.high,
          openValueMapper: (c, _) => c.open,
          closeValueMapper: (c, _) => c.close,
          bullColor: ChartColors.teal,
          bearColor: ChartColors.pink,
        ),
      ],
    );
  }
}

// 50 ────────────────────────────────────────────────────────────
class _SfWaterfall extends StatelessWidget {
  const _SfWaterfall();

  @override
  Widget build(BuildContext context) {
    final data = [...SampleData.cashFlow, const Category('Saldo final', 0)];
    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(4, 12, 12, 4),
      primaryXAxis: const CategoryAxis(
        majorGridLines: _noGrid,
        labelStyle: TextStyle(fontSize: 10),
        labelIntersectAction: AxisLabelIntersectAction.rotate45,
      ),
      primaryYAxis: const NumericAxis(
        majorGridLines: _softGrid,
        axisLine: AxisLine(width: 0),
        labelFormat: '\${value}',
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<Category, String>>[
        WaterfallSeries<Category, String>(
          dataSource: data,
          xValueMapper: (c, _) => c.label,
          yValueMapper: (c, _) => c.value,
          totalSumPredicate: (c, i) => i == data.length - 1,
          color: ChartColors.green,
          negativePointsColor: ChartColors.red,
          totalSumColor: ChartColors.indigo,
          spacing: 0.15,
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}

// 51 ────────────────────────────────────────────────────────────
class _SfFunnel extends StatelessWidget {
  const _SfFunnel();

  @override
  Widget build(BuildContext context) {
    return SfFunnelChart(
      palette: ChartColors.palette,
      legend: _bottomLegend,
      tooltipBehavior: TooltipBehavior(enable: true),
      series: FunnelSeries<Category, String>(
        dataSource: SampleData.funnel.reversed.toList(),
        xValueMapper: (c, _) => c.label,
        yValueMapper: (c, _) => c.value,
        neckWidth: '18%',
        neckHeight: '18%',
        gapRatio: 0.04,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// 52 ────────────────────────────────────────────────────────────
class _SfPyramid extends StatelessWidget {
  const _SfPyramid();

  @override
  Widget build(BuildContext context) {
    return SfPyramidChart(
      palette: const [
        ChartColors.red,
        ChartColors.amber,
        ChartColors.pink,
        ChartColors.green,
        ChartColors.orange,
      ],
      legend: _bottomLegend,
      tooltipBehavior: TooltipBehavior(enable: true),
      series: PyramidSeries<Category, String>(
        dataSource: SampleData.foodPyramid,
        xValueMapper: (c, _) => c.label,
        yValueMapper: (c, _) => c.value,
        gapRatio: 0.04,
        selectionBehavior: SelectionBehavior(enable: true),
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// 53 ────────────────────────────────────────────────────────────
class _SfSparkPanel extends StatelessWidget {
  const _SfSparkPanel();

  static const _winLoss = [3.0, -2.0, 1.0, 4.0, -1.0, -3.0, 2.0, 5.0, -2.0, 1.0, 3.0, -1.0];

  @override
  Widget build(BuildContext context) {
    Widget row(String title, String value, Widget chart) => Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 110,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontSize: 12, color: Colors.black54)),
                    Text(value,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: chart,
              )),
            ],
          ),
        );

    return Column(
      children: [
        row(
          'Ventas',
          '\$230M',
          SfSparkAreaChart(
            data: SampleData.monthlySales,
            color: ChartColors.blue.withValues(alpha: 0.35),
            borderColor: ChartColors.blue,
            borderWidth: 2,
            axisLineWidth: 0,
          ),
        ),
        const Divider(height: 1),
        row(
          'Visitas',
          '620',
          SfSparkLineChart(
            data: SampleData.dailyVisits,
            color: ChartColors.orange,
            axisLineWidth: 0,
            marker: const SparkChartMarker(
              displayMode: SparkChartMarkerDisplayMode.all,
              size: 5,
            ),
            trackball: const SparkChartTrackball(
              activationMode: SparkChartActivationMode.tap,
            ),
          ),
        ),
        const Divider(height: 1),
        row(
          'Pedidos/día',
          '1.240',
          SfSparkBarChart(
            data: SampleData.dailySteps.take(12).toList(),
            color: ChartColors.teal,
            highPointColor: ChartColors.green,
            lowPointColor: ChartColors.red,
            axisLineWidth: 0,
          ),
        ),
        const Divider(height: 1),
        row(
          'Resultado',
          '7 G · 5 P',
          SfSparkWinLossChart(
            data: _winLoss,
            color: ChartColors.green,
            negativePointColor: ChartColors.red,
            axisLineWidth: 0,
          ),
        ),
      ],
    );
  }
}
