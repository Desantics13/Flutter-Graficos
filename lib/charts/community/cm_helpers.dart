import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../data/sample_data.dart';

/// Convierte un [Color] de Flutter al color propio de community_charts.
charts.Color cmColor(Color c) => charts.ColorUtil.fromDartColor(c);

/// Eje X numérico (1–12) con las abreviaturas de los meses.
charts.NumericAxisSpec monthAxis() => charts.NumericAxisSpec(
      tickProviderSpec: charts.StaticNumericTickProviderSpec([
        for (var i = 0; i < 12; i += 2)
          charts.TickSpec<num>(i + 1, label: SampleData.months[i]),
      ]),
      renderSpec: const charts.SmallTickRendererSpec(
        labelStyle: charts.TextStyleSpec(fontSize: 10),
      ),
    );
