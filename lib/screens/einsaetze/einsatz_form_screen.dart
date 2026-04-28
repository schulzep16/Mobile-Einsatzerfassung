// lib/screens/einsaetze/einsatz_form_screen.dart
// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import '../../providers/app_provider.dart';
import '../../models/einsatz.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_text_field.dart';
import 'einsatz_detail_screen.dart';

class EinsatzFormScreen extends StatefulWidget {
  final Einsatz? einsatz;

  const EinsatzFormScreen({super.key, this.einsatz});

  @override
  State<EinsatzFormScreen> createState() => _EinsatzFormScreenState();
}

class _EinsatzFormScreenState extends State<EinsatzFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  bool _saving = false;
  bool get isEdit => widget.einsatz != null;

  // ─── Grunddaten ───
  late TextEditingController _lfdNummerCtrl;
  late TextEditingController _einsatznummerLeitstelleCtrl;
  late TextEditingController _feuerwehrCtrl;
  late TextEditingController _datumCtrl;
  late TextEditingController _wochentagCtrl;
  late TextEditingController _alarmzeitCtrl;
  late TextEditingController _einsatzBeginnCtrl;
  late TextEditingController _einsatzEndeCtrl;
  late TextEditingController _gesamteZeitStundenCtrl;
  late TextEditingController _gesamteZeitMinutenCtrl;

  // ─── Einsatzort ───
  late TextEditingController _strasseCtrl;
  late TextEditingController _hausnummerCtrl;
  late TextEditingController _plzCtrl;
  late TextEditingController _ortCtrl;
  late TextEditingController _ortsteilCtrl;

  // ─── Einsatzart ───
  String _einsatzart = '';
  String _stichwort = '';
  String _meldeweg = '';
  bool _alarmLeitstelle = false;
  bool _alarmPolizei = false;
  bool _alarmMuendlich = false;

  // ─── Einsatzleiter ───
  late TextEditingController _einsatzleiterCtrl;
  late TextEditingController _einsatztagebuchCtrl;
  late TextEditingController _sonstigeCtrl;

  // ─── Kräfte & Mittel ───
  List<EinsatzFahrzeug> _fahrzeuge = [];
  List<EinsatzKamerad> _kameraden = [];
  List<WeitereEinsatzmittel> _weitereEM = [];

  // ─── Einsatzdetails ───
  late TextEditingController _lageCtrl;
  late TextEditingController _massnahmenCtrl;
  late TextEditingController _verlaufCtrl;
  int _verletzte = 0;
  int _gerettete = 0;
  int _tote = 0;
  String _objektTyp = '';
  String _flaeche = '';
  late TextEditingController _eigentuemerNameCtrl;
  late TextEditingController _eigentuemerStrasseCtrl;
  late TextEditingController _eigentuemerPlzWohnortCtrl;
  late TextEditingController _eigentuemerGeburtsdatumCtrl;
  late TextEditingController _eigentuemerTaetigkeitenCtrl;
  bool _eigentuemerReanimation = false;
  late List<TextEditingController> _ubNameCtrls;
  late List<TextEditingController> _ubStrasseCtrls;
  late List<TextEditingController> _ubPlzWohnortCtrls;
  late List<TextEditingController> _ubGeburtsdatumCtrls;
  late List<TextEditingController> _ubPkwTypCtrls;
  late List<TextEditingController> _ubKennzeichenCtrls;
  late List<TextEditingController> _ubTaetigkeitenCtrls;

  // ─── Material ───
  String _wasserentnahme = '';
  late TextEditingController _schaumBildnerCtrl;
  late TextEditingController _schaumMengeCtrl;
  late TextEditingController _schaumLiterCaCtrl;
  int _loeschmittelAuswurfgeraetC = 0;
  int _loeschmittelAuswurfgeraetB = 0;
  int _atemschutzPa200 = 0;
  int _atemschutzPa300 = 0;
  int _atemschutzReserveAufgabentraeger = 0;
  int _atemschutzReserveFtz = 0;
  late TextEditingController _oelbinderLandTypCtrl;
  late TextEditingController _oelbinderLandCtrl;
  bool _oelbinderLandEntsorgungMit = false;
  bool _oelbinderLandEntsorgungOhne = false;
  late TextEditingController _oelbinderWasserTypCtrl;
  late TextEditingController _oelbinderWasserCtrl;
  bool _oelbinderWasserEntsorgungMit = false;
  bool _oelbinderWasserEntsorgungOhne = false;
  late TextEditingController _handfeuerloecherTypCtrl;
  int _handfeuerloecher = 0;
  bool _handfeuerloecherEntsorgungMit = false;
  bool _handfeuerloecherEntsorgungOhne = false;
  late TextEditingController _besondereGeraeteCtrl;
  List<AtemschutzEintrag> _atemschutzEintraege = [];

  // ─── Nachbereitung ───
  bool _nachsorge = false;
  late TextEditingController _nachsorgeCtrl;
  bool _uebergabeprotokoll = false;
  late TextEditingController _einsatzstelleUebergebenAnCtrl;
  String _kostenersatzVorschlag = '';
  late TextEditingController _bemerkungCtrl;
  late TextEditingController _ortBerichtCtrl;
  late TextEditingController _datumBerichtCtrl;
  String _unterschriftBase64 = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    final e = widget.einsatz;
    final provider = context.read<AppProvider>();

    _lfdNummerCtrl = TextEditingController(text: e?.lfdNummer ?? '');
    _einsatznummerLeitstelleCtrl = TextEditingController(
      text: e?.einsatznummerLeitstelle ?? '',
    );
    _feuerwehrCtrl = TextEditingController(
      text: e?.feuerwehrName ?? provider.feuerwehrName,
    );
    _datumCtrl = TextEditingController(text: e?.datum ?? _today());
    _wochentagCtrl = TextEditingController(
      text: e?.wochentag ?? _todayWochentag(),
    );
    _alarmzeitCtrl = TextEditingController(text: e?.alarmzeit ?? '');
    _einsatzBeginnCtrl = TextEditingController(text: e?.einsatzBeginn ?? '');
    _einsatzEndeCtrl = TextEditingController(text: e?.einsatzEnde ?? '');
    _einsatzBeginnCtrl.addListener(_berechnGesamtzeit);
    _einsatzEndeCtrl.addListener(_berechnGesamtzeit);
    _gesamteZeitStundenCtrl = TextEditingController(
      text: (e?.gesamteEinsatzzeitStunden ?? 0) == 0
          ? ''
          : '${e!.gesamteEinsatzzeitStunden}',
    );
    _gesamteZeitMinutenCtrl = TextEditingController(
      text: (e?.gesamteEinsatzzeitMinuten ?? 0) == 0
          ? ''
          : '${e!.gesamteEinsatzzeitMinuten}',
    );

    _strasseCtrl = TextEditingController(text: e?.strasse ?? '');
    _hausnummerCtrl = TextEditingController(text: e?.hausnummer ?? '');
    _plzCtrl = TextEditingController(text: e?.plz ?? '');
    _ortCtrl = TextEditingController(text: e?.ort ?? '');
    _ortsteilCtrl = TextEditingController(text: e?.ortsteil ?? '');

    _einsatzart = e?.einsatzart ?? '';
    _stichwort = e?.stichwort ?? '';
    if (!AppConstants.einsatzarten.contains(_einsatzart)) {
      _einsatzart = '';
    }
    final stichworteZurArt = AppConstants.stichworte[_einsatzart] ?? const [];
    if (!stichworteZurArt.contains(_stichwort)) {
      _stichwort = '';
    }
    _meldeweg = e?.meldeweg ?? '';
    _alarmLeitstelle = e?.alarmLeitstelle ?? false;
    _alarmPolizei = e?.alarmPolizei ?? false;
    _alarmMuendlich = e?.alarmMuendlich ?? false;

    _einsatzleiterCtrl = TextEditingController(
      text: e?.einsatzleiter ?? provider.standardEinsatzleiter,
    );
    _einsatztagebuchCtrl = TextEditingController(
      text: e?.einsatztagebuchPolizei ?? '',
    );
    _sonstigeCtrl = TextEditingController(text: e?.sonstigeAnwesende ?? '');

    _fahrzeuge = List.from(e?.fahrzeuge ?? []);
    _kameraden = List.from(e?.kameraden ?? []);
    _weitereEM = List.from(e?.weitereEinsatzmittel ?? []);

    _lageCtrl = TextEditingController(text: e?.vorgefundeneLage ?? '');
    _massnahmenCtrl = TextEditingController(text: e?.einsatzmassnahmen ?? '');
    _verlaufCtrl = TextEditingController(text: e?.einsatzverlauf ?? '');
    _verletzte = e?.verletzte ?? 0;
    _gerettete = e?.gerettete ?? 0;
    _tote = e?.tote ?? 0;
    _objektTyp = e?.objektTyp ?? '';
    _flaeche = e?.flaeche ?? '';
    _eigentuemerNameCtrl = TextEditingController(
      text: e?.eigentuemerName ?? '',
    );
    _eigentuemerStrasseCtrl = TextEditingController(
      text: e?.eigentuemerStrasse ?? '',
    );
    _eigentuemerPlzWohnortCtrl = TextEditingController(
      text: e?.eigentuemerPlzWohnort ?? '',
    );
    _eigentuemerGeburtsdatumCtrl = TextEditingController(
      text: e?.eigentuemerGeburtsdatum ?? '',
    );
    _eigentuemerTaetigkeitenCtrl = TextEditingController(
      text: e?.eigentuemerTaetigkeiten ?? '',
    );
    _eigentuemerReanimation = e?.eigentuemerReanimation ?? false;
    _initUnfallbeteiligteControllers(e?.unfallbeteiligte ?? const []);

    _wasserentnahme = e?.wasserentnahme ?? '';
    _schaumBildnerCtrl = TextEditingController(text: e?.schaumBildner ?? '');
    _schaumMengeCtrl = TextEditingController(
      text: (e?.schaumMenge ?? 0) == 0 ? '' : e!.schaumMenge.toString(),
    );
    _schaumLiterCaCtrl = TextEditingController(
      text: (e?.schaumLiterCa ?? 0) == 0 ? '' : e!.schaumLiterCa.toString(),
    );
    _loeschmittelAuswurfgeraetC = e?.loeschmittelAuswurfgeraetC ?? 0;
    _loeschmittelAuswurfgeraetB = e?.loeschmittelAuswurfgeraetB ?? 0;
    _atemschutzPa200 = e?.atemschutzPa200 ?? 0;
    _atemschutzPa300 = e?.atemschutzPa300 ?? 0;
    _atemschutzReserveAufgabentraeger =
        e?.atemschutzReserveAufgabentraeger ?? 0;
    if (_atemschutzReserveAufgabentraeger == 0 && (e?.atemschutzReserve ?? 0) > 0) {
      _atemschutzReserveAufgabentraeger = e!.atemschutzReserve;
    }
    _atemschutzReserveFtz = e?.atemschutzReserveFtz ?? 0;
    _oelbinderLandTypCtrl = TextEditingController(
      text: e?.oelbinderLandTyp ?? '',
    );
    _oelbinderLandCtrl = TextEditingController(
      text: (e?.oelbinderLand ?? 0) == 0 ? '' : e!.oelbinderLand.toString(),
    );
    _oelbinderLandEntsorgungMit = e?.oelbinderLandEntsorgungMit ?? false;
    _oelbinderLandEntsorgungOhne = e?.oelbinderLandEntsorgungOhne ?? false;
    _oelbinderWasserTypCtrl = TextEditingController(
      text: e?.oelbinderWasserTyp ?? '',
    );
    _oelbinderWasserCtrl = TextEditingController(
      text: (e?.oelbinderWasser ?? 0) == 0 ? '' : e!.oelbinderWasser.toString(),
    );
    _oelbinderWasserEntsorgungMit = e?.oelbinderWasserEntsorgungMit ?? false;
    _oelbinderWasserEntsorgungOhne = e?.oelbinderWasserEntsorgungOhne ?? false;
    _handfeuerloecherTypCtrl = TextEditingController(
      text: e?.handfeuerloecherTyp ?? '',
    );
    _handfeuerloecher = e?.handfeuerloecher ?? 0;
    _handfeuerloecherEntsorgungMit =
        e?.handfeuerloecherEntsorgungMit ?? false;
    _handfeuerloecherEntsorgungOhne =
        e?.handfeuerloecherEntsorgungOhne ?? false;
    _besondereGeraeteCtrl = TextEditingController(
      text: e?.besondereGeraete ?? '',
    );
    _atemschutzEintraege = List.from(e?.atemschutz ?? []);

    _nachsorge = e?.nachsorge ?? false;
    _nachsorgeCtrl = TextEditingController(
      text: e?.nachsorgeBeschreibung ?? '',
    );
    _uebergabeprotokoll = e?.uebergabeprotokoll ?? false;
    _einsatzstelleUebergebenAnCtrl = TextEditingController(
      text: e?.einsatzstelleUebergebenAn ?? '',
    );
    _kostenersatzVorschlag = e?.kostenersatzVorschlag ?? '';
    _bemerkungCtrl = TextEditingController(text: e?.bemerkung ?? '');
    _ortBerichtCtrl = TextEditingController(text: e?.ortBericht ?? '');
    _datumBerichtCtrl = TextEditingController(
      text: e?.datumBericht ?? _today(),
    );
    _unterschriftBase64 = e?.unterschrift ?? '';

    if (e == null) {
      _setLfdNummer();
    }
  }

  Future<void> _setLfdNummer() async {
    final n = await context.read<AppProvider>().getNextLfdNummer();
    if (mounted) setState(() => _lfdNummerCtrl.text = '$n');
  }

  String _today() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}';
  }

  String _todayWochentag() {
    final w = DateTime.now().weekday;
    return AppConstants.wochentage[w - 1];
  }

  void _initUnfallbeteiligteControllers(List<Unfallbeteiligter> source) {
    final byPosition = <int, Unfallbeteiligter>{
      for (final ub in source) ub.position: ub,
    };
    _ubNameCtrls = List.generate(
      3,
      (i) => TextEditingController(text: byPosition[i + 1]?.name ?? ''),
    );
    _ubStrasseCtrls = List.generate(
      3,
      (i) => TextEditingController(text: byPosition[i + 1]?.strasse ?? ''),
    );
    _ubPlzWohnortCtrls = List.generate(
      3,
      (i) => TextEditingController(text: byPosition[i + 1]?.plzWohnort ?? ''),
    );
    _ubGeburtsdatumCtrls = List.generate(
      3,
      (i) => TextEditingController(text: byPosition[i + 1]?.geburtsdatum ?? ''),
    );
    _ubPkwTypCtrls = List.generate(
      3,
      (i) => TextEditingController(text: byPosition[i + 1]?.pkwTyp ?? ''),
    );
    _ubKennzeichenCtrls = List.generate(
      3,
      (i) => TextEditingController(text: byPosition[i + 1]?.kennzeichen ?? ''),
    );
    _ubTaetigkeitenCtrls = List.generate(
      3,
      (i) => TextEditingController(
        text: byPosition[i + 1]?.taetigkeitenAmFahrzeug ?? '',
      ),
    );
  }

  List<Unfallbeteiligter> _buildUnfallbeteiligte() {
    return List.generate(
      3,
      (i) => Unfallbeteiligter(
        einsatzId: widget.einsatz?.id ?? 0,
        position: i + 1,
        name: _ubNameCtrls[i].text.trim(),
        strasse: _ubStrasseCtrls[i].text.trim(),
        plzWohnort: _ubPlzWohnortCtrls[i].text.trim(),
        geburtsdatum: _ubGeburtsdatumCtrls[i].text.trim(),
        pkwTyp: _ubPkwTypCtrls[i].text.trim(),
        kennzeichen: _ubKennzeichenCtrls[i].text.trim(),
        taetigkeitenAmFahrzeug: _ubTaetigkeitenCtrls[i].text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final c in [
      _lfdNummerCtrl,
      _einsatznummerLeitstelleCtrl,
      _feuerwehrCtrl,
      _datumCtrl,
      _wochentagCtrl,
      _alarmzeitCtrl,
      _einsatzBeginnCtrl,
      _einsatzEndeCtrl,
      _gesamteZeitStundenCtrl,
      _gesamteZeitMinutenCtrl,
      _strasseCtrl,
      _hausnummerCtrl,
      _plzCtrl,
      _ortCtrl,
      _ortsteilCtrl,
      _einsatzleiterCtrl,
      _einsatztagebuchCtrl,
      _sonstigeCtrl,
      _lageCtrl,
      _massnahmenCtrl,
      _verlaufCtrl,
      _eigentuemerNameCtrl,
      _eigentuemerStrasseCtrl,
      _eigentuemerPlzWohnortCtrl,
      _eigentuemerGeburtsdatumCtrl,
      _eigentuemerTaetigkeitenCtrl,
      ..._ubNameCtrls,
      ..._ubStrasseCtrls,
      ..._ubPlzWohnortCtrls,
      ..._ubGeburtsdatumCtrls,
      ..._ubPkwTypCtrls,
      ..._ubKennzeichenCtrls,
      ..._ubTaetigkeitenCtrls,
      _schaumBildnerCtrl,
      _schaumMengeCtrl,
      _schaumLiterCaCtrl,
      _oelbinderLandTypCtrl,
      _oelbinderLandCtrl,
      _oelbinderWasserTypCtrl,
      _oelbinderWasserCtrl,
      _handfeuerloecherTypCtrl,
      _besondereGeraeteCtrl,
      _nachsorgeCtrl,
      _einsatzstelleUebergebenAnCtrl,
      _bemerkungCtrl,
      _ortBerichtCtrl,
      _datumBerichtCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Einsatz _buildEinsatz() {
    final entsorgungsHinweise = <String>[];
    if (_oelbinderLandEntsorgungMit) entsorgungsHinweise.add('Ölbinder Land: mit');
    if (_oelbinderLandEntsorgungOhne) entsorgungsHinweise.add('Ölbinder Land: ohne');
    if (_oelbinderWasserEntsorgungMit) {
      entsorgungsHinweise.add('Ölbinder Wasser: mit');
    }
    if (_oelbinderWasserEntsorgungOhne) {
      entsorgungsHinweise.add('Ölbinder Wasser: ohne');
    }
    if (_handfeuerloecherEntsorgungMit) {
      entsorgungsHinweise.add('Handfeuerlöscher: mit');
    }
    if (_handfeuerloecherEntsorgungOhne) {
      entsorgungsHinweise.add('Handfeuerlöscher: ohne');
    }

    return Einsatz(
      id: widget.einsatz?.id,
      lfdNummer: _lfdNummerCtrl.text.trim(),
      einsatznummerLeitstelle: _einsatznummerLeitstelleCtrl.text.trim(),
      feuerwehrName: _feuerwehrCtrl.text.trim(),
      datum: _datumCtrl.text.trim(),
      wochentag: _wochentagCtrl.text.trim(),
      alarmzeit: _alarmzeitCtrl.text.trim(),
      einsatzBeginn: _einsatzBeginnCtrl.text.trim(),
      einsatzEnde: _einsatzEndeCtrl.text.trim(),
        gesamteEinsatzzeitStunden:
          int.tryParse(_gesamteZeitStundenCtrl.text.trim()) ?? 0,
        gesamteEinsatzzeitMinuten:
          int.tryParse(_gesamteZeitMinutenCtrl.text.trim()) ?? 0,
      strasse: _strasseCtrl.text.trim(),
      hausnummer: _hausnummerCtrl.text.trim(),
      plz: _plzCtrl.text.trim(),
      ort: _ortCtrl.text.trim(),
      ortsteil: _ortsteilCtrl.text.trim(),
      einsatzart: _einsatzart,
      stichwort: _stichwort,
      meldeweg: _meldeweg,
      alarmLeitstelle: _alarmLeitstelle,
      alarmPolizei: _alarmPolizei,
      alarmMuendlich: _alarmMuendlich,
      einsatzleiter: _einsatzleiterCtrl.text.trim(),
      einsatztagebuchPolizei: _einsatztagebuchCtrl.text.trim(),
      sonstigeAnwesende: _sonstigeCtrl.text.trim(),
      vorgefundeneLage: _lageCtrl.text.trim(),
      einsatzmassnahmen: _massnahmenCtrl.text.trim(),
      einsatzverlauf: _verlaufCtrl.text.trim(),
      verletzte: _verletzte,
      gerettete: _gerettete,
      tote: _tote,
      objektTyp: _objektTyp,
      flaeche: _flaeche,
      eigentuemerName: _eigentuemerNameCtrl.text.trim(),
      eigentuemerStrasse: _eigentuemerStrasseCtrl.text.trim(),
      eigentuemerPlzWohnort: _eigentuemerPlzWohnortCtrl.text.trim(),
      eigentuemerGeburtsdatum: _eigentuemerGeburtsdatumCtrl.text.trim(),
      eigentuemerTaetigkeiten: _eigentuemerTaetigkeitenCtrl.text.trim(),
      eigentuemerReanimation: _eigentuemerReanimation,
      wasserentnahme: _wasserentnahme,
      schaumBildner: _schaumBildnerCtrl.text.trim(),
      schaumMenge: double.tryParse(_schaumMengeCtrl.text) ?? 0,
        schaumLiterCa: double.tryParse(_schaumLiterCaCtrl.text) ?? 0,
        loeschmittelAuswurfgeraetC: _loeschmittelAuswurfgeraetC,
        loeschmittelAuswurfgeraetB: _loeschmittelAuswurfgeraetB,
      atemschutzPa200: _atemschutzPa200,
      atemschutzPa300: _atemschutzPa300,
        atemschutzReserve:
          _atemschutzReserveAufgabentraeger + _atemschutzReserveFtz,
        atemschutzReserveAufgabentraeger: _atemschutzReserveAufgabentraeger,
        atemschutzReserveFtz: _atemschutzReserveFtz,
        oelbinderLandTyp: _oelbinderLandTypCtrl.text.trim(),
      oelbinderLand: double.tryParse(_oelbinderLandCtrl.text) ?? 0,
        oelbinderLandEntsorgungMit: _oelbinderLandEntsorgungMit,
        oelbinderLandEntsorgungOhne: _oelbinderLandEntsorgungOhne,
        oelbinderWasserTyp: _oelbinderWasserTypCtrl.text.trim(),
      oelbinderWasser: double.tryParse(_oelbinderWasserCtrl.text) ?? 0,
        oelbinderWasserEntsorgungMit: _oelbinderWasserEntsorgungMit,
        oelbinderWasserEntsorgungOhne: _oelbinderWasserEntsorgungOhne,
        oelbinderEntsorgung: entsorgungsHinweise.join(', '),
        handfeuerloecherTyp: _handfeuerloecherTypCtrl.text.trim(),
      handfeuerloecher: _handfeuerloecher,
        handfeuerloecherEntsorgungMit: _handfeuerloecherEntsorgungMit,
        handfeuerloecherEntsorgungOhne: _handfeuerloecherEntsorgungOhne,
      besondereGeraete: _besondereGeraeteCtrl.text.trim(),
      nachsorge: _nachsorge,
      nachsorgeBeschreibung: _nachsorgeCtrl.text.trim(),
      uebergabeprotokoll: _uebergabeprotokoll,
      einsatzstelleUebergebenAn: _einsatzstelleUebergebenAnCtrl.text.trim(),
      kostenersatzVorschlag: _kostenersatzVorschlag,
      bemerkung: _bemerkungCtrl.text.trim(),
      ortBericht: _ortBerichtCtrl.text.trim(),
      datumBericht: _datumBerichtCtrl.text.trim(),
      unterschrift: _unterschriftBase64,
      createdAt: widget.einsatz?.createdAt ?? DateTime.now().toIso8601String(),
      fahrzeuge: _fahrzeuge,
      kameraden: _kameraden,
      atemschutz: _atemschutzEintraege,
      weitereEinsatzmittel: _weitereEM,
      unfallbeteiligte: _buildUnfallbeteiligte(),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final provider = context.read<AppProvider>();
    final einsatz = _buildEinsatz();
    int savedId;
    if (isEdit) {
      await provider.updateEinsatz(einsatz);
      savedId = einsatz.id!;
    } else {
      savedId = await provider.addEinsatz(einsatz);
    }
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => EinsatzDetailScreen(einsatzId: savedId),
        ),
      );
    }
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      ctrl.text =
          '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
      // Auto-fill Wochentag if Datum field
      if (ctrl == _datumCtrl) {
        setState(
          () => _wochentagCtrl.text = AppConstants.wochentage[date.weekday - 1],
        );
      }
    }
  }

  void _berechnGesamtzeit() {
    final beginText = _einsatzBeginnCtrl.text;
    final endeText = _einsatzEndeCtrl.text;
    if (beginText.isEmpty || endeText.isEmpty) return;

    final beginParts = beginText.split(':');
    final endeParts = endeText.split(':');
    if (beginParts.length != 2 || endeParts.length != 2) return;

    final bh = int.tryParse(beginParts[0]);
    final bm = int.tryParse(beginParts[1]);
    final eh = int.tryParse(endeParts[0]);
    final em = int.tryParse(endeParts[1]);
    if (bh == null || bm == null || eh == null || em == null) return;

    int diff = (eh * 60 + em) - (bh * 60 + bm);
    if (diff < 0) diff += 24 * 60; // Einsatz über Mitternacht
    if (diff == 0) return;

    final stunden = diff ~/ 60;
    final minuten = diff % 60;
    _gesamteZeitStundenCtrl.text = stunden == 0 ? '' : '$stunden';
    _gesamteZeitMinutenCtrl.text = minuten == 0 ? '' : '$minuten';
  }

  Future<void> _pickTime(TextEditingController ctrl) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      ctrl.text =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  // ─── FAHRZEUG Dialog ────────────────────────────────────────────────────────

  Future<void> _addFahrzeug() async {
    final fahrzeuge = context.read<AppProvider>().fahrzeuge;
    String kennung = '';
    final wacheAbCtrl = TextEditingController();
    final estelleAnCtrl = TextEditingController();
    final estelleAbCtrl = TextEditingController();
    final wacheAnCtrl = TextEditingController();
    final kmCtrl = TextEditingController();
    final einsatzzeitStundenCtrl = TextEditingController();
    final einsatzzeitMinutenCtrl = TextEditingController();
    final nrCtrl = TextEditingController();
    int staerke = 1;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: const Text('Fahrzeug hinzufügen'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Fahrzeug',
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text('Fahrzeug auswählen'),
                  items: fahrzeuge
                      .map(
                        (f) => DropdownMenuItem(
                          value: f.kennung,
                          child: Text(f.kennung),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setS(() => kennung = v ?? ''),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: wacheAbCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Wache ab',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: estelleAnCtrl,
                        decoration: const InputDecoration(
                          labelText: 'E-Stelle an',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: estelleAbCtrl,
                        decoration: const InputDecoration(
                          labelText: 'E-Stelle ab',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: wacheAnCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Wache an',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: kmCtrl,
                        decoration: const InputDecoration(
                          labelText: 'gef. km',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: nrCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nr. EB-OFW',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: einsatzzeitStundenCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Einsatzzeit (h)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: einsatzzeitMinutenCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Einsatzzeit (min)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Stärke: '),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: staerke > 0
                          ? () => setS(() => staerke--)
                          : null,
                    ),
                    Text(
                      '$staerke',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setS(() => staerke++),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              onPressed: () {
                if (kennung.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bitte ein Fahrzeug auswählen.'),
                    ),
                  );
                  return;
                }
                setState(() {
                  final h = int.tryParse(einsatzzeitStundenCtrl.text.trim()) ??
                      0;
                  final m = int.tryParse(einsatzzeitMinutenCtrl.text.trim()) ??
                      0;
                  final einsatzzeit = (h > 0 || m > 0) ? '$h h $m min' : '';
                  _fahrzeuge.add(
                    EinsatzFahrzeug(
                      einsatzId: widget.einsatz?.id ?? 0,
                      kennung: kennung,
                      wacheAb: wacheAbCtrl.text,
                      estelleAn: estelleAnCtrl.text,
                      estelleAb: estelleAbCtrl.text,
                      wacheAn: wacheAnCtrl.text,
                      km: double.tryParse(kmCtrl.text) ?? 0,
                      einsatzZeit: einsatzzeit,
                      nrEbOfw: nrCtrl.text,
                      staerke: staerke,
                    ),
                  );
                });
                Navigator.pop(ctx);
              },
              child: const Text('Hinzufügen'),
            ),
          ],
        ),
      ),
    );
  }

  // ─── KAMERAD Dialog ─────────────────────────────────────────────────────────

  Future<void> _addKamerad() async {
    final allKameraden = context.read<AppProvider>().kameraden;
    final selectedIds = _kameraden.map((k) => k.kameradId).toSet();
    final fahrzeugZuordnung = <int, String>{
      for (final k in _kameraden)
        if (k.fahrzeug.isNotEmpty) k.kameradId: k.fahrzeug,
    };

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kameraden auswählen'),
        content: SizedBox(
          width: double.maxFinite,
          height: 460,
          child: StatefulBuilder(
            builder: (ctx, setS) => Column(
              children: [
                if (_fahrzeuge.isEmpty)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.withAlpha(18),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Hinweis: Erst Fahrzeuge hinzufügen, dann können Kameraden per Häkchen zugeordnet werden.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: allKameraden.length,
                    itemBuilder: (_, i) {
                      final k = allKameraden[i];
                      final selected = selectedIds.contains(k.id);
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            CheckboxListTile(
                              title: Text(k.vollname),
                              value: selected,
                              onChanged: (v) => setS(() {
                                if (v == true) {
                                  selectedIds.add(k.id!);
                                } else {
                                  selectedIds.remove(k.id);
                                  fahrzeugZuordnung.remove(k.id);
                                }
                              }),
                            ),
                            if (selected && _fahrzeuge.isNotEmpty && k.id != null)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                                child: Column(
                                  children: _fahrzeuge
                                      .map(
                                        (fz) => CheckboxListTile(
                                          dense: true,
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(fz.kennung),
                                          value:
                                              fahrzeugZuordnung[k.id] == fz.kennung,
                                          onChanged: (v) => setS(() {
                                            if (v == true) {
                                              fahrzeugZuordnung[k.id!] = fz.kennung;
                                            } else if (
                                                fahrzeugZuordnung[k.id] ==
                                                    fz.kennung) {
                                              fahrzeugZuordnung.remove(k.id);
                                            }
                                          }),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _kameraden = allKameraden
                    .where((k) => selectedIds.contains(k.id))
                    .map(
                      (k) => EinsatzKamerad(
                        einsatzId: widget.einsatz?.id ?? 0,
                        kameradId: k.id!,
                        fahrzeug: fahrzeugZuordnung[k.id] ?? '',
                        kameradName: k.vollname,
                      ),
                    )
                    .toList();
              });
              Navigator.pop(ctx);
            },
            child: const Text('Übernehmen'),
          ),
        ],
      ),
    );
  }

  // ─── ATEMSCHUTZ Dialog ──────────────────────────────────────────────────────

  Future<void> _addAtemschutz() async {
    final nameCtrl = TextEditingController();
    final paCtrl = TextEditingController();
    int druckVor = 300;
    int druckNach = 0;
    int dauer = 0;
    String zustand = 'Gut';
    // Kameraden-Namen für Dropdown (ohne bereits eingetragene Atemschutzträger)
    final kameradNamen = _kameraden
        .map((k) => k.kameradName ?? '')
        .where((n) => n.isNotEmpty)
        .toList();
    String? selectedKameradName =
        kameradNamen.isNotEmpty ? null : null;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: const Text('Atemschutzüberwachung'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (kameradNamen.isNotEmpty)
                  DropdownButtonFormField<String>(
                    initialValue: selectedKameradName,
                    decoration: const InputDecoration(
                      labelText: 'Atemschutzträger (aus Kameraden)',
                      border: OutlineInputBorder(),
                    ),
                    hint: const Text('Kamerad auswählen …'),
                    items: kameradNamen
                        .map((n) => DropdownMenuItem(value: n, child: Text(n)))
                        .toList(),
                    onChanged: (v) {
                      setS(() => selectedKameradName = v);
                      if (v != null) nameCtrl.text = v;
                    },
                  ),
                if (kameradNamen.isNotEmpty) const SizedBox(height: 8),
                TextFormField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: kameradNamen.isNotEmpty
                        ? 'Name (manuell anpassen)'
                        : 'Name des Trägers',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: paCtrl,
                  decoration: const InputDecoration(
                    labelText: 'PA-Nummer',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: '$druckVor',
                        decoration: const InputDecoration(
                          labelText: 'Druck vor (bar)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => druckVor = int.tryParse(v) ?? 300,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        initialValue: '$druckNach',
                        decoration: const InputDecoration(
                          labelText: 'Druck nach (bar)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => druckNach = int.tryParse(v) ?? 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: '$dauer',
                  decoration: const InputDecoration(
                    labelText: 'Dauer (min)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => dauer = int.tryParse(v) ?? 0,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: zustand,
                  decoration: const InputDecoration(
                    labelText: 'Zustand',
                    border: OutlineInputBorder(),
                  ),
                  items: AppConstants.atemschutzZustaende
                      .map((z) => DropdownMenuItem(value: z, child: Text(z)))
                      .toList(),
                  onChanged: (v) => setS(() => zustand = v ?? 'Gut'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _atemschutzEintraege.add(
                    AtemschutzEintrag(
                      einsatzId: widget.einsatz?.id ?? 0,
                      kameradName: nameCtrl.text,
                      paNummer: paCtrl.text,
                      druckVor: druckVor,
                      druckNach: druckNach,
                      dauer: dauer,
                      zustand: zustand,
                    ),
                  );
                });
                Navigator.pop(ctx);
              },
              child: const Text('Hinzufügen'),
            ),
          ],
        ),
      ),
    );
  }

  // ─── WEITERE EINSATZMITTEL ──────────────────────────────────────────────────

  Future<void> _addWeitereEM() async {
    String org = '';
    String einheit = '';
    int staerke = 0;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: const Text('Weitere Einsatzmittel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Organisation',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Auswählen'),
                items: AppConstants.weitereOrganisationen
                    .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                    .toList(),
                onChanged: (v) => org = v ?? '',
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Einheit / Bezeichnung',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => einheit = v,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Stärke: '),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: staerke > 0 ? () => setS(() => staerke--) : null,
                  ),
                  Text(
                    '$staerke',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setS(() => staerke++),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _weitereEM.add(
                    WeitereEinsatzmittel(
                      einsatzId: widget.einsatz?.id ?? 0,
                      organisation: org,
                      einheit: einheit,
                      staerke: staerke,
                    ),
                  );
                });
                Navigator.pop(ctx);
              },
              child: const Text('Hinzufügen'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Einsatz bearbeiten' : 'Neuer Einsatz'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.info_outline), text: 'Grunddaten'),
            Tab(icon: Icon(Icons.fire_truck), text: 'Kräfte'),
            Tab(icon: Icon(Icons.description), text: 'Details'),
            Tab(icon: Icon(Icons.medical_services), text: 'Material'),
            Tab(icon: Icon(Icons.note_alt), text: 'Abschluss'),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: const Text('Speichern'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildTab1Grunddaten(),
            _buildTab2Kraefte(),
            _buildTab3Details(),
            _buildTab4Material(),
            _buildTab5Abschluss(),
          ],
        ),
      ),
    );
  }

  // ─── TAB 1: Grunddaten ──────────────────────────────────────────────────────

  Widget _buildTab1Grunddaten() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader(
          title: 'Einsatzbericht',
          icon: Icons.assignment,
          color: Colors.red,
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomTextField(
                label: 'Lfd. Nummer',
                controller: _lfdNummerCtrl,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: CustomTextField(
                label: 'Einsatznummer Leitstelle',
                controller: _einsatznummerLeitstelleCtrl,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Name der Feuerwehr',
                controller: _feuerwehrCtrl,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),

        const SectionHeader(title: 'Datum & Uhrzeit', icon: Icons.schedule),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: CustomTextField(
                label: 'Datum',
                controller: _datumCtrl,
                readOnly: true,
                onTap: () => _pickDate(_datumCtrl),
                suffixIcon: const Icon(Icons.calendar_today),
                required: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: CustomTextField(
                label: 'Wochentag',
                controller: _wochentagCtrl,
                readOnly: true,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Alarmzeit',
                controller: _alarmzeitCtrl,
                hint: 'HH:MM',
                readOnly: true,
                onTap: () => _pickTime(_alarmzeitCtrl),
                suffixIcon: const Icon(Icons.access_time),
                required: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                label: 'Einsatzbeginn',
                controller: _einsatzBeginnCtrl,
                hint: 'HH:MM',
                readOnly: true,
                onTap: () => _pickTime(_einsatzBeginnCtrl),
                suffixIcon: const Icon(Icons.access_time),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                label: 'Einsatzende',
                controller: _einsatzEndeCtrl,
                hint: 'HH:MM',
                readOnly: true,
                onTap: () => _pickTime(_einsatzEndeCtrl),
                suffixIcon: const Icon(Icons.access_time),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'gesamte Einsatzzeit (h)',
                controller: _gesamteZeitStundenCtrl,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                label: 'gesamte Einsatzzeit (min)',
                controller: _gesamteZeitMinutenCtrl,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),

        const SectionHeader(title: 'Einsatzadresse', icon: Icons.location_on),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: CustomTextField(label: 'Straße', controller: _strasseCtrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: CustomTextField(label: 'Nr.', controller: _hausnummerCtrl),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomTextField(
                label: 'PLZ',
                controller: _plzCtrl,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: CustomTextField(label: 'Ort', controller: _ortCtrl),
            ),
          ],
        ),
        CustomTextField(label: 'Ortsteil', controller: _ortsteilCtrl),

        const SectionHeader(
          title: 'Einsatzart & Alarmierung',
          icon: Icons.local_fire_department,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: DropdownButtonFormField<String>(
            initialValue: _einsatzart.isEmpty ? null : _einsatzart,
            decoration: const InputDecoration(
              labelText: 'Einsatzart *',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            hint: const Text('Einsatzart auswählen'),
            items: AppConstants.einsatzarten
                .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                .toList(),
            onChanged: (v) => setState(() {
              _einsatzart = v ?? '';
              _stichwort = '';
            }),
          ),
        ),
        if (_einsatzart.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: DropdownButtonFormField<String>(
              initialValue: _stichwort.isEmpty ? null : _stichwort,
              decoration: const InputDecoration(
                labelText: 'Stichwort',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              hint: const Text('Stichwort auswählen'),
              items: (AppConstants.stichworte[_einsatzart] ?? [])
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _stichwort = v ?? ''),
            ),
          ),

        const SectionHeader(
          title: 'Meldeweg / Alarmierung',
          icon: Icons.notifications,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: DropdownButtonFormField<String>(
            initialValue: _meldeweg.isEmpty ? null : _meldeweg,
            decoration: const InputDecoration(
              labelText: 'Meldeweg',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            hint: const Text('Meldeweg auswählen'),
            items: AppConstants.meldewege
                .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                .toList(),
            onChanged: (v) => setState(() => _meldeweg = v ?? ''),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Leitstelle'),
                value: _alarmLeitstelle,
                onChanged: (v) => setState(() => _alarmLeitstelle = v ?? false),
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Polizei'),
                value: _alarmPolizei,
                onChanged: (v) => setState(() => _alarmPolizei = v ?? false),
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Mündlich'),
                value: _alarmMuendlich,
                onChanged: (v) => setState(() => _alarmMuendlich = v ?? false),
              ),
            ),
          ],
        ),

        const SectionHeader(
          title: 'Einsatzleiter & Sonstige',
          icon: Icons.person,
        ),
        CustomTextField(
          label: 'Name des Einsatzleiters',
          controller: _einsatzleiterCtrl,
        ),
        CustomTextField(
          label: 'Einsatztagebuch-Nr. Polizei',
          controller: _einsatztagebuchCtrl,
        ),
        CustomTextField(
          label: 'Sonstige Anwesende / Beteiligte',
          controller: _sonstigeCtrl,
          maxLines: 3,
        ),
      ],
    );
  }

  // ─── TAB 2: Kräfte & Mittel ─────────────────────────────────────────────────

  Widget _buildTab2Kraefte() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Fahrzeuge
        SectionHeader(
          title: 'Eigene Fahrzeuge (${_fahrzeuge.length})',
          icon: Icons.fire_truck,
          color: Colors.orange,
        ),
        ..._fahrzeuge.asMap().entries.map(
          (e) => _FahrzeugTile(
            fahrzeug: e.value,
            onDelete: () => setState(() => _fahrzeuge.removeAt(e.key)),
          ),
        ),
        OutlinedButton.icon(
          onPressed: _addFahrzeug,
          icon: const Icon(Icons.add),
          label: const Text('Fahrzeug hinzufügen'),
        ),

        // Kameraden
        SectionHeader(
          title: 'Beteiligte Kameraden (${_kameraden.length})',
          icon: Icons.people,
          color: Colors.blue,
        ),
        ..._kameraden.asMap().entries.map(
          (e) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Colors.blue.withAlpha(20),
              child: const Icon(Icons.person, color: Colors.blue, size: 18),
            ),
            title: Text(e.value.kameradName ?? 'Kamerad'),
            subtitle: e.value.fahrzeug.isNotEmpty
                ? Text(e.value.fahrzeug)
                : null,
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () => setState(() => _kameraden.removeAt(e.key)),
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: _addKamerad,
          icon: const Icon(Icons.person_add),
          label: const Text('Kameraden auswählen'),
        ),

        // Weitere Einsatzmittel
        SectionHeader(
          title: 'Weitere Einsatzmittel (${_weitereEM.length})',
          icon: Icons.emergency,
          color: Colors.purple,
        ),
        ..._weitereEM.asMap().entries.map(
          (e) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Colors.purple.withAlpha(20),
              child: const Icon(
                Icons.emergency,
                color: Colors.purple,
                size: 18,
              ),
            ),
            title: Text('${e.value.organisation} – ${e.value.einheit}'),
            subtitle: Text('Stärke: ${e.value.staerke}'),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () => setState(() => _weitereEM.removeAt(e.key)),
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: _addWeitereEM,
          icon: const Icon(Icons.add),
          label: const Text('Weitere Einsatzmittel'),
        ),
      ],
    );
  }

  // ─── TAB 3: Einsatzdetails ──────────────────────────────────────────────────

  Widget _buildTab3Details() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader(title: 'Vorgefundene Lage', icon: Icons.visibility),
        CustomTextField(
          label: 'Vorgefundene Lage / Einsatzmaßnahmen / -verlauf',
          controller: _lageCtrl,
          maxLines: 6,
          hint: 'Beschreibung der vorgefundenen Situation...',
        ),
        const SectionHeader(title: 'Einsatzmaßnahmen', icon: Icons.build),
        CustomTextField(
          label: 'Durchgeführte Maßnahmen',
          controller: _massnahmenCtrl,
          maxLines: 4,
          hint: 'Welche Maßnahmen wurden ergriffen...',
        ),
        const SectionHeader(title: 'Einsatzverlauf', icon: Icons.timeline),
        CustomTextField(
          label: 'Einsatzverlauf',
          controller: _verlaufCtrl,
          maxLines: 4,
        ),
        const SectionHeader(
          title: 'Betroffene Personen',
          icon: Icons.personal_injury,
        ),
        NumberStepperField(
          label: 'Verletzte',
          value: _verletzte,
          onChanged: (v) => setState(() => _verletzte = v),
        ),
        NumberStepperField(
          label: 'Gerettete',
          value: _gerettete,
          onChanged: (v) => setState(() => _gerettete = v),
        ),
        NumberStepperField(
          label: 'Tote',
          value: _tote,
          onChanged: (v) => setState(() => _tote = v),
        ),
        const SectionHeader(
          title: 'Unfallbeteiligte / Geschädigte / Eigentümer',
          icon: Icons.car_crash,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Eigentümer Grundstück / Wald / Gebäude',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                CustomTextField(label: 'Name', controller: _eigentuemerNameCtrl),
                CustomTextField(
                  label: 'Straße',
                  controller: _eigentuemerStrasseCtrl,
                ),
                CustomTextField(
                  label: 'PLZ, Wohnort',
                  controller: _eigentuemerPlzWohnortCtrl,
                ),
                CustomTextField(
                  label: 'Geb.-Datum',
                  controller: _eigentuemerGeburtsdatumCtrl,
                ),
                CustomTextField(
                  label: 'Durchgeführte Tätigkeiten',
                  controller: _eigentuemerTaetigkeitenCtrl,
                  maxLines: 3,
                ),
                YesNoField(
                  label: 'Reanimation',
                  value: _eigentuemerReanimation,
                  onChanged: (v) => setState(() => _eigentuemerReanimation = v),
                ),
              ],
            ),
          ),
        ),
        ...List.generate(
          3,
          (i) => Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Unfallbeteiligter ${i + 1}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  CustomTextField(label: 'Name', controller: _ubNameCtrls[i]),
                  CustomTextField(
                    label: 'Straße',
                    controller: _ubStrasseCtrls[i],
                  ),
                  CustomTextField(
                    label: 'PLZ, Wohnort',
                    controller: _ubPlzWohnortCtrls[i],
                  ),
                  CustomTextField(
                    label: 'Geb.-Datum',
                    controller: _ubGeburtsdatumCtrls[i],
                  ),
                  CustomTextField(
                    label: 'PKW-Typ',
                    controller: _ubPkwTypCtrls[i],
                  ),
                  CustomTextField(
                    label: 'Kennzeichen',
                    controller: _ubKennzeichenCtrls[i],
                  ),
                  CustomTextField(
                    label: 'Tätigkeiten am Fahrzeug',
                    controller: _ubTaetigkeitenCtrls[i],
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SectionHeader(title: 'Objekt & Fläche', icon: Icons.business),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: DropdownButtonFormField<String>(
            initialValue: _objektTyp.isEmpty ? null : _objektTyp,
            decoration: const InputDecoration(
              labelText: 'Objekt-Typ',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            hint: const Text('Typ auswählen'),
            items: AppConstants.objektTypen
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (v) => setState(() => _objektTyp = v ?? ''),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: DropdownButtonFormField<String>(
            initialValue: _flaeche.isEmpty ? null : _flaeche,
            decoration: const InputDecoration(
              labelText: 'Flächengröße (Flächenbrand)',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            hint: const Text('Größe auswählen'),
            items: AppConstants.flaechenGroessen
                .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                .toList(),
            onChanged: (v) => setState(() => _flaeche = v ?? ''),
          ),
        ),
      ],
    );
  }

  // ─── TAB 4: Material & Verbrauch ────────────────────────────────────────────

  Widget _buildTab4Material() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader(title: 'Wasserentnahme', icon: Icons.water),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: DropdownButtonFormField<String>(
            initialValue: _wasserentnahme.isEmpty ? null : _wasserentnahme,
            decoration: const InputDecoration(
              labelText: 'Wasserentnahmestelle',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            hint: const Text('Auswählen'),
            items: AppConstants.wasserentnahmen
                .map((w) => DropdownMenuItem(value: w, child: Text(w)))
                .toList(),
            onChanged: (v) => setState(() => _wasserentnahme = v ?? ''),
          ),
        ),

        const SectionHeader(title: 'Schaum', icon: Icons.bubble_chart),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Schaumbildner',
                controller: _schaumBildnerCtrl,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                label: 'Menge (kg)',
                controller: _schaumMengeCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                label: 'in Liter ca.',
                controller: _schaumLiterCaCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: NumberStepperField(
                label: 'Löschmittelauswurfgeräte C',
                value: _loeschmittelAuswurfgeraetC,
                onChanged: (v) => setState(() => _loeschmittelAuswurfgeraetC = v),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: NumberStepperField(
                label: 'Löschmittelauswurfgeräte B',
                value: _loeschmittelAuswurfgeraetB,
                onChanged: (v) => setState(() => _loeschmittelAuswurfgeraetB = v),
              ),
            ),
          ],
        ),

        const SectionHeader(title: 'Atemschutz', icon: Icons.air),
        NumberStepperField(
          label: 'PA-Geräte 200 bar',
          value: _atemschutzPa200,
          onChanged: (v) => setState(() => _atemschutzPa200 = v),
        ),
        NumberStepperField(
          label: 'PA-Geräte 300 bar',
          value: _atemschutzPa300,
          onChanged: (v) => setState(() => _atemschutzPa300 = v),
        ),
        NumberStepperField(
          label: 'Reserve Flaschen vom Aufgabenträger',
          value: _atemschutzReserveAufgabentraeger,
          onChanged: (v) => setState(() => _atemschutzReserveAufgabentraeger = v),
        ),
        NumberStepperField(
          label: 'Reserveflaschen vom FTZ',
          value: _atemschutzReserveFtz,
          onChanged: (v) => setState(() => _atemschutzReserveFtz = v),
        ),

        SectionHeader(
          title: 'Atemschutzüberwachung (${_atemschutzEintraege.length})',
          icon: Icons.monitor_heart,
          color: Colors.teal,
        ),
        ..._atemschutzEintraege.asMap().entries.map(
          (e) => Card(
            margin: const EdgeInsets.only(bottom: 6),
            child: ListTile(
              title: Text(
                e.value.kameradName.isNotEmpty ? e.value.kameradName : 'Träger',
              ),
              subtitle: Text(
                'PA: ${e.value.paNummer}  |  '
                '${e.value.druckVor}→${e.value.druckNach} bar  |  '
                '${e.value.dauer} min  |  ${e.value.zustand}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () =>
                    setState(() => _atemschutzEintraege.removeAt(e.key)),
              ),
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: _addAtemschutz,
          icon: const Icon(Icons.add),
          label: const Text('Atemschutzträger hinzufügen'),
        ),

        const SectionHeader(title: 'Ölbinder / Handfeuerlöscher', icon: Icons.opacity),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ölbinder Land',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Typ',
                        controller: _oelbinderLandTypCtrl,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        label: 'Menge in kg ca.',
                        controller: _oelbinderLandCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Entsorgung mit'),
                        value: _oelbinderLandEntsorgungMit,
                        onChanged: (v) => setState(() {
                          _oelbinderLandEntsorgungMit = v ?? false;
                          if (_oelbinderLandEntsorgungMit) {
                            _oelbinderLandEntsorgungOhne = false;
                          }
                        }),
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Entsorgung ohne'),
                        value: _oelbinderLandEntsorgungOhne,
                        onChanged: (v) => setState(() {
                          _oelbinderLandEntsorgungOhne = v ?? false;
                          if (_oelbinderLandEntsorgungOhne) {
                            _oelbinderLandEntsorgungMit = false;
                          }
                        }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ölbinder Wasser',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Typ',
                        controller: _oelbinderWasserTypCtrl,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        label: 'Menge in kg ca.',
                        controller: _oelbinderWasserCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Entsorgung mit'),
                        value: _oelbinderWasserEntsorgungMit,
                        onChanged: (v) => setState(() {
                          _oelbinderWasserEntsorgungMit = v ?? false;
                          if (_oelbinderWasserEntsorgungMit) {
                            _oelbinderWasserEntsorgungOhne = false;
                          }
                        }),
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Entsorgung ohne'),
                        value: _oelbinderWasserEntsorgungOhne,
                        onChanged: (v) => setState(() {
                          _oelbinderWasserEntsorgungOhne = v ?? false;
                          if (_oelbinderWasserEntsorgungOhne) {
                            _oelbinderWasserEntsorgungMit = false;
                          }
                        }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Handfeuerlöscher',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Typ',
                        controller: _handfeuerloecherTypCtrl,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: NumberStepperField(
                        label: 'Menge (Stk.)',
                        value: _handfeuerloecher,
                        onChanged: (v) => setState(() => _handfeuerloecher = v),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Entsorgung mit'),
                        value: _handfeuerloecherEntsorgungMit,
                        onChanged: (v) => setState(() {
                          _handfeuerloecherEntsorgungMit = v ?? false;
                          if (_handfeuerloecherEntsorgungMit) {
                            _handfeuerloecherEntsorgungOhne = false;
                          }
                        }),
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Entsorgung ohne'),
                        value: _handfeuerloecherEntsorgungOhne,
                        onChanged: (v) => setState(() {
                          _handfeuerloecherEntsorgungOhne = v ?? false;
                          if (_handfeuerloecherEntsorgungOhne) {
                            _handfeuerloecherEntsorgungMit = false;
                          }
                        }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SectionHeader(title: 'Sonstiges Material', icon: Icons.build),
        CustomTextField(
          label: 'Besondere Geräte',
          controller: _besondereGeraeteCtrl,
          maxLines: 2,
          hint: 'z. B. Rettungszylinder, Hebekissen, Motorsäge...',
        ),
      ],
    );
  }

  // ─── TAB 5: Abschluss ───────────────────────────────────────────────────────

  Widget _buildTab5Abschluss() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader(title: 'Nachbereitung', icon: Icons.post_add),
        YesNoField(
          label: 'Nachsorgemaßnahmen (§ 35 BbgBKG)',
          value: _nachsorge,
          onChanged: (v) => setState(() => _nachsorge = v),
        ),
        if (_nachsorge)
          CustomTextField(
            label: 'Beschreibung der Nachsorgemaßnahmen',
            controller: _nachsorgeCtrl,
            maxLines: 3,
          ),
        YesNoField(
          label: 'Übergabe-/Übernahmeprotokoll gefertigt',
          value: _uebergabeprotokoll,
          onChanged: (v) => setState(() => _uebergabeprotokoll = v),
        ),
        CustomTextField(
          label: 'Einsatzstelle übergeben an',
          controller: _einsatzstelleUebergebenAnCtrl,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: DropdownButtonFormField<String>(
            initialValue: _kostenersatzVorschlag.isEmpty
                ? null
                : _kostenersatzVorschlag,
            decoration: const InputDecoration(
              labelText: 'Vorschlag auf Kostenersatz',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            hint: const Text('Auswählen'),
            items: const [
              DropdownMenuItem(value: 'ja', child: Text('ja')),
              DropdownMenuItem(value: 'nein', child: Text('nein')),
            ],
            onChanged: (v) => setState(() => _kostenersatzVorschlag = v ?? ''),
          ),
        ),
        const SectionHeader(title: 'Bemerkungen', icon: Icons.comment),
        CustomTextField(
          label: 'Bemerkung',
          controller: _bemerkungCtrl,
          maxLines: 4,
        ),
        const SectionHeader(
          title: 'Berichtsdaten',
          icon: Icons.assignment_turned_in,
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextField(label: 'Ort', controller: _ortBerichtCtrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                label: 'Datum',
                controller: _datumBerichtCtrl,
                readOnly: true,
                onTap: () => _pickDate(_datumBerichtCtrl),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
            ),
          ],
        ),
        _SignaturePadWidget(
          base64Value: _unterschriftBase64,
          onSaved: (b64) => setState(() => _unterschriftBase64 = b64),
        ),
        const SizedBox(height: 32),
        FilledButton.icon(
          onPressed: _saving ? null : _save,
          icon: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.save),
          label: Text(isEdit ? 'Änderungen speichern' : 'Einsatz speichern'),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            backgroundColor: Colors.red,
          ),
        ),
      ],
    );
  }
}

