// lib/models/einsatz.dart

class EinsatzFahrzeug {
  final int? id;
  final int einsatzId;
  final int? fahrzeugId;
  final String kennung;
  final String wacheAb;
  final String estelleAn;
  final String estelleAb;
  final String wacheAn;
  final int staerke;
  final double km;
  final String einsatzZeit;
  final String nrEbOfw;

  EinsatzFahrzeug({
    this.id,
    required this.einsatzId,
    this.fahrzeugId,
    this.kennung = '',
    this.wacheAb = '',
    this.estelleAn = '',
    this.estelleAb = '',
    this.wacheAn = '',
    this.staerke = 0,
    this.km = 0,
    this.einsatzZeit = '',
    this.nrEbOfw = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'einsatz_id': einsatzId,
      'fahrzeug_id': fahrzeugId,
      'kennung': kennung,
      'wache_ab': wacheAb,
      'estelle_an': estelleAn,
      'estelle_ab': estelleAb,
      'wache_an': wacheAn,
      'staerke': staerke,
      'km': km,
      'einsatz_zeit': einsatzZeit,
      'nr_eb_ofw': nrEbOfw,
    };
  }

  factory EinsatzFahrzeug.fromMap(Map<String, dynamic> map) {
    return EinsatzFahrzeug(
      id: map['id'] as int?,
      einsatzId: map['einsatz_id'] as int? ?? 0,
      fahrzeugId: map['fahrzeug_id'] as int?,
      kennung: map['kennung'] as String? ?? '',
      wacheAb: map['wache_ab'] as String? ?? '',
      estelleAn: map['estelle_an'] as String? ?? '',
      estelleAb: map['estelle_ab'] as String? ?? '',
      wacheAn: map['wache_an'] as String? ?? '',
      staerke: map['staerke'] as int? ?? 0,
      km: (map['km'] as num?)?.toDouble() ?? 0.0,
      einsatzZeit: map['einsatz_zeit'] as String? ?? '',
      nrEbOfw: map['nr_eb_ofw'] as String? ?? '',
    );
  }

  EinsatzFahrzeug copyWith({
    int? id,
    int? einsatzId,
    int? fahrzeugId,
    String? kennung,
    String? wacheAb,
    String? estelleAn,
    String? estelleAb,
    String? wacheAn,
    int? staerke,
    double? km,
    String? einsatzZeit,
    String? nrEbOfw,
  }) {
    return EinsatzFahrzeug(
      id: id ?? this.id,
      einsatzId: einsatzId ?? this.einsatzId,
      fahrzeugId: fahrzeugId ?? this.fahrzeugId,
      kennung: kennung ?? this.kennung,
      wacheAb: wacheAb ?? this.wacheAb,
      estelleAn: estelleAn ?? this.estelleAn,
      estelleAb: estelleAb ?? this.estelleAb,
      wacheAn: wacheAn ?? this.wacheAn,
      staerke: staerke ?? this.staerke,
      km: km ?? this.km,
      einsatzZeit: einsatzZeit ?? this.einsatzZeit,
      nrEbOfw: nrEbOfw ?? this.nrEbOfw,
    );
  }
}

class EinsatzKamerad {
  final int? id;
  final int einsatzId;
  final int kameradId;
  final String fahrzeug;
  final String funktion;
  String? kameradName; // populated separately

  EinsatzKamerad({
    this.id,
    required this.einsatzId,
    required this.kameradId,
    this.fahrzeug = '',
    this.funktion = '',
    this.kameradName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'einsatz_id': einsatzId,
      'kamerad_id': kameradId,
      'fahrzeug': fahrzeug,
      'funktion': funktion,
    };
  }

  factory EinsatzKamerad.fromMap(Map<String, dynamic> map) {
    return EinsatzKamerad(
      id: map['id'] as int?,
      einsatzId: map['einsatz_id'] as int? ?? 0,
      kameradId: map['kamerad_id'] as int? ?? 0,
      fahrzeug: map['fahrzeug'] as String? ?? '',
      funktion: map['funktion'] as String? ?? '',
      kameradName: map['kamerad_name'] as String?,
    );
  }
}

class AtemschutzEintrag {
  final int? id;
  final int einsatzId;
  final String kameradName;
  final String paNummer;
  final int druckVor;
  final int druckNach;
  final int dauer;
  final String zustand;

  AtemschutzEintrag({
    this.id,
    required this.einsatzId,
    this.kameradName = '',
    this.paNummer = '',
    this.druckVor = 0,
    this.druckNach = 0,
    this.dauer = 0,
    this.zustand = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'einsatz_id': einsatzId,
      'kamerad_name': kameradName,
      'pa_nummer': paNummer,
      'druck_vor': druckVor,
      'druck_nach': druckNach,
      'dauer': dauer,
      'zustand': zustand,
    };
  }

