import '../widgets/chart_entry.dart';
import 'community/cm_advanced_charts.dart';
import 'community/cm_basic_charts.dart';
import 'fl_chart/fl_advanced_charts.dart';
import 'fl_chart/fl_basic_charts.dart';
import 'graphic/gr_advanced_charts.dart';
import 'graphic/gr_basic_charts.dart';
import 'syncfusion/sf_advanced_charts.dart';
import 'syncfusion/sf_basic_charts.dart';

/// Registro central: numera los gráficos (1-40 básicos, 41-65 avanzados).
///
/// Básicos: 10 por librería (fl_chart, Syncfusion, graphic, community).
/// Avanzados: 7 fl_chart, 6 Syncfusion, 6 graphic, 6 community.
class ChartRegistry {
  ChartRegistry._();

  static List<ChartEntry> _number(List<ChartEntry> list, int start) => [
        for (var i = 0; i < list.length; i++) list[i].withNumber(start + i),
      ];

  static final List<ChartEntry> basic = _number([
    ...flBasicCharts(),
    ...sfBasicCharts(),
    ...grBasicCharts(),
    ...cmBasicCharts(),
  ], 1);

  static final List<ChartEntry> advanced = _number([
    ...flAdvancedCharts(),
    ...sfAdvancedCharts(),
    ...grAdvancedCharts(),
    ...cmAdvancedCharts(),
  ], basic.length + 1);
}
