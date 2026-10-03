import 'package:flutter/material.dart';

import 'charts/chart_registry.dart';
import 'widgets/chart_grid.dart';

void main() => runApp(const GraficosApp());

class GraficosApp extends StatelessWidget {
  const GraficosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard de Gráficos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3949AB),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final basic = ChartRegistry.basic;
    final advanced = ChartRegistry.advanced;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard de Gráficos'),
          centerTitle: false,
          backgroundColor: Theme.of(context).colorScheme.surface,
          scrolledUnderElevation: 1,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: const Icon(Icons.bar_chart_rounded),
                text: 'Básicos (${basic.length})',
              ),
              Tab(
                icon: const Icon(Icons.candlestick_chart_rounded),
                text: 'Avanzados (${advanced.length})',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChartsTab(entries: basic),
            ChartsTab(entries: advanced),
          ],
        ),
      ),
    );
  }
}