class _FahrzeugTile extends StatelessWidget {
  final EinsatzFahrzeug fahrzeug;
  final VoidCallback onDelete;

  const _FahrzeugTile({required this.fahrzeug, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.fire_truck, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fahrzeug.kennung.isNotEmpty ? fahrzeug.kennung : 'Fahrzeug',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  'Stärke: ${fahrzeug.staerke}',
                  style: const TextStyle(color: Colors.grey),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Wache ab: ${fahrzeug.wacheAb}  •  E-Stelle an: ${fahrzeug.estelleAn}  •  '
              'E-Stelle ab: ${fahrzeug.estelleAb}  •  Wache an: ${fahrzeug.wacheAn}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (fahrzeug.km > 0)
              Text(
                '${fahrzeug.km} km',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            if (fahrzeug.einsatzZeit.isNotEmpty)
              Text(
                'Einsatzzeit: ${fahrzeug.einsatzZeit}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Unterschrift-Pad ────────────────────────────────────────────────────────

class _SignaturePadWidget extends StatelessWidget {
  final String base64Value;
  final ValueChanged<String> onSaved;

  const _SignaturePadWidget({required this.base64Value, required this.onSaved});

  Future<void> _openPad(BuildContext context) async {
    final ctrl = SignatureController(
      penStrokeWidth: 2.5,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Unterschrift'),
        content: SizedBox(
          width: 500,
          height: 200,
          child: Signature(
            controller: ctrl,
            backgroundColor: Colors.grey.shade100,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => ctrl.clear(),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Löschen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () async {
              if (ctrl.isEmpty) {
                Navigator.pop(ctx);
                return;
              }
              final bytes = await ctrl.toPngBytes();
              ctrl.dispose();
              if (bytes != null) {
                onSaved(base64Encode(bytes));
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Übernehmen'),
          ),
        ],
      ),
    );
    if (ctrl.isNotEmpty) ctrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasSignature = base64Value.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Unterschrift (Einsatzleiter)',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _openPad(context),
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey.shade50,
            ),
            child: hasSignature
                ? Image.memory(
                    base64Decode(base64Value),
                    fit: BoxFit.contain,
                  )
                : const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.draw_outlined, color: Colors.grey),
                        SizedBox(height: 4),
                        Text(
                          'Tippen zum Unterschreiben',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        if (hasSignature)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => onSaved(''),
              icon: const Icon(Icons.delete_outline, size: 16),
              label: const Text('Unterschrift löschen'),
            ),
          ),
      ],
    );
  }
}