  factory AtemschutzEintrag.fromMap(Map<String, dynamic> map) {
    return AtemschutzEintrag(
      id: map['id'] as int?,
      einsatzId: map['einsatz_id'] as int? ?? 0,
      kameradName: map['kamerad_name'] as String? ?? '',
      paNummer: map['pa_nummer'] as String? ?? '',
      druckVor: map['druck_vor'] as int? ?? 0,
      druckNach: map['druck_nach'] as int? ?? 0,
      dauer: map['dauer'] as int? ?? 0,
      zustand: map['zustand'] as String? ?? '',
    );
  }

  AtemschutzEintrag copyWith({
    int? id,
    int? einsatzId,
    String? kameradName,
    String? paNummer,
    int? druckVor,
    int? druckNach,
    int? dauer,
    String? zustand,
  }) {
    return AtemschutzEintrag(
      id: id ?? this.id,
      einsatzId: einsatzId ?? this.einsatzId,
      kameradName: kameradName ?? this.kameradName,
      paNummer: paNummer ?? this.paNummer,
      druckVor: druckVor ?? this.druckVor,
      druckNach: druckNach ?? this.druckNach,
      dauer: dauer ?? this.dauer,
      zustand: zustand ?? this.zustand,
    );
  }
}

class WeitereEinsatzmittel {
  final int? id;
  final int einsatzId;
  final String organisation;
  final String einheit;
  final int staerke;

  WeitereEinsatzmittel({
    this.id,
    required this.einsatzId,
    this.organisation = '',
    this.einheit = '',
    this.staerke = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'einsatz_id': einsatzId,
      'organisation': organisation,
      'einheit': einheit,
      'staerke': staerke,
    };
  }

  factory WeitereEinsatzmittel.fromMap(Map<String, dynamic> map) {
    return WeitereEinsatzmittel(
      id: map['id'] as int?,
      einsatzId: map['einsatz_id'] as int? ?? 0,
      organisation: map['organisation'] as String? ?? '',
      einheit: map['einheit'] as String? ?? '',
      staerke: map['staerke'] as int? ?? 0,
    );
  }

  WeitereEinsatzmittel copyWith({
    int? id,
    int? einsatzId,
    String? organisation,
    String? einheit,
    int? staerke,
  }) {
    return WeitereEinsatzmittel(
      id: id ?? this.id,
      einsatzId: einsatzId ?? this.einsatzId,
      organisation: organisation ?? this.organisation,
      einheit: einheit ?? this.einheit,
      staerke: staerke ?? this.staerke,
    );
  }
}

class Unfallbeteiligter {
  final int? id;
  final int einsatzId;
  final int position;
  final String name;
  final String strasse;
  final String plzWohnort;
  final String geburtsdatum;
  final String pkwTyp;
  final String kennzeichen;
  final String taetigkeitenAmFahrzeug;

  Unfallbeteiligter({
    this.id,
    required this.einsatzId,
    this.position = 1,
    this.name = '',
    this.strasse = '',
    this.plzWohnort = '',
    this.geburtsdatum = '',
    this.pkwTyp = '',
    this.kennzeichen = '',
    this.taetigkeitenAmFahrzeug = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'einsatz_id': einsatzId,
      'position': position,
      'name': name,
      'strasse': strasse,
      'plz_wohnort': plzWohnort,
      'geburtsdatum': geburtsdatum,
      'pkw_typ': pkwTyp,
      'kennzeichen': kennzeichen,
      'taetigkeiten_am_fahrzeug': taetigkeitenAmFahrzeug,
    };
  }

  factory Unfallbeteiligter.fromMap(Map<String, dynamic> map) {
    return Unfallbeteiligter(
      id: map['id'] as int?,
      einsatzId: map['einsatz_id'] as int? ?? 0,
      position: map['position'] as int? ?? 1,
      name: map['name'] as String? ?? '',
      strasse: map['strasse'] as String? ?? '',
      plzWohnort: map['plz_wohnort'] as String? ?? '',
      geburtsdatum: map['geburtsdatum'] as String? ?? '',
      pkwTyp: map['pkw_typ'] as String? ?? '',
      kennzeichen: map['kennzeichen'] as String? ?? '',
      taetigkeitenAmFahrzeug: map['taetigkeiten_am_fahrzeug'] as String? ?? '',
    );
  }
}

