// lib/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/kamerad.dart';
import '../models/fahrzeug.dart';
import '../models/einsatz.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('einsatzberichte.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 5,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE kameraden (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vorname TEXT NOT NULL,
        nachname TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE fahrzeuge (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kennung TEXT NOT NULL,
        bezeichnung TEXT DEFAULT '',
        kennzeichen TEXT DEFAULT ''
      )
    ''');

    await db.execute('''
      CREATE TABLE einsaetze (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lfd_nummer TEXT DEFAULT '',
        einsatznummer_leitstelle TEXT DEFAULT '',
        feuerwehr_name TEXT DEFAULT '',
        datum TEXT DEFAULT '',
        wochentag TEXT DEFAULT '',
        alarmzeit TEXT DEFAULT '',
        einsatz_beginn TEXT DEFAULT '',
        einsatz_ende TEXT DEFAULT '',
        gesamte_einsatzzeit_stunden INTEGER DEFAULT 0,
        gesamte_einsatzzeit_minuten INTEGER DEFAULT 0,
        strasse TEXT DEFAULT '',
        hausnummer TEXT DEFAULT '',
        plz TEXT DEFAULT '',
        ort TEXT DEFAULT '',
        ortsteil TEXT DEFAULT '',
        gps_lat REAL,
        gps_lon REAL,
        einsatzart TEXT DEFAULT '',
        stichwort TEXT DEFAULT '',
        meldeweg TEXT DEFAULT '',
        alarm_leitstelle INTEGER DEFAULT 0,
        alarm_polizei INTEGER DEFAULT 0,
        alarm_muendlich INTEGER DEFAULT 0,
        einsatzleiter TEXT DEFAULT '',
        einsatztagebuch_polizei TEXT DEFAULT '',
        sonstige_anwesende TEXT DEFAULT '',
        vorgefundene_lage TEXT DEFAULT '',
        einsatzmassnahmen TEXT DEFAULT '',
        einsatzverlauf TEXT DEFAULT '',
        verletzte INTEGER DEFAULT 0,
        gerettete INTEGER DEFAULT 0,
        tote INTEGER DEFAULT 0,
        objekt_typ TEXT DEFAULT '',
        flaeche TEXT DEFAULT '',
        eigentuemer_name TEXT DEFAULT '',
        eigentuemer_strasse TEXT DEFAULT '',
        eigentuemer_plz_wohnort TEXT DEFAULT '',
        eigentuemer_geburtsdatum TEXT DEFAULT '',
        eigentuemer_taetigkeiten TEXT DEFAULT '',
        eigentuemer_reanimation INTEGER DEFAULT 0,
        wasserentnahme TEXT DEFAULT '',
        schaum_bildner TEXT DEFAULT '',
        schaum_menge REAL DEFAULT 0,
        schaum_liter_ca REAL DEFAULT 0,
        loeschmittel_auswurfgeraet_c INTEGER DEFAULT 0,
        loeschmittel_auswurfgeraet_b INTEGER DEFAULT 0,
        atemschutz_pa200 INTEGER DEFAULT 0,
        atemschutz_pa300 INTEGER DEFAULT 0,
        atemschutz_reserve INTEGER DEFAULT 0,
        atemschutz_reserve_aufgabentraeger INTEGER DEFAULT 0,
        atemschutz_reserve_ftz INTEGER DEFAULT 0,
        oelbinder_land_typ TEXT DEFAULT '',
        oelbinder_land REAL DEFAULT 0,
        oelbinder_land_entsorgung_mit INTEGER DEFAULT 0,
        oelbinder_land_entsorgung_ohne INTEGER DEFAULT 0,
        oelbinder_wasser_typ TEXT DEFAULT '',
        oelbinder_wasser REAL DEFAULT 0,
        oelbinder_wasser_entsorgung_mit INTEGER DEFAULT 0,
        oelbinder_wasser_entsorgung_ohne INTEGER DEFAULT 0,
        oelbinder_entsorgung TEXT DEFAULT '',
        handfeuerloecher_typ TEXT DEFAULT '',
        handfeuerloecher INTEGER DEFAULT 0,
        handfeuerloecher_entsorgung_mit INTEGER DEFAULT 0,
        handfeuerloecher_entsorgung_ohne INTEGER DEFAULT 0,
        besondere_geraete TEXT DEFAULT '',
        nachsorge INTEGER DEFAULT 0,
        nachsorge_beschreibung TEXT DEFAULT '',
        uebergabeprotokoll INTEGER DEFAULT 0,
        einsatzstelle_uebergeben_an TEXT DEFAULT '',
        kostenersatz_vorschlag TEXT DEFAULT '',
        bemerkung TEXT DEFAULT '',
        ort_bericht TEXT DEFAULT '',
        datum_bericht TEXT DEFAULT '',
        unterschrift TEXT DEFAULT '',
        created_at TEXT DEFAULT ''
      )
    ''');

    await db.execute('''
      CREATE TABLE einsatz_fahrzeuge (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        einsatz_id INTEGER NOT NULL,
        fahrzeug_id INTEGER,
        kennung TEXT DEFAULT '',
        wache_ab TEXT DEFAULT '',
        estelle_an TEXT DEFAULT '',
        estelle_ab TEXT DEFAULT '',
        wache_an TEXT DEFAULT '',
        staerke INTEGER DEFAULT 0,
        km REAL DEFAULT 0,
        einsatz_zeit TEXT DEFAULT '',
        nr_eb_ofw TEXT DEFAULT '',
        FOREIGN KEY (einsatz_id) REFERENCES einsaetze(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE einsatz_kameraden (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        einsatz_id INTEGER NOT NULL,
        kamerad_id INTEGER NOT NULL,
        fahrzeug TEXT DEFAULT '',
        funktion TEXT DEFAULT '',
        FOREIGN KEY (einsatz_id) REFERENCES einsaetze(id) ON DELETE CASCADE,
        FOREIGN KEY (kamerad_id) REFERENCES kameraden(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE atemschutz_ueberwachung (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        einsatz_id INTEGER NOT NULL,
        kamerad_name TEXT DEFAULT '',
        pa_nummer TEXT DEFAULT '',
        druck_vor INTEGER DEFAULT 0,
        druck_nach INTEGER DEFAULT 0,
        dauer INTEGER DEFAULT 0,
        zustand TEXT DEFAULT '',
        FOREIGN KEY (einsatz_id) REFERENCES einsaetze(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE weitere_einsatzmittel (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        einsatz_id INTEGER NOT NULL,
        organisation TEXT DEFAULT '',
        einheit TEXT DEFAULT '',
        staerke INTEGER DEFAULT 0,
        FOREIGN KEY (einsatz_id) REFERENCES einsaetze(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE einsatz_unfallbeteiligte (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        einsatz_id INTEGER NOT NULL,
        position INTEGER DEFAULT 1,
        name TEXT DEFAULT '',
        strasse TEXT DEFAULT '',
        plz_wohnort TEXT DEFAULT '',
        geburtsdatum TEXT DEFAULT '',
        pkw_typ TEXT DEFAULT '',
        kennzeichen TEXT DEFAULT '',
        taetigkeiten_am_fahrzeug TEXT DEFAULT '',
        FOREIGN KEY (einsatz_id) REFERENCES einsaetze(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN einsatznummer_leitstelle TEXT DEFAULT ''",
      );
    }
    if (oldVersion < 3) {
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN schaum_liter_ca REAL DEFAULT 0",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN loeschmittel_auswurfgeraet_c INTEGER DEFAULT 0",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN loeschmittel_auswurfgeraet_b INTEGER DEFAULT 0",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN atemschutz_reserve_aufgabentraeger INTEGER DEFAULT 0",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN atemschutz_reserve_ftz INTEGER DEFAULT 0",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN oelbinder_land_typ TEXT DEFAULT ''",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN oelbinder_land_entsorgung_mit INTEGER DEFAULT 0",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN oelbinder_land_entsorgung_ohne INTEGER DEFAULT 0",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN oelbinder_wasser_typ TEXT DEFAULT ''",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN oelbinder_wasser_entsorgung_mit INTEGER DEFAULT 0",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN oelbinder_wasser_entsorgung_ohne INTEGER DEFAULT 0",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN handfeuerloecher_typ TEXT DEFAULT ''",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN handfeuerloecher_entsorgung_mit INTEGER DEFAULT 0",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN handfeuerloecher_entsorgung_ohne INTEGER DEFAULT 0",
      );
    }
    if (oldVersion < 4) {
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN eigentuemer_name TEXT DEFAULT ''",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN eigentuemer_strasse TEXT DEFAULT ''",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN eigentuemer_plz_wohnort TEXT DEFAULT ''",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN eigentuemer_geburtsdatum TEXT DEFAULT ''",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN eigentuemer_taetigkeiten TEXT DEFAULT ''",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN eigentuemer_reanimation INTEGER DEFAULT 0",
      );
      await db.execute('''
        CREATE TABLE IF NOT EXISTS einsatz_unfallbeteiligte (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          einsatz_id INTEGER NOT NULL,
          position INTEGER DEFAULT 1,
          name TEXT DEFAULT '',
          strasse TEXT DEFAULT '',
          plz_wohnort TEXT DEFAULT '',
          geburtsdatum TEXT DEFAULT '',
          pkw_typ TEXT DEFAULT '',
          kennzeichen TEXT DEFAULT '',
          taetigkeiten_am_fahrzeug TEXT DEFAULT '',
          FOREIGN KEY (einsatz_id) REFERENCES einsaetze(id) ON DELETE CASCADE
        )
      ''');
    }
    if (oldVersion < 5) {
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN gesamte_einsatzzeit_stunden INTEGER DEFAULT 0",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN gesamte_einsatzzeit_minuten INTEGER DEFAULT 0",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN einsatzstelle_uebergeben_an TEXT DEFAULT ''",
      );
      await db.execute(
        "ALTER TABLE einsaetze ADD COLUMN kostenersatz_vorschlag TEXT DEFAULT ''",
      );
    }
  }

  // ─── KAMERADEN ───────────────────────────────────────────────────────────────

  Future<int> insertKamerad(Kamerad k) async {
    final db = await database;
    return db.insert('kameraden', k.toMap()..remove('id'));
  }

  Future<int> updateKamerad(Kamerad k) async {
    final db = await database;
    return db.update(
      'kameraden',
      k.toMap(),
      where: 'id = ?',
      whereArgs: [k.id],
    );
  }

  Future<int> deleteKamerad(int id) async {
    final db = await database;
    return db.delete('kameraden', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Kamerad>> getAllKameraden({bool nurAktive = false}) async {
    final db = await database;
    final maps = await db.rawQuery(
      'SELECT * FROM kameraden ORDER BY nachname, vorname',
    );
    return maps.map(Kamerad.fromMap).toList();
  }

  Future<Kamerad?> getKamerad(int id) async {
    final db = await database;
    final maps = await db.query('kameraden', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Kamerad.fromMap(maps.first);
  }

  // ─── FAHRZEUGE ────────────────────────────────────────────────────────────────

  Future<int> insertFahrzeug(Fahrzeug f) async {
    final db = await database;
    return db.insert('fahrzeuge', f.toMap()..remove('id'));
  }

  Future<int> updateFahrzeug(Fahrzeug f) async {
    final db = await database;
    return db.update(
      'fahrzeuge',
      f.toMap(),
      where: 'id = ?',
      whereArgs: [f.id],
    );
  }

  Future<int> deleteFahrzeug(int id) async {
    final db = await database;
    return db.delete('fahrzeuge', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Fahrzeug>> getAllFahrzeuge({bool nurAktive = false}) async {
    final db = await database;
    final maps = await db.rawQuery('SELECT * FROM fahrzeuge ORDER BY kennung');
    return maps.map(Fahrzeug.fromMap).toList();
  }

  // ─── EINSÄTZE ─────────────────────────────────────────────────────────────────

  Future<int> insertEinsatz(Einsatz e) async {
    final db = await database;
    return db.transaction((txn) async {
      final map = e.toMap()..remove('id');
      final id = await txn.insert('einsaetze', map);

      for (final fz in e.fahrzeuge) {
        final fzMap = fz.toMap()..remove('id');
        fzMap['einsatz_id'] = id;
        await txn.insert('einsatz_fahrzeuge', fzMap);
      }
      for (final km in e.kameraden) {
        final kmMap = km.toMap()..remove('id');
        kmMap['einsatz_id'] = id;
        await txn.insert('einsatz_kameraden', kmMap);
      }
      for (final as_ in e.atemschutz) {
        final asMap = as_.toMap()..remove('id');
        asMap['einsatz_id'] = id;
        await txn.insert('atemschutz_ueberwachung', asMap);
      }
      for (final we in e.weitereEinsatzmittel) {
        final weMap = we.toMap()..remove('id');
        weMap['einsatz_id'] = id;
        await txn.insert('weitere_einsatzmittel', weMap);
      }
      for (final ub in e.unfallbeteiligte) {
        final ubMap = ub.toMap()..remove('id');
        ubMap['einsatz_id'] = id;
        await txn.insert('einsatz_unfallbeteiligte', ubMap);
      }
      return id;
    });
  }

  Future<int> updateEinsatz(Einsatz e) async {
    final db = await database;
    return db.transaction((txn) async {
      await txn.update(
        'einsaetze',
        e.toMap(),
        where: 'id = ?',
        whereArgs: [e.id],
      );

      await txn.delete(
        'einsatz_fahrzeuge',
        where: 'einsatz_id = ?',
        whereArgs: [e.id],
      );
      await txn.delete(
        'einsatz_kameraden',
        where: 'einsatz_id = ?',
        whereArgs: [e.id],
      );
      await txn.delete(
        'atemschutz_ueberwachung',
        where: 'einsatz_id = ?',
        whereArgs: [e.id],
      );
      await txn.delete(
        'weitere_einsatzmittel',
        where: 'einsatz_id = ?',
        whereArgs: [e.id],
      );
      await txn.delete(
        'einsatz_unfallbeteiligte',
        where: 'einsatz_id = ?',
        whereArgs: [e.id],
      );

      for (final fz in e.fahrzeuge) {
        final fzMap = fz.toMap()..remove('id');
        fzMap['einsatz_id'] = e.id;
        await txn.insert('einsatz_fahrzeuge', fzMap);
      }
      for (final km in e.kameraden) {
        final kmMap = km.toMap()..remove('id');
        kmMap['einsatz_id'] = e.id;
        await txn.insert('einsatz_kameraden', kmMap);
      }
      for (final as_ in e.atemschutz) {
        final asMap = as_.toMap()..remove('id');
        asMap['einsatz_id'] = e.id;
        await txn.insert('atemschutz_ueberwachung', asMap);
      }
      for (final we in e.weitereEinsatzmittel) {
        final weMap = we.toMap()..remove('id');
        weMap['einsatz_id'] = e.id;
        await txn.insert('weitere_einsatzmittel', weMap);
      }
      for (final ub in e.unfallbeteiligte) {
        final ubMap = ub.toMap()..remove('id');
        ubMap['einsatz_id'] = e.id;
        await txn.insert('einsatz_unfallbeteiligte', ubMap);
      }
      return e.id ?? 0;
    });
  }

  Future<int> deleteEinsatz(int id) async {
    final db = await database;
    return db.delete('einsaetze', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Einsatz>> getAllEinsaetze() async {
    final db = await database;
    final maps = await db.query(
      'einsaetze',
      orderBy: 'datum DESC, alarmzeit DESC',
    );
    return maps.map(Einsatz.fromMap).toList();
  }

  Future<Einsatz?> getEinsatz(int id) async {
    final db = await database;
    final maps = await db.query('einsaetze', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    final einsatz = Einsatz.fromMap(maps.first);

    final fzMaps = await db.query(
      'einsatz_fahrzeuge',
      where: 'einsatz_id = ?',
      whereArgs: [id],
    );
    final kmMaps = await db.rawQuery(
      '''
      SELECT ek.*, k.vorname || ' ' || k.nachname as kamerad_name
      FROM einsatz_kameraden ek
      JOIN kameraden k ON ek.kamerad_id = k.id
      WHERE ek.einsatz_id = ?
    ''',
      [id],
    );
    final asMaps = await db.query(
      'atemschutz_ueberwachung',
      where: 'einsatz_id = ?',
      whereArgs: [id],
    );
    final weMaps = await db.query(
      'weitere_einsatzmittel',
      where: 'einsatz_id = ?',
      whereArgs: [id],
    );
    final ubMaps = await db.query(
      'einsatz_unfallbeteiligte',
      where: 'einsatz_id = ?',
      whereArgs: [id],
      orderBy: 'position ASC',
    );

    einsatz.fahrzeuge = fzMaps.map(EinsatzFahrzeug.fromMap).toList();
    einsatz.kameraden = kmMaps.map(EinsatzKamerad.fromMap).toList();
    einsatz.atemschutz = asMaps.map(AtemschutzEintrag.fromMap).toList();
    einsatz.weitereEinsatzmittel = weMaps
        .map(WeitereEinsatzmittel.fromMap)
        .toList();
    einsatz.unfallbeteiligte = ubMaps.map(Unfallbeteiligter.fromMap).toList();

    return einsatz;
  }

  Future<int> getNextLfdNummer() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM einsaetze');
    return (result.first['count'] as int? ?? 0) + 1;
  }
}
