import 'dart:math';

import 'models.dart';

/// Datos de ejemplo (ficticios) generados en el código. Los generadores
/// usan semillas fijas para que el dashboard se vea igual en cada ejecución.
class SampleData {
  SampleData._();

  // ───────────────────────── Etiquetas comunes ─────────────────────────
  static const weekDays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  static const months = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic', //
  ];
  static const quarters = ['T1', 'T2', 'T3', 'T4'];

  // ───────────────────────── Clima ─────────────────────────
  static const weeklyTemp = [22.0, 24.0, 23.0, 27.0, 29.0, 26.0, 25.0];
  static const monthlyTempCity1 = [
    14.0, 15.0, 17.0, 19.0, 20.0, 21.0, 22.0, 22.0, 20.0, 18.0, 16.0, 14.0, //
  ];
  static const monthlyTempCity2 = [
    27.0, 28.0, 28.0, 29.0, 29.0, 29.0, 29.0, 29.0, 28.0, 28.0, 28.0, 27.0, //
  ];
  static const monthlyRain = [
    38.0, 42.0, 70.0, 110.0, 135.0, 90.0, 60.0, 65.0, 95.0, 140.0, 120.0, 60.0, //
  ];
  static const humidity12 = [
    82.0, 85.0, 88.0, 80.0, 68.0, 55.0, 48.0, 45.0, 52.0, 63.0, 74.0, 80.0, //
  ];
  static const monthlyTempRange = [
    RangeValue('Ene', 12, 24),
    RangeValue('Feb', 12, 25),
    RangeValue('Mar', 13, 26),
    RangeValue('Abr', 14, 27),
    RangeValue('May', 14, 27),
    RangeValue('Jun', 13, 26),
    RangeValue('Jul', 12, 25),
    RangeValue('Ago', 12, 26),
    RangeValue('Sep', 13, 26),
    RangeValue('Oct', 14, 26),
    RangeValue('Nov', 14, 25),
    RangeValue('Dic', 13, 24),
  ];

  /// 72 horas de temperatura (3 días) con ciclo diurno y algo de ruido.
  static final hourlyTemp72 = () {
    final r = Random(11);
    return List<double>.generate(
      72,
      (h) => 22 + 7 * sin((h - 9) / 24 * 2 * pi) + r.nextDouble() * 1.4,
    );
  }();

  // ───────────────────────── Ventas ─────────────────────────
  static const monthlySales = [
    120.0, 135.0, 150.0, 142.0, 168.0, 190.0, 205.0, 198.0, 176.0, 160.0, 185.0, 230.0, //
  ];
  static const salesByCategory = [
    Category('Electrónica', 320),
    Category('Moda', 280),
    Category('Hogar', 210),
    Category('Deportes', 150),
    Category('Juguetes', 120),
    Category('Libros', 90),
  ];
  static const salesTwoYearsA = [96.0, 118.0, 134.0, 171.0];
  static const salesTwoYearsB = [110.0, 125.0, 160.0, 205.0];

  /// Ventas por trimestre de tres líneas de producto: [Laptops, Móviles, Tablets].
  static const quarterlyByProduct = [
    [45.0, 70.0, 22.0],
    [52.0, 82.0, 25.0],
    [48.0, 90.0, 30.0],
    [75.0, 120.0, 41.0],
  ];
  static const productNames = ['Laptops', 'Móviles', 'Tablets'];

  /// Ventas trimestrales por región: [Norte, Centro, Sur, Costa].
  static const regionSales = [
    [30.0, 42.0, 25.0, 38.0],
    [35.0, 40.0, 28.0, 44.0],
    [32.0, 48.0, 31.0, 52.0],
    [44.0, 61.0, 36.0, 70.0],
  ];
  static const regionNames = ['Norte', 'Centro', 'Sur', 'Costa'];

  /// Ventas de helados vs temperatura media (ejes dobles).
  static const iceCreamSales = [
    35.0, 38.0, 48.0, 60.0, 78.0, 96.0, 112.0, 108.0, 82.0, 60.0, 44.0, 40.0, //
  ];
  static const iceCreamTemp = [
    8.0, 9.0, 12.0, 15.0, 19.0, 24.0, 28.0, 27.0, 22.0, 16.0, 11.0, 8.0, //
  ];
  static const marginPct = [
    18.0, 19.0, 20.0, 22.0, 24.0, 27.0, 29.0, 28.0, 25.0, 22.0, 20.0, 19.0, //
  ];

  /// Embudo de conversión de una tienda en línea.
  static const funnel = [
    Category('Visitas', 10000),
    Category('Registros', 6200),
    Category('Carrito', 3100),
    Category('Pago', 1800),
    Category('Compras', 1100),
  ];

  // ───────────────────────── Finanzas ─────────────────────────
  static const stockClose20 = [
    102.0, 104.5, 103.2, 106.8, 108.1, 107.0, 110.4, 112.9, 111.5, 114.2,
    113.0, 116.8, 118.4, 117.1, 120.3, 122.7, 121.0, 124.6, 126.2, 125.4, //
  ];

  /// Genera velas diarias con un paseo aleatorio.
  static List<Candle> candles(int n, {int seed = 5, double start = 100}) {
    final r = Random(seed);
    final out = <Candle>[];
    var price = start;
    var date = DateTime(2026, 1, 5);
    while (out.length < n) {
      if (date.weekday <= 5) {
        final open = price;
        final close = open + (r.nextDouble() - 0.47) * 6;
        final high = max(open, close) + r.nextDouble() * 3;
        final low = min(open, close) - r.nextDouble() * 3;
        out.add(Candle(date, open, high, low, close));
        price = close;
      }
      date = date.add(const Duration(days: 1));
    }
    return out;
  }

  static final btcPrice = () {
    final r = Random(21);
    var p = 61000.0;
    return List<double>.generate(30, (_) {
      p += (r.nextDouble() - 0.46) * 1800;
      return p;
    });
  }();

  /// Flujo de caja (cascada): valores positivos y negativos.
  static const cashFlow = [
    Category('Saldo inicial', 5000),
    Category('Ventas', 3200),
    Category('Servicios', -1200),
    Category('Nómina', -2100),
    Category('Impuestos', -800),
    Category('Inversión', 900),
  ];

  // ───────────────────────── Deportes ─────────────────────────
  /// (equipo, goles de local, goles de visitante)
  static const teamGoals = [
    ('Tigres', 18.0, 12.0),
    ('Águilas', 15.0, 14.0),
    ('Leones', 21.0, 9.0),
    ('Toros', 12.0, 10.0),
    ('Lobos', 17.0, 15.0),
    ('Halcones', 14.0, 11.0),
  ];

  /// Altura (cm) vs peso (kg) de 40 jugadores.
  static final playersHeightWeight = () {
    final r = Random(7);
    return List<Point2>.generate(40, (_) {
      final h = 168 + r.nextDouble() * 28;
      final w = 0.9 * (h - 100) + (r.nextDouble() - 0.5) * 12;
      return Point2(h, w);
    });
  }();

  /// (país, oro, plata, bronce)
  static const medals = [
    ('Brasil', 21.0, 14.0, 16.0),
    ('Colombia', 12.0, 15.0, 11.0),
    ('Argentina', 10.0, 9.0, 13.0),
    ('México', 8.0, 12.0, 14.0),
    ('Chile', 6.0, 7.0, 9.0),
  ];

  static const basketPoints = [
    Category('Ramírez', 28.4),
    Category('Torres', 25.1),
    Category('Gómez', 22.7),
    Category('Silva', 19.9),
    Category('Pardo', 17.3),
    Category('Mejía', 14.8),
  ];

  static const playerSkills = ['Velocidad', 'Tiro', 'Pase', 'Regate', 'Defensa', 'Físico'];
  static const playerA = [88.0, 76.0, 90.0, 84.0, 58.0, 72.0];
  static const playerB = [72.0, 90.0, 70.0, 68.0, 85.0, 88.0];

  // ───────────────────────── Salud / fitness ─────────────────────────
  static const macros = [
    Category('Carbohidratos', 50),
    Category('Proteínas', 22),
    Category('Grasas', 23),
    Category('Fibra', 5),
  ];
  static const dailySteps = [
    6200.0, 8400.0, 7300.0, 10100.0, 9500.0, 12400.0, 5600.0,
    7800.0, 9100.0, 8800.0, 11200.0, 10400.0, 13100.0, 6900.0, //
  ];
  static const restingHr = [
    72.0, 71.0, 70.0, 70.0, 68.0, 67.0, 67.0, 66.0, 65.0, 65.0, 64.0, 63.0, //
  ];
  static const activityRings = [
    Category('Mover', 82),
    Category('Ejercicio', 64),
    Category('Pararse', 91),
    Category('Pasos', 73),
  ];
  static const foodPyramid = [
    Category('Grasas y dulces', 5),
    Category('Lácteos', 15),
    Category('Proteínas', 20),
    Category('Frutas y verduras', 25),
    Category('Cereales', 35),
  ];

  // ───────────────────────── Educación ─────────────────────────
  static const subjectGrades = [
    Category('Matemáticas', 4.1),
    Category('Física', 3.7),
    Category('Química', 3.9),
    Category('Historia', 4.3),
    Category('Inglés', 4.5),
    Category('Programación', 4.7),
  ];
  static const studentsByMajor = [
    Category('Ingeniería', 420),
    Category('Medicina', 310),
    Category('Derecho', 280),
    Category('Diseño', 190),
    Category('Música', 90),
  ];

  /// Horas de estudio vs nota final de 30 estudiantes.
  static final studyHoursScore = () {
    final r = Random(3);
    return List<Point2>.generate(30, (_) {
      final h = 1 + r.nextDouble() * 14;
      final s = (2.2 + h * 0.17 + (r.nextDouble() - 0.5) * 0.9).clamp(1.0, 5.0);
      return Point2(h, s);
    });
  }();

  /// Distribución de notas por curso (valores absolutos).
  /// Orden de categorías: Excelente, Bueno, Regular, Deficiente.
  static const gradeBands = ['Excelente', 'Bueno', 'Regular', 'Deficiente'];
  static const gradesByCourse = {
    'Cálculo': [12.0, 30.0, 40.0, 18.0],
    'Física': [15.0, 35.0, 33.0, 17.0],
    'Inglés': [40.0, 38.0, 15.0, 7.0],
    'Historia': [28.0, 42.0, 22.0, 8.0],
    'Programación': [35.0, 40.0, 18.0, 7.0],
  };

  // ───────────────────────── Música / streaming ─────────────────────────
  static const genreShare = [
    Category('Pop', 32),
    Category('Reggaetón', 22),
    Category('Rock', 18),
    Category('Electrónica', 12),
    Category('Clásica', 6),
    Category('Otros', 10),
  ];
  static const listeningByDevice = [
    Category('Móvil', 540),
    Category('Computador', 310),
    Category('Parlante inteligente', 190),
    Category('TV', 120),
    Category('Auto', 260),
    Category('Consola', 70),
  ];

  // ───────────────────────── Videojuegos ─────────────────────────
  static const topGames = [
    Category('Battle Royale', 92),
    Category('MOBA', 78),
    Category('FPS', 71),
    Category('RPG', 64),
    Category('Deportes', 52),
    Category('Estrategia', 33),
  ];
  static const gameGenres = [
    Category('Acción', 34),
    Category('Aventura', 21),
    Category('Deportes', 16),
    Category('Puzzle', 12),
    Category('Simulación', 17),
  ];

  /// (juego, horas jugadas/semana, puntuación, jugadores en millones)
  static const gameBubbles = [
    Bubble('Arena', 9, 8.8, 14),
    Bubble('Quest', 14, 9.2, 8),
    Bubble('Rally', 5, 7.4, 6),
    Bubble('Tácticas', 11, 8.1, 3),
    Bubble('Pixel', 3, 6.9, 10),
    Bubble('Cosmos', 16, 9.0, 5),
    Bubble('Estadio', 7, 7.8, 12),
    Bubble('Puzzle', 4, 7.2, 4),
  ];

  // ───────────────────────── Transporte ─────────────────────────
  static const transportMode = [
    Category('Metro', 34),
    Category('Bus', 28),
    Category('Auto', 18),
    Category('Bicicleta', 12),
    Category('A pie', 8),
  ];

  /// Pasajeros (miles) por franja para tres líneas: [L1, L2, L3].
  static const passengersByHour = [
    ('6-8h', [42.0, 30.0, 18.0]),
    ('8-10h', [35.0, 26.0, 15.0]),
    ('12-14h', [24.0, 20.0, 12.0]),
    ('16-18h', [38.0, 29.0, 17.0]),
    ('18-20h', [46.0, 34.0, 20.0]),
  ];

  /// Velocidad (km/h) vs consumo (L/100km) de 30 vehículos.
  static final speedConsumption = () {
    final r = Random(9);
    return List<Point2>.generate(30, (_) {
      final v = 30 + r.nextDouble() * 100;
      final c = 4 + pow((v - 70) / 28, 2) + r.nextDouble() * 1.2;
      return Point2(v, c.toDouble());
    });
  }();

  /// Tráfico por día (7) × franja horaria (6): 0-100.
  static const heatDays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  static const heatSlots = ['6h', '9h', '12h', '15h', '18h', '21h'];
  static final trafficHeat = () {
    final r = Random(17);
    return List<List<double>>.generate(7, (d) {
      return List<double>.generate(6, (s) {
        final rush = (s == 0 || s == 4) ? 55.0 : (s == 1 ? 38.0 : 24.0);
        final weekend = d >= 5 ? 0.55 : 1.0;
        return (rush * weekend + r.nextDouble() * 35).clamp(5, 100).toDouble();
      });
    });
  }();

  // ───────────────────────── Energía ─────────────────────────
  static const hourlyEnergy = [
    1.2, 1.0, 0.9, 0.9, 1.0, 1.4, 2.2, 3.1, 2.6, 2.1, 2.0, 2.3,
    2.8, 2.5, 2.2, 2.1, 2.6, 3.4, 4.2, 4.6, 4.0, 3.2, 2.2, 1.5, //
  ];
  static const energyTariff = [
    0.10, 0.10, 0.10, 0.10, 0.10, 0.12, 0.18, 0.22, 0.22, 0.18, 0.16, 0.16,
    0.16, 0.16, 0.16, 0.18, 0.22, 0.28, 0.28, 0.28, 0.22, 0.16, 0.12, 0.10, //
  ];
  static const energySources = [
    Category('Hidroeléctrica', 30),
    Category('Solar', 22),
    Category('Gas', 20),
    Category('Eólica', 18),
    Category('Carbón', 10),
  ];

  /// Mezcla energética (GWh) por año: [Renovable, Fósil].
  static const energyMixYears = ['2020', '2021', '2022', '2023', '2024'];
  static const energyMixRenewable = [41.0, 47.0, 55.0, 63.0, 72.0];
  static const energyMixFossil = [59.0, 53.0, 45.0, 37.0, 28.0];

  /// Producción mensual por tipo: Solar, Eólica, Hidro.
  static const energyByType = {
    'Solar': [20.0, 24.0, 32.0, 40.0, 48.0, 52.0, 55.0, 53.0, 44.0, 34.0, 26.0, 21.0],
    'Eólica': [38.0, 36.0, 34.0, 30.0, 26.0, 24.0, 28.0, 33.0, 37.0, 40.0, 42.0, 41.0],
    'Hidro': [60.0, 58.0, 55.0, 62.0, 70.0, 74.0, 72.0, 68.0, 63.0, 66.0, 71.0, 65.0],
  };

  // ───────────────────────── Redes sociales ─────────────────────────
  static const followersWeekly = [
    1.2, 1.5, 1.9, 2.4, 2.8, 3.5, 4.1, 4.4, 5.2, 6.0, 6.9, 8.1, //
  ];
  static const dailyVisits = [
    320.0, 410.0, 380.0, 520.0, 610.0, 580.0, 450.0,
    480.0, 560.0, 700.0, 760.0, 690.0, 540.0, 620.0, //
  ];
  static const engagementDaily = [
    1200.0, 1850.0, 1500.0, 2300.0, 2900.0, 3400.0, 2100.0, //
  ];

  static final dailyFollowers = () {
    final r = Random(33);
    var f = 12000.0;
    final start = DateTime(2026, 8, 1);
    return List<TimeValue>.generate(30, (i) {
      f += 40 + r.nextDouble() * 160;
      return TimeValue(start.add(Duration(days: i)), f);
    });
  }();

  /// (formato, seguidores en miles, engagement %, publicaciones al mes)
  static const socialBubbles = [
    Bubble('Fotos', 85, 4.2, 30),
    Bubble('Video corto', 120, 7.8, 60),
    Bubble('Stories', 60, 5.1, 90),
    Bubble('Podcast', 25, 9.4, 8),
    Bubble('Blog', 40, 2.6, 12),
    Bubble('Directos', 70, 8.9, 10),
  ];

  /// Calidad del aire (AQI) por hora del día.
  static const airQuality = [
    38.0, 35.0, 33.0, 36.0, 48.0, 72.0, 98.0, 125.0, 110.0, 88.0, 70.0, 62.0,
    58.0, 60.0, 66.0, 78.0, 95.0, 118.0, 104.0, 82.0, 64.0, 52.0, 44.0, 40.0, //
  ];

  // ───────────────────────── Población / economía ─────────────────────────
  static const populationContinents = [
    Category('Asia', 4750),
    Category('África', 1460),
    Category('América', 1020),
    Category('Europa', 745),
    Category('Oceanía', 45),
  ];
  static const cityPopulation = [
    Point2(1990, 1.1), Point2(1995, 1.4), Point2(2000, 1.8), Point2(2005, 2.3),
    Point2(2010, 2.9), Point2(2015, 3.4), Point2(2020, 3.9), //
  ];

  /// (país, PIB per cápita en miles USD, esperanza de vida, población en millones)
  static const countryBubbles = [
    Bubble('Colombia', 6.5, 73.5, 52),
    Bubble('México', 11.5, 75.5, 129),
    Bubble('Brasil', 9.0, 77.5, 215),
    Bubble('Chile', 16.0, 80.5, 19),
    Bubble('Perú', 7.5, 71.5, 34),
    Bubble('Argentina', 13.5, 78.0, 46),
    Bubble('Uruguay', 18.5, 79.0, 3.5),
    Bubble('Ecuador', 5.0, 75.5, 18),
  ];
  static const ageMaxHr = [
    Point2(18, 202), Point2(22, 198), Point2(25, 195), Point2(30, 190),
    Point2(35, 185), Point2(40, 180), Point2(45, 175), Point2(50, 170),
    Point2(55, 165), Point2(60, 160), Point2(65, 155), Point2(70, 150), //
  ];
  static const familyBudget = [
    Category('Vivienda', 35),
    Category('Alimentación', 25),
    Category('Transporte', 15),
    Category('Educación', 12),
    Category('Ocio', 8),
    Category('Ahorro', 5),
  ];
}