class Einsatz {
  final int? id;
  final String lfdNummer;
  final String einsatznummerLeitstelle;
  final String feuerwehrName;
  // Datum
  final String datum;
  final String wochentag;
  final String alarmzeit;
  final String einsatzBeginn;
  final String einsatzEnde;
  final int gesamteEinsatzzeitStunden;
  final int gesamteEinsatzzeitMinuten;
  // Einsatzort
  final String strasse;
  final String hausnummer;
  final String plz;
  final String ort;
  final String ortsteil;
  final double? gpsLat;
  final double? gpsLon;
  // Einsatzart
  final String einsatzart;
  final String stichwort;
  // Alarmierung
  final String meldeweg;
  final bool alarmLeitstelle;
  final bool alarmPolizei;
  final bool alarmMuendlich;
  // Personal
  final String einsatzleiter;
  final String einsatztagebuchPolizei;
  final String sonstigeAnwesende;
  // Einsatzdetails
  final String vorgefundeneLage;
  final String einsatzmassnahmen;
  final String einsatzverlauf;
  final int verletzte;
  final int gerettete;
  final int tote;
  final String objektTyp;
  final String flaeche;
  final String eigentuemerName;
  final String eigentuemerStrasse;
  final String eigentuemerPlzWohnort;
  final String eigentuemerGeburtsdatum;
  final String eigentuemerTaetigkeiten;
  final bool eigentuemerReanimation;
  // Material
  final String wasserentnahme;
  final String schaumBildner;
  final double schaumMenge;
  final double schaumLiterCa;
  final int loeschmittelAuswurfgeraetC;
  final int loeschmittelAuswurfgeraetB;
  final int atemschutzPa200;
  final int atemschutzPa300;
  final int atemschutzReserve;
  final int atemschutzReserveAufgabentraeger;
  final int atemschutzReserveFtz;
  final String oelbinderLandTyp;
  final double oelbinderLand;
  final bool oelbinderLandEntsorgungMit;
  final bool oelbinderLandEntsorgungOhne;
  final String oelbinderWasserTyp;
  final double oelbinderWasser;
  final bool oelbinderWasserEntsorgungMit;
  final bool oelbinderWasserEntsorgungOhne;
  final String oelbinderEntsorgung;
  final String handfeuerloecherTyp;
  final int handfeuerloecher;
  final bool handfeuerloecherEntsorgungMit;
  final bool handfeuerloecherEntsorgungOhne;
  final String besondereGeraete;
  // Nachbereitung
  final bool nachsorge;
  final String nachsorgeBeschreibung;
  final bool uebergabeprotokoll;
  final String einsatzstelleUebergebenAn;
  final String kostenersatzVorschlag;
  final String bemerkung;
  // Bericht
  final String ortBericht;
  final String datumBericht;
  final String unterschrift;
  final String createdAt;

  // Relations (populated separately)
  List<EinsatzFahrzeug> fahrzeuge;
  List<EinsatzKamerad> kameraden;
  List<AtemschutzEintrag> atemschutz;
  List<WeitereEinsatzmittel> weitereEinsatzmittel;
  List<Unfallbeteiligter> unfallbeteiligte;

