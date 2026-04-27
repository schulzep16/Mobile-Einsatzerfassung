// lib/models/kamerad.dart
class Kamerad {
  final int? id;
  final String vorname;
  final String nachname;
  final List<String> ausbildungen; // populated separately

  Kamerad({
    this.id,
    required this.vorname,
    required this.nachname,
    this.ausbildungen = const [],
  });

  String get vollname => '$vorname $nachname'.trim();
  String get kurzname => '$vorname $nachname';

  Map<String, dynamic> toMap() {
    return {'id': id, 'vorname': vorname, 'nachname': nachname};
  }

  factory Kamerad.fromMap(Map<String, dynamic> map) {
    return Kamerad(
      id: map['id'] as int?,
      vorname: map['vorname'] as String? ?? '',
      nachname: map['nachname'] as String? ?? '',
    );
  }

  Kamerad copyWith({
    int? id,
    String? vorname,
    String? nachname,
    List<String>? ausbildungen,
  }) {
    return Kamerad(
      id: id ?? this.id,
      vorname: vorname ?? this.vorname,
      nachname: nachname ?? this.nachname,
      ausbildungen: ausbildungen ?? this.ausbildungen,
    );
  }
}
