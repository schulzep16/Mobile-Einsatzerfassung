// lib/providers/app_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';
import '../models/kamerad.dart';
import '../models/fahrzeug.dart';
import '../models/einsatz.dart';

class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _feuerwehrName = '';
  String _standardEinsatzleiter = '';

  List<Kamerad> _kameraden = [];
  List<Fahrzeug> _fahrzeuge = [];
  List<Einsatz> _einsaetze = [];

  ThemeMode get themeMode => _themeMode;
  String get feuerwehrName => _feuerwehrName;
  String get standardEinsatzleiter => _standardEinsatzleiter;
  List<Kamerad> get kameraden => _kameraden;
  List<Kamerad> get aktiveKameraden => _kameraden;
  List<Fahrzeug> get fahrzeuge => _fahrzeuge;
  List<Fahrzeug> get aktiveFahrzeuge => _fahrzeuge;
  List<Einsatz> get einsaetze => _einsaetze;

  Future<void> init() async {
    await _loadSettings();
    await Future.wait([loadKameraden(), loadFahrzeuge(), loadEinsaetze()]);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('themeMode') ?? ThemeMode.system.index;
    _themeMode = ThemeMode.values[themeIndex];
    _feuerwehrName = prefs.getString('feuerwehrName') ?? '';
    _standardEinsatzleiter = prefs.getString('standardEinsatzleiter') ?? '';
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    notifyListeners();
  }

  Future<void> saveSettings({
    required String feuerwehrName,
    required String standardEinsatzleiter,
  }) async {
    _feuerwehrName = feuerwehrName;
    _standardEinsatzleiter = standardEinsatzleiter;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('feuerwehrName', feuerwehrName);
    await prefs.remove('standardOrt');
    await prefs.setString('standardEinsatzleiter', standardEinsatzleiter);
    notifyListeners();
  }

  // ─── KAMERADEN ──────────────────────────────────────────────────────────────

  Future<void> loadKameraden() async {
    _kameraden = await DatabaseHelper.instance.getAllKameraden();
    notifyListeners();
  }

  Future<void> addKamerad(Kamerad k) async {
    await DatabaseHelper.instance.insertKamerad(k);
    await loadKameraden();
  }

  Future<void> updateKamerad(Kamerad k) async {
    await DatabaseHelper.instance.updateKamerad(k);
    await loadKameraden();
  }

  Future<void> deleteKamerad(int id) async {
    await DatabaseHelper.instance.deleteKamerad(id);
    await loadKameraden();
  }

  // ─── FAHRZEUGE ──────────────────────────────────────────────────────────────

  Future<void> loadFahrzeuge() async {
    _fahrzeuge = await DatabaseHelper.instance.getAllFahrzeuge();
    notifyListeners();
  }

  Future<void> addFahrzeug(Fahrzeug f) async {
    await DatabaseHelper.instance.insertFahrzeug(f);
    await loadFahrzeuge();
  }

  Future<void> updateFahrzeug(Fahrzeug f) async {
    await DatabaseHelper.instance.updateFahrzeug(f);
    await loadFahrzeuge();
  }

  Future<void> deleteFahrzeug(int id) async {
    await DatabaseHelper.instance.deleteFahrzeug(id);
    await loadFahrzeuge();
  }

  // ─── EINSÄTZE ───────────────────────────────────────────────────────────────

  Future<void> loadEinsaetze() async {
    _einsaetze = await DatabaseHelper.instance.getAllEinsaetze();
    notifyListeners();
  }

  Future<int> addEinsatz(Einsatz e) async {
    final id = await DatabaseHelper.instance.insertEinsatz(e);
    await loadEinsaetze();
    return id;
  }

  Future<void> updateEinsatz(Einsatz e) async {
    await DatabaseHelper.instance.updateEinsatz(e);
    await loadEinsaetze();
  }

  Future<void> deleteEinsatz(int id) async {
    await DatabaseHelper.instance.deleteEinsatz(id);
    await loadEinsaetze();
  }

  Future<Einsatz?> getEinsatzDetail(int id) async {
    return DatabaseHelper.instance.getEinsatz(id);
  }

  Future<int> getNextLfdNummer() async {
    return DatabaseHelper.instance.getNextLfdNummer();
  }
}
