// lib/models/fahrzeug.dart
class Fahrzeug {
  final int? id;
  final String kennung;
  final String bezeichnung;
  final String kennzeichen;

  Fahrzeug({
    this.id,
    required this.kennung,
    this.bezeichnung = '',
    this.kennzeichen = '',
  });

  String get anzeigename => kennung.isNotEmpty
      ? '$kennung${bezeichnung.isNotEmpty ? ' - $bezeichnung' : ''}'
      : bezeichnung;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kennung': kennung,
      'bezeichnung': bezeichnung,
      'kennzeichen': kennzeichen,
    };
  }

  factory Fahrzeug.fromMap(Map<String, dynamic> map) {
    return Fahrzeug(
      id: map['id'] as int?,
      kennung: map['kennung'] as String? ?? '',
      bezeichnung: map['bezeichnung'] as String? ?? '',
      kennzeichen: map['kennzeichen'] as String? ?? '',
    );
  }

  Fahrzeug copyWith({
    int? id,
    String? kennung,
    String? bezeichnung,
    String? kennzeichen,
  }) {
    return Fahrzeug(
      id: id ?? this.id,
      kennung: kennung ?? this.kennung,
      bezeichnung: bezeichnung ?? this.bezeichnung,
      kennzeichen: kennzeichen ?? this.kennzeichen,
    );
  }
}
