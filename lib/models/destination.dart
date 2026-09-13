class Destination {
  final String name;
  final String officialName;
  final String region;
  final String subregion;
  final String capital;
  final String flagUrl;
  final String flagEmoji;
  final int population;
  final List<String> languages;
  final List<String> currencies;

  Destination({
    required this.name,
    required this.officialName,
    required this.region,
    required this.subregion,
    required this.capital,
    required this.flagUrl,
    required this.flagEmoji,
    required this.population,
    required this.languages,
    required this.currencies,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      name: json['names']?['common'] ?? 'Unknown',
      officialName: json['names']?['official'] ?? 'Unknown',
      region: json['region'] ?? 'Unknown',
      subregion: json['subregion'] ?? '',
      capital: (json['capitals'] != null && (json['capitals'] as List).isNotEmpty)
          ? json['capitals'][0]['name'] ?? 'N/A'
          : 'N/A',
      flagUrl: json['flag']?['url_png'] ?? '',
      flagEmoji: json['flag']?['emoji'] ?? '🏳️',
      population: json['population'] ?? 0,
      languages: (json['languages'] != null)
          ? (json['languages'] as List).map((l) => l['name']?.toString() ?? '').where((s) => s.isNotEmpty).toList()
          : [],
      currencies: (json['currencies'] != null)
          ? (json['currencies'] as List).map((c) => '${c['name']} (${c['symbol'] ?? c['code']})').toList()
          : [],
    );
  }
}