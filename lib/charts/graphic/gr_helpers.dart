import '../../data/models.dart';

/// Convierte una lista de [Category] en filas {label, value} para `graphic`.
List<Map<String, dynamic>> categoryRows(List<Category> src) => [
      for (final c in src) {'label': c.label, 'value': c.value},
    ];