  Einsatz({
    this.id,
    this.lfdNummer = '',
    this.einsatznummerLeitstelle = '',
    this.feuerwehrName = '',
    this.datum = '',
    this.wochentag = '',
    this.alarmzeit = '',
    this.einsatzBeginn = '',
    this.einsatzEnde = '',
    this.gesamteEinsatzzeitStunden = 0,
    this.gesamteEinsatzzeitMinuten = 0,
    this.strasse = '',
    this.hausnummer = '',
    this.plz = '',
    this.ort = '',
    this.ortsteil = '',
    this.gpsLat,
    this.gpsLon,
    this.einsatzart = '',
    this.stichwort = '',
    this.meldeweg = '',
    this.alarmLeitstelle = false,
    this.alarmPolizei = false,
    this.alarmMuendlich = false,
    this.einsatzleiter = '',
    this.einsatztagebuchPolizei = '',
    this.sonstigeAnwesende = '',
    this.vorgefundeneLage = '',
    this.einsatzmassnahmen = '',
    this.einsatzverlauf = '',
    this.verletzte = 0,
    this.gerettete = 0,
    this.tote = 0,
    this.objektTyp = '',
    this.flaeche = '',
    this.eigentuemerName = '',
    this.eigentuemerStrasse = '',
    this.eigentuemerPlzWohnort = '',
    this.eigentuemerGeburtsdatum = '',
    this.eigentuemerTaetigkeiten = '',
    this.eigentuemerReanimation = false,
    this.wasserentnahme = '',
    this.schaumBildner = '',
    this.schaumMenge = 0,
    this.schaumLiterCa = 0,
    this.loeschmittelAuswurfgeraetC = 0,
    this.loeschmittelAuswurfgeraetB = 0,
    this.atemschutzPa200 = 0,
    this.atemschutzPa300 = 0,
    this.atemschutzReserve = 0,
    this.atemschutzReserveAufgabentraeger = 0,
    this.atemschutzReserveFtz = 0,
    this.oelbinderLandTyp = '',
    this.oelbinderLand = 0,
    this.oelbinderLandEntsorgungMit = false,
    this.oelbinderLandEntsorgungOhne = false,
    this.oelbinderWasserTyp = '',
    this.oelbinderWasser = 0,
    this.oelbinderWasserEntsorgungMit = false,
    this.oelbinderWasserEntsorgungOhne = false,
    this.oelbinderEntsorgung = '',
    this.handfeuerloecherTyp = '',
    this.handfeuerloecher = 0,
    this.handfeuerloecherEntsorgungMit = false,
    this.handfeuerloecherEntsorgungOhne = false,
    this.besondereGeraete = '',
    this.nachsorge = false,
    this.nachsorgeBeschreibung = '',
    this.uebergabeprotokoll = false,
    this.einsatzstelleUebergebenAn = '',
    this.kostenersatzVorschlag = '',
    this.bemerkung = '',
    this.ortBericht = '',
    this.datumBericht = '',
    this.unterschrift = '',
    this.createdAt = '',
    this.fahrzeuge = const [],
    this.kameraden = const [],
    this.atemschutz = const [],
    this.weitereEinsatzmittel = const [],
    this.unfallbeteiligte = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lfd_nummer': lfdNummer,
      'einsatznummer_leitstelle': einsatznummerLeitstelle,
      'feuerwehr_name': feuerwehrName,
      'datum': datum,
      'wochentag': wochentag,
      'alarmzeit': alarmzeit,
      'einsatz_beginn': einsatzBeginn,
      'einsatz_ende': einsatzEnde,
      'gesamte_einsatzzeit_stunden': gesamteEinsatzzeitStunden,
      'gesamte_einsatzzeit_minuten': gesamteEinsatzzeitMinuten,
      'strasse': strasse,
      'hausnummer': hausnummer,
      'plz': plz,
      'ort': ort,
      'ortsteil': ortsteil,
      'gps_lat': gpsLat,
      'gps_lon': gpsLon,
      'einsatzart': einsatzart,
      'stichwort': stichwort,
      'meldeweg': meldeweg,
      'alarm_leitstelle': alarmLeitstelle ? 1 : 0,
      'alarm_polizei': alarmPolizei ? 1 : 0,
      'alarm_muendlich': alarmMuendlich ? 1 : 0,
      'einsatzleiter': einsatzleiter,
      'einsatztagebuch_polizei': einsatztagebuchPolizei,
      'sonstige_anwesende': sonstigeAnwesende,
      'vorgefundene_lage': vorgefundeneLage,
      'einsatzmassnahmen': einsatzmassnahmen,
      'einsatzverlauf': einsatzverlauf,
      'verletzte': verletzte,
      'gerettete': gerettete,
      'tote': tote,
      'objekt_typ': objektTyp,
      'flaeche': flaeche,
      'eigentuemer_name': eigentuemerName,
      'eigentuemer_strasse': eigentuemerStrasse,
      'eigentuemer_plz_wohnort': eigentuemerPlzWohnort,
      'eigentuemer_geburtsdatum': eigentuemerGeburtsdatum,
      'eigentuemer_taetigkeiten': eigentuemerTaetigkeiten,
      'eigentuemer_reanimation': eigentuemerReanimation ? 1 : 0,
      'wasserentnahme': wasserentnahme,
      'schaum_bildner': schaumBildner,
      'schaum_menge': schaumMenge,
      'schaum_liter_ca': schaumLiterCa,
      'loeschmittel_auswurfgeraet_c': loeschmittelAuswurfgeraetC,
      'loeschmittel_auswurfgeraet_b': loeschmittelAuswurfgeraetB,
      'atemschutz_pa200': atemschutzPa200,
      'atemschutz_pa300': atemschutzPa300,
      'atemschutz_reserve': atemschutzReserve,
      'atemschutz_reserve_aufgabentraeger': atemschutzReserveAufgabentraeger,
      'atemschutz_reserve_ftz': atemschutzReserveFtz,
      'oelbinder_land_typ': oelbinderLandTyp,
      'oelbinder_land': oelbinderLand,
      'oelbinder_land_entsorgung_mit': oelbinderLandEntsorgungMit ? 1 : 0,
      'oelbinder_land_entsorgung_ohne': oelbinderLandEntsorgungOhne ? 1 : 0,
      'oelbinder_wasser_typ': oelbinderWasserTyp,
      'oelbinder_wasser': oelbinderWasser,
      'oelbinder_wasser_entsorgung_mit': oelbinderWasserEntsorgungMit ? 1 : 0,
      'oelbinder_wasser_entsorgung_ohne': oelbinderWasserEntsorgungOhne ? 1 : 0,
      'oelbinder_entsorgung': oelbinderEntsorgung,
      'handfeuerloecher_typ': handfeuerloecherTyp,
      'handfeuerloecher': handfeuerloecher,
      'handfeuerloecher_entsorgung_mit': handfeuerloecherEntsorgungMit ? 1 : 0,
      'handfeuerloecher_entsorgung_ohne': handfeuerloecherEntsorgungOhne ? 1 : 0,
      'besondere_geraete': besondereGeraete,
      'nachsorge': nachsorge ? 1 : 0,
      'nachsorge_beschreibung': nachsorgeBeschreibung,
      'uebergabeprotokoll': uebergabeprotokoll ? 1 : 0,
      'einsatzstelle_uebergeben_an': einsatzstelleUebergebenAn,
      'kostenersatz_vorschlag': kostenersatzVorschlag,
      'bemerkung': bemerkung,
      'ort_bericht': ortBericht,
      'datum_bericht': datumBericht,
      'unterschrift': unterschrift,
      'created_at': createdAt,
    };
  }

