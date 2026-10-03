import 'package:flutter/material.dart';

import 'chart_entry.dart';

/// Insignia con el nombre de la librería que dibuja el gráfico.
class LibraryBadge extends StatelessWidget {
  const LibraryBadge(this.library, {super.key});

  final ChartLibrary library;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: library.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        library.label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
