import 'seasons.dart';

class LiturgicalSeasonInfo {
  const LiturgicalSeasonInfo({
    required this.id,
    required this.it,
    required this.en,
  });

  final String id;
  final String it;
  final String en;

  String label(String languageCode) => languageCode == 'en' ? en : it;
}

class LiturgicalDay {
  const LiturgicalDay({
    required this.date,
    required this.titleIt,
    required this.titleEn,
    required this.seasonId,
    this.readings,
    this.verified = true,
    this.source,
    this.sourceUrl,
  });

  final DateTime date;
  final String titleIt;
  final String titleEn;
  final String seasonId;
  final Map<String, dynamic>? readings;
  final bool verified;
  final String? source;
  final String? sourceUrl;

  String title(String languageCode) =>
      languageCode == 'en' ? titleEn : titleIt;

  LiturgicalSeason get season {
    switch (seasonId) {
      case 'avvento':
        return LiturgicalSeason.avvento;
      case 'natale':
        return LiturgicalSeason.natale;
      case 'quaresima':
        return LiturgicalSeason.quaresima;
      case 'pasqua':
        return LiturgicalSeason.pasqua;
      default:
        return LiturgicalSeason.tempoOrdinario;
    }
  }

  bool get isSunday => date.weekday == DateTime.sunday;

  bool get hasReadings =>
      readings != null &&
      ((readings!['firstReading'] as String?)?.isNotEmpty == true ||
          (readings!['gospel'] as String?)?.isNotEmpty == true);

  factory LiturgicalDay.fromJson(Map<String, dynamic> json) {
    final parsed = DateTime.tryParse(json['date'] as String? ?? '');
    return LiturgicalDay(
      date: parsed ?? DateTime.now(),
      titleIt: json['titleIt'] as String? ?? 'Giorno',
      titleEn: json['titleEn'] as String? ?? 'Day',
      seasonId: json['seasonId'] as String? ?? 'tempo-ordinario',
      readings: json['readings'] is Map<String, dynamic>
          ? json['readings'] as Map<String, dynamic>
          : null,
      verified: json['verified'] as bool? ?? false,
      source: json['source'] as String?,
      sourceUrl: json['sourceUrl'] as String?,
    );
  }
}