  factory Einsatz.fromMap(Map<String, dynamic> map) {
    return Einsatz(
      id: map['id'] as int?,
      lfdNummer: map['lfd_nummer'] as String? ?? '',
      einsatznummerLeitstelle: map['einsatznummer_leitstelle'] as String? ?? '',
      feuerwehrName: map['feuerwehr_name'] as String? ?? '',
      datum: map['datum'] as String? ?? '',
      wochentag: map['wochentag'] as String? ?? '',
      alarmzeit: map['alarmzeit'] as String? ?? '',
      einsatzBeginn: map['einsatz_beginn'] as String? ?? '',
      einsatzEnde: map['einsatz_ende'] as String? ?? '',
        gesamteEinsatzzeitStunden:
          map['gesamte_einsatzzeit_stunden'] as int? ?? 0,
        gesamteEinsatzzeitMinuten:
          map['gesamte_einsatzzeit_minuten'] as int? ?? 0,
      strasse: map['strasse'] as String? ?? '',
      hausnummer: map['hausnummer'] as String? ?? '',
      plz: map['plz'] as String? ?? '',
      ort: map['ort'] as String? ?? '',
      ortsteil: map['ortsteil'] as String? ?? '',
      gpsLat: (map['gps_lat'] as num?)?.toDouble(),
      gpsLon: (map['gps_lon'] as num?)?.toDouble(),
      einsatzart: map['einsatzart'] as String? ?? '',
      stichwort: map['stichwort'] as String? ?? '',
      meldeweg: map['meldeweg'] as String? ?? '',
      alarmLeitstelle: (map['alarm_leitstelle'] as int? ?? 0) == 1,
      alarmPolizei: (map['alarm_polizei'] as int? ?? 0) == 1,
      alarmMuendlich: (map['alarm_muendlich'] as int? ?? 0) == 1,
      einsatzleiter: map['einsatzleiter'] as String? ?? '',
      einsatztagebuchPolizei: map['einsatztagebuch_polizei'] as String? ?? '',
      sonstigeAnwesende: map['sonstige_anwesende'] as String? ?? '',
      vorgefundeneLage: map['vorgefundene_lage'] as String? ?? '',
      einsatzmassnahmen: map['einsatzmassnahmen'] as String? ?? '',
      einsatzverlauf: map['einsatzverlauf'] as String? ?? '',
      verletzte: map['verletzte'] as int? ?? 0,
      gerettete: map['gerettete'] as int? ?? 0,
      tote: map['tote'] as int? ?? 0,
      objektTyp: map['objekt_typ'] as String? ?? '',
      flaeche: map['flaeche'] as String? ?? '',
        eigentuemerName: map['eigentuemer_name'] as String? ?? '',
        eigentuemerStrasse: map['eigentuemer_strasse'] as String? ?? '',
        eigentuemerPlzWohnort: map['eigentuemer_plz_wohnort'] as String? ?? '',
        eigentuemerGeburtsdatum: map['eigentuemer_geburtsdatum'] as String? ?? '',
        eigentuemerTaetigkeiten: map['eigentuemer_taetigkeiten'] as String? ?? '',
        eigentuemerReanimation:
          (map['eigentuemer_reanimation'] as int? ?? 0) == 1,
      wasserentnahme: map['wasserentnahme'] as String? ?? '',
      schaumBildner: map['schaum_bildner'] as String? ?? '',
      schaumMenge: (map['schaum_menge'] as num?)?.toDouble() ?? 0.0,
        schaumLiterCa: (map['schaum_liter_ca'] as num?)?.toDouble() ?? 0.0,
        loeschmittelAuswurfgeraetC:
          map['loeschmittel_auswurfgeraet_c'] as int? ?? 0,
        loeschmittelAuswurfgeraetB:
          map['loeschmittel_auswurfgeraet_b'] as int? ?? 0,
      atemschutzPa200: map['atemschutz_pa200'] as int? ?? 0,
      atemschutzPa300: map['atemschutz_pa300'] as int? ?? 0,
      atemschutzReserve: map['atemschutz_reserve'] as int? ?? 0,
        atemschutzReserveAufgabentraeger:
          map['atemschutz_reserve_aufgabentraeger'] as int? ?? 0,
        atemschutzReserveFtz: map['atemschutz_reserve_ftz'] as int? ?? 0,
        oelbinderLandTyp: map['oelbinder_land_typ'] as String? ?? '',
      oelbinderLand: (map['oelbinder_land'] as num?)?.toDouble() ?? 0.0,
        oelbinderLandEntsorgungMit:
          (map['oelbinder_land_entsorgung_mit'] as int? ?? 0) == 1,
        oelbinderLandEntsorgungOhne:
          (map['oelbinder_land_entsorgung_ohne'] as int? ?? 0) == 1,
        oelbinderWasserTyp: map['oelbinder_wasser_typ'] as String? ?? '',
      oelbinderWasser: (map['oelbinder_wasser'] as num?)?.toDouble() ?? 0.0,
        oelbinderWasserEntsorgungMit:
          (map['oelbinder_wasser_entsorgung_mit'] as int? ?? 0) == 1,
        oelbinderWasserEntsorgungOhne:
          (map['oelbinder_wasser_entsorgung_ohne'] as int? ?? 0) == 1,
      oelbinderEntsorgung: map['oelbinder_entsorgung'] as String? ?? '',
        handfeuerloecherTyp: map['handfeuerloecher_typ'] as String? ?? '',
      handfeuerloecher: map['handfeuerloecher'] as int? ?? 0,
        handfeuerloecherEntsorgungMit:
          (map['handfeuerloecher_entsorgung_mit'] as int? ?? 0) == 1,
        handfeuerloecherEntsorgungOhne:
          (map['handfeuerloecher_entsorgung_ohne'] as int? ?? 0) == 1,
      besondereGeraete: map['besondere_geraete'] as String? ?? '',
      nachsorge: (map['nachsorge'] as int? ?? 0) == 1,
      nachsorgeBeschreibung: map['nachsorge_beschreibung'] as String? ?? '',
      uebergabeprotokoll: (map['uebergabeprotokoll'] as int? ?? 0) == 1,
        einsatzstelleUebergebenAn:
          map['einsatzstelle_uebergeben_an'] as String? ?? '',
        kostenersatzVorschlag: map['kostenersatz_vorschlag'] as String? ?? '',
      bemerkung: map['bemerkung'] as String? ?? '',
      ortBericht: map['ort_bericht'] as String? ?? '',
      datumBericht: map['datum_bericht'] as String? ?? '',
      unterschrift: map['unterschrift'] as String? ?? '',
      createdAt: map['created_at'] as String? ?? '',
    );
  }

