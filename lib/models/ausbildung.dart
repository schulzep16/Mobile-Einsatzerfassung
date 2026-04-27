// lib/models/ausbildung.dart
class Ausbildung {
  final int? id;
  final String name;
  final String beschreibung;
  final bool pflichtausbildung;

  Ausbildung({
    this.id,
    required this.name,
    this.beschreibung = '',
    this.pflichtausbildung = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'beschreibung': beschreibung,
      'pflichtausbildung': pflichtausbildung ? 1 : 0,
    };
  }

  factory Ausbildung.fromMap(Map<String, dynamic> map) {
    return Ausbildung(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      beschreibung: map['beschreibung'] as String? ?? '',
      pflichtausbildung: (map['pflichtausbildung'] as int? ?? 0) == 1,
    );
  }

  Ausbildung copyWith({
    int? id,
    String? name,
    String? beschreibung,
    bool? pflichtausbildung,
  }) {
    return Ausbildung(
      id: id ?? this.id,
      name: name ?? this.name,
      beschreibung: beschreibung ?? this.beschreibung,
      pflichtausbildung: pflichtausbildung ?? this.pflichtausbildung,
    );
  }
}

class KameradAusbildung {
  final int? id;
  final int kameradId;
  final int ausbildungId;
  final String datum;
  final String ablaufdatum;
  String? ausbildungName; // populated separately

  KameradAusbildung({
    this.id,
    required this.kameradId,
    required this.ausbildungId,
    this.datum = '',
    this.ablaufdatum = '',
    this.ausbildungName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kamerad_id': kameradId,
      'ausbildung_id': ausbildungId,
      'datum': datum,
      'ablaufdatum': ablaufdatum,
    };
  }

  factory KameradAusbildung.fromMap(Map<String, dynamic> map) {
    return KameradAusbildung(
      id: map['id'] as int?,
      kameradId: map['kamerad_id'] as int? ?? 0,
      ausbildungId: map['ausbildung_id'] as int? ?? 0,
      datum: map['datum'] as String? ?? '',
      ablaufdatum: map['ablaufdatum'] as String? ?? '',
      ausbildungName: map['ausbildung_name'] as String?,
    );
  }
}
