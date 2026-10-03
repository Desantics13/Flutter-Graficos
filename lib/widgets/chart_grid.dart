import 'package:flutter/material.dart';

import 'chart_card.dart';
import 'chart_entry.dart';

/// Cuadrícula responsiva: 1, 2 o 3 columnas según el ancho disponible.
class ChartGrid extends StatelessWidget {
  const ChartGrid({super.key, required this.entries});

  final List<ChartEntry> entries;

  static const double cardHeight = 500;

  static int columnsFor(double width) {
    if (width >= 1180) return 3;
    if (width >= 760) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = columnsFor(constraints.maxWidth);
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            mainAxisExtent: cardHeight,
          ),
          itemCount: entries.length,
          itemBuilder: (context, i) => ChartCard(
            key: ValueKey(entries[i].number),
            entry: entries[i],
          ),
        );
      },
    );
  }
}

/// Pestaña con filtro por librería + cuadrícula de gráficos.
class ChartsTab extends StatefulWidget {
  const ChartsTab({super.key, required this.entries});

  final List<ChartEntry> entries;

  @override
  State<ChartsTab> createState() => _ChartsTabState();
}

class _ChartsTabState extends State<ChartsTab>
    with AutomaticKeepAliveClientMixin {
  ChartLibrary? _selected;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final filtered = _selected == null
        ? widget.entries
        : widget.entries.where((e) => e.library == _selected).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ChoiceChip(
                  label: Text('Todas (${widget.entries.length})'),
                  selected: _selected == null,
                  onSelected: (_) => setState(() => _selected = null),
                ),
                for (final lib in ChartLibrary.values)
                  ChoiceChip(
                    avatar: CircleAvatar(
                      backgroundColor: lib.color,
                      radius: 6,
                    ),
                    label: Text(
                      '${lib.label} '
                      '(${widget.entries.where((e) => e.library == lib).length})',
                    ),
                    selected: _selected == lib,
                    onSelected: (_) => setState(() => _selected = lib),
                  ),
              ],
            ),
          ),
        ),
        Expanded(child: ChartGrid(entries: filtered)),
      ],
    );
  }
}
