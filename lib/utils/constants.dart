// lib/utils/constants.dart
class AppConstants {
  // Einsatzarten
  static const List<String> einsatzarten = [
    'Brandeinsatz',
    'Technische Hilfeleistung',
    'Böswilliger Alarm',
    'Sonstiges',
  ];

  // Stichworte nach Einsatzart
  static const Map<String, List<String>> stichworte = {
    'Brandeinsatz': [
      'B:Klein',
      'B:Pkw',
      'B:Lkw',
      'B:Schornstein',
      'B:Gebäude klein',
      'B:Gebäude groß',
      'B:Sonderobjekt',
      'B:BMA',
      'B:Fläche',
      'B:Wald',
      'B:Wald groß',
      'B:Wald groß im WSP',
      'B:Boot',
      'B:Schiff',
      'B:Gefahrgut',
      'B:Kleinflugzeug',
      'B:Großflugzeug',
      'B:Explosion',
      'B:Schiene',
    ],
    'Technische Hilfeleistung': [
      'H:klein',
      'H:Natur',
      'H:Hilfeleistung',
      'H:Türnotöffnung',
      'H:VU ohne P',
      'H:VU mit P',
      'H:VU Klemm',
      'H:VU LKW/Bus',
      'H:VU Schiene',
      'H:VU Schiff',
      'H:Flugzeugunfall klein',
      'H:Flugzeugunfall groß',
      'H:Person auf Schiene',
      'H:Person im Wasser/Eis',
      'H:Rettung aus Höhen und Tiefen',
      'H:Gas',
      'H:Gefahrgut klein',
      'H:Gefahrgut groß',
      'H:Einsturz',
      'H:Öl Land',
      'H:Öl auf Wasser',
      'H:Tier in Not',
      'H:Kommunal',
      'H:Person-TMR',
    ],
    'Böswilliger Alarm': [
      'Böswilliger Alarm',
    ],
    'Sonstiges': [
      'S309: Heimrauchmelder',
      'First Responder',
    ],
  };

  // Meldewege
  static const List<String> meldewege = [
    'Leitstelle',
    'Notruf 112',
    'Polizei 110',
    'Mündlich',
    'Telefon',
    'Funk',
    'Sirene',
    'DME (Pager)',
    'App',
  ];

  // Dienstgrade
  static const List<String> dienstgrade = [
    'Feuerwehranwärter/in',
    'Feuerwehrmann/-frau',
    'Oberfeuerwehrmann/-frau',
    'Hauptfeuerwehrmann/-frau',
    'Löschmeister/in',
    'Oberlöschmeister/in',
    'Hauptlöschmeister/in',
    'Brandmeister/in',
    'Oberbrandmeister/in',
    'Hauptbrandmeister/in',
    'Brandinspektor/in',
    'Oberbrandinspektor/in',
    'Brandamtmann/-frau',
    'Brandamtsrat/-rätin',
    'Brandrat/-rätin',
    'Oberbrandrat/-rätin',
    'Branddirektor/in',
    'Leitender Branddirektor/in',
  ];

  // Objekt-Typen
  static const List<String> objektTypen = [
    'Einfamilienhaus',
    'Mehrfamilienhaus',
    'Gewerbe',
    'Industrie',
    'Garage/Carport',
    'Wald',
    'Feld/Wiese',
    'Fahrzeug',
    'Straße/Weg',
    'Sonstiges',
  ];

  // Flächengrößen
  static const List<String> flaechenGroessen = [
    '< 0,01 ha',
    '0,01 - 0,99 ha',
    '1 - 9,99 ha',
    '10 - 99,99 ha',
    '≥ 100 ha',
  ];

  // Wasserentnahmen
  static const List<String> wasserentnahmen = [
    'Öffentliches Netz / Hydrant',
    'Unterflurhydrant',
    'Überflurhydrant',
    'Offene Entnahme (Gewässer)',
    'Löschwasserbrunnen',
    'Löschwasserteich',
    'Zisterne',
    'Tankfahrzeug',
    'Keine',
  ];

  // Atemschutz-Zustände
  static const List<String> atemschutzZustaende = [
    'Gut',
    'Erschöpft',
    'Verletzt',
    'Sonstiges',
  ];

  // Weitere Organisationen
  static const List<String> weitereOrganisationen = [
    'Polizei',
    'Rettungsdienst',
    'Notarzt',
    'THW',
    'DRK',
    'DLRG',
    'Bergwacht',
    'Rettungshubschrauber',
    'Energieversorger',
    'Sonstiges',
  ];

  // Wochentage
  static const List<String> wochentage = [
    'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag',
    'Freitag', 'Samstag', 'Sonntag',
  ];
}