  Einsatz copyWith({
    int? id,
    String? lfdNummer,
    String? einsatznummerLeitstelle,
    String? feuerwehrName,
    String? datum,
    String? wochentag,
    String? alarmzeit,
    String? einsatzBeginn,
    String? einsatzEnde,
    int? gesamteEinsatzzeitStunden,
    int? gesamteEinsatzzeitMinuten,
    String? strasse,
    String? hausnummer,
    String? plz,
    String? ort,
    String? ortsteil,
    double? gpsLat,
    double? gpsLon,
    String? einsatzart,
    String? stichwort,
    String? meldeweg,
    bool? alarmLeitstelle,
    bool? alarmPolizei,
    bool? alarmMuendlich,
    String? einsatzleiter,
    String? einsatztagebuchPolizei,
    String? sonstigeAnwesende,
    String? vorgefundeneLage,
    String? einsatzmassnahmen,
    String? einsatzverlauf,
    int? verletzte,
    int? gerettete,
    int? tote,
    String? objektTyp,
    String? flaeche,
    String? eigentuemerName,
    String? eigentuemerStrasse,
    String? eigentuemerPlzWohnort,
    String? eigentuemerGeburtsdatum,
    String? eigentuemerTaetigkeiten,
    bool? eigentuemerReanimation,
    String? wasserentnahme,
    String? schaumBildner,
    double? schaumMenge,
    double? schaumLiterCa,
    int? loeschmittelAuswurfgeraetC,
    int? loeschmittelAuswurfgeraetB,
    int? atemschutzPa200,
    int? atemschutzPa300,
    int? atemschutzReserve,
    int? atemschutzReserveAufgabentraeger,
    int? atemschutzReserveFtz,
    String? oelbinderLandTyp,
    double? oelbinderLand,
    bool? oelbinderLandEntsorgungMit,
    bool? oelbinderLandEntsorgungOhne,
    String? oelbinderWasserTyp,
    double? oelbinderWasser,
    bool? oelbinderWasserEntsorgungMit,
    bool? oelbinderWasserEntsorgungOhne,
    String? oelbinderEntsorgung,
    String? handfeuerloecherTyp,
    int? handfeuerloecher,
    bool? handfeuerloecherEntsorgungMit,
    bool? handfeuerloecherEntsorgungOhne,
    String? besondereGeraete,
    bool? nachsorge,
    String? nachsorgeBeschreibung,
    bool? uebergabeprotokoll,
    String? einsatzstelleUebergebenAn,
    String? kostenersatzVorschlag,
    String? bemerkung,
    String? ortBericht,
    String? datumBericht,
    String? unterschrift,
    String? createdAt,
    List<EinsatzFahrzeug>? fahrzeuge,
    List<EinsatzKamerad>? kameraden,
    List<AtemschutzEintrag>? atemschutz,
    List<WeitereEinsatzmittel>? weitereEinsatzmittel,
    List<Unfallbeteiligter>? unfallbeteiligte,
  }) {
    return Einsatz(
      id: id ?? this.id,
      lfdNummer: lfdNummer ?? this.lfdNummer,
      einsatznummerLeitstelle: einsatznummerLeitstelle ?? this.einsatznummerLeitstelle,
      feuerwehrName: feuerwehrName ?? this.feuerwehrName,
      datum: datum ?? this.datum,
      wochentag: wochentag ?? this.wochentag,
      alarmzeit: alarmzeit ?? this.alarmzeit,
      einsatzBeginn: einsatzBeginn ?? this.einsatzBeginn,
      einsatzEnde: einsatzEnde ?? this.einsatzEnde,
        gesamteEinsatzzeitStunden:
          gesamteEinsatzzeitStunden ?? this.gesamteEinsatzzeitStunden,
        gesamteEinsatzzeitMinuten:
          gesamteEinsatzzeitMinuten ?? this.gesamteEinsatzzeitMinuten,
      strasse: strasse ?? this.strasse,
      hausnummer: hausnummer ?? this.hausnummer,
      plz: plz ?? this.plz,
      ort: ort ?? this.ort,
      ortsteil: ortsteil ?? this.ortsteil,
      gpsLat: gpsLat ?? this.gpsLat,
      gpsLon: gpsLon ?? this.gpsLon,
      einsatzart: einsatzart ?? this.einsatzart,
      stichwort: stichwort ?? this.stichwort,
      meldeweg: meldeweg ?? this.meldeweg,
      alarmLeitstelle: alarmLeitstelle ?? this.alarmLeitstelle,
      alarmPolizei: alarmPolizei ?? this.alarmPolizei,
      alarmMuendlich: alarmMuendlich ?? this.alarmMuendlich,
      einsatzleiter: einsatzleiter ?? this.einsatzleiter,
      einsatztagebuchPolizei: einsatztagebuchPolizei ?? this.einsatztagebuchPolizei,
      sonstigeAnwesende: sonstigeAnwesende ?? this.sonstigeAnwesende,
      vorgefundeneLage: vorgefundeneLage ?? this.vorgefundeneLage,
      einsatzmassnahmen: einsatzmassnahmen ?? this.einsatzmassnahmen,
      einsatzverlauf: einsatzverlauf ?? this.einsatzverlauf,
      verletzte: verletzte ?? this.verletzte,
      gerettete: gerettete ?? this.gerettete,
      tote: tote ?? this.tote,
      objektTyp: objektTyp ?? this.objektTyp,
      flaeche: flaeche ?? this.flaeche,
        eigentuemerName: eigentuemerName ?? this.eigentuemerName,
        eigentuemerStrasse: eigentuemerStrasse ?? this.eigentuemerStrasse,
        eigentuemerPlzWohnort:
          eigentuemerPlzWohnort ?? this.eigentuemerPlzWohnort,
        eigentuemerGeburtsdatum:
          eigentuemerGeburtsdatum ?? this.eigentuemerGeburtsdatum,
        eigentuemerTaetigkeiten:
          eigentuemerTaetigkeiten ?? this.eigentuemerTaetigkeiten,
        eigentuemerReanimation:
          eigentuemerReanimation ?? this.eigentuemerReanimation,
      wasserentnahme: wasserentnahme ?? this.wasserentnahme,
      schaumBildner: schaumBildner ?? this.schaumBildner,
      schaumMenge: schaumMenge ?? this.schaumMenge,
        schaumLiterCa: schaumLiterCa ?? this.schaumLiterCa,
        loeschmittelAuswurfgeraetC:
          loeschmittelAuswurfgeraetC ?? this.loeschmittelAuswurfgeraetC,
        loeschmittelAuswurfgeraetB:
          loeschmittelAuswurfgeraetB ?? this.loeschmittelAuswurfgeraetB,
      atemschutzPa200: atemschutzPa200 ?? this.atemschutzPa200,
      atemschutzPa300: atemschutzPa300 ?? this.atemschutzPa300,
      atemschutzReserve: atemschutzReserve ?? this.atemschutzReserve,
        atemschutzReserveAufgabentraeger:
          atemschutzReserveAufgabentraeger ??
            this.atemschutzReserveAufgabentraeger,
        atemschutzReserveFtz: atemschutzReserveFtz ?? this.atemschutzReserveFtz,
        oelbinderLandTyp: oelbinderLandTyp ?? this.oelbinderLandTyp,
      oelbinderLand: oelbinderLand ?? this.oelbinderLand,
        oelbinderLandEntsorgungMit:
          oelbinderLandEntsorgungMit ?? this.oelbinderLandEntsorgungMit,
        oelbinderLandEntsorgungOhne:
          oelbinderLandEntsorgungOhne ?? this.oelbinderLandEntsorgungOhne,
        oelbinderWasserTyp: oelbinderWasserTyp ?? this.oelbinderWasserTyp,
      oelbinderWasser: oelbinderWasser ?? this.oelbinderWasser,
        oelbinderWasserEntsorgungMit:
          oelbinderWasserEntsorgungMit ?? this.oelbinderWasserEntsorgungMit,
        oelbinderWasserEntsorgungOhne:
          oelbinderWasserEntsorgungOhne ?? this.oelbinderWasserEntsorgungOhne,
      oelbinderEntsorgung: oelbinderEntsorgung ?? this.oelbinderEntsorgung,
        handfeuerloecherTyp: handfeuerloecherTyp ?? this.handfeuerloecherTyp,
      handfeuerloecher: handfeuerloecher ?? this.handfeuerloecher,
        handfeuerloecherEntsorgungMit:
          handfeuerloecherEntsorgungMit ?? this.handfeuerloecherEntsorgungMit,
        handfeuerloecherEntsorgungOhne:
          handfeuerloecherEntsorgungOhne ?? this.handfeuerloecherEntsorgungOhne,
      besondereGeraete: besondereGeraete ?? this.besondereGeraete,
      nachsorge: nachsorge ?? this.nachsorge,
      nachsorgeBeschreibung: nachsorgeBeschreibung ?? this.nachsorgeBeschreibung,
      uebergabeprotokoll: uebergabeprotokoll ?? this.uebergabeprotokoll,
        einsatzstelleUebergebenAn:
          einsatzstelleUebergebenAn ?? this.einsatzstelleUebergebenAn,
        kostenersatzVorschlag:
          kostenersatzVorschlag ?? this.kostenersatzVorschlag,
      bemerkung: bemerkung ?? this.bemerkung,
      ortBericht: ortBericht ?? this.ortBericht,
      datumBericht: datumBericht ?? this.datumBericht,
      unterschrift: unterschrift ?? this.unterschrift,
      createdAt: createdAt ?? this.createdAt,
      fahrzeuge: fahrzeuge ?? this.fahrzeuge,
      kameraden: kameraden ?? this.kameraden,
      atemschutz: atemschutz ?? this.atemschutz,
      weitereEinsatzmittel: weitereEinsatzmittel ?? this.weitereEinsatzmittel,
      unfallbeteiligte: unfallbeteiligte ?? this.unfallbeteiligte,
    );
  }
}
