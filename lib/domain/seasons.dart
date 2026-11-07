/// Liturgical seasons of the Roman rite, derived from the date.
enum LiturgicalSeason { avvento, natale, quaresima, pasqua, tempoOrdinario }

LiturgicalSeason seasonFor(DateTime date) {
  final d = DateTime(date.year, date.month, date.day);
  final easter = _easterDate(d.year);
  final ashWednesday = easter.subtract(const Duration(days: 46));
  final pentecost = easter.add(const Duration(days: 49));

  // Advent: first Sunday on or after 27 November -> 24 December.
  DateTime adventStart(int year) {
    for (var day = 27; day <= 30; day++) {
      final candidate = DateTime(year, 11, day);
      if (candidate.weekday == DateTime.sunday) return candidate;
    }
    return DateTime(year, 12, 3);
  }

  final advent = adventStart(d.year);

  if (d.month == 12 && d.day >= 25) return LiturgicalSeason.natale;
  if (d.month == 1 && d.day <= 12) return LiturgicalSeason.natale;
  if (!d.isBefore(advent) && !d.isAfter(DateTime(d.year, 12, 24))) {
    return LiturgicalSeason.avvento;
  }
  if (!d.isBefore(ashWednesday) && d.isBefore(easter)) {
    return LiturgicalSeason.quaresima;
  }
  if (!d.isBefore(easter) && !d.isAfter(pentecost)) {
    return LiturgicalSeason.pasqua;
  }
  return LiturgicalSeason.tempoOrdinario;
}

/// Anonymous Gregorian algorithm for Easter Sunday.
DateTime _easterDate(int year) {
  final a = year % 19;
  final b = year ~/ 100;
  final c = year % 100;
  final d = b ~/ 4;
  final e = b % 4;
  final f = (b + 8) ~/ 25;
  final g = (b - f + 1) ~/ 3;
  final h = (19 * a + b - d - g + 15) % 30;
  final i = c ~/ 4;
  final k = c % 4;
  final l = (32 + 2 * e + 2 * i - h - k) % 7;
  final m = (a + 11 * h + 22 * l) ~/ 451;
  final month = (h + l - 7 * m + 114) ~/ 31;
  final day = ((h + l - 7 * m + 114) % 31) + 1;
  return DateTime(year, month, day);
}

extension LiturgicalSeasonLabels on LiturgicalSeason {
  String label(String languageCode) => switch (this) {
        LiturgicalSeason.avvento =>
          languageCode == 'en' ? 'Advent' : 'Avvento',
        LiturgicalSeason.natale =>
          languageCode == 'en' ? 'Christmas' : 'Natale',
        LiturgicalSeason.quaresima =>
          languageCode == 'en' ? 'Lent' : 'Quaresima',
        LiturgicalSeason.pasqua =>
          languageCode == 'en' ? 'Easter' : 'Pasqua',
        LiturgicalSeason.tempoOrdinario =>
          languageCode == 'en' ? 'Ordinary Time' : 'Tempo ordinario',
      };
}
