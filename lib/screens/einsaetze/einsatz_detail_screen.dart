// lib/screens/einsaetze/einsatz_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/einsatz.dart';
import '../../utils/pdf_generator.dart';
import '../../widgets/custom_text_field.dart';
import 'einsatz_form_screen.dart';

class EinsatzDetailScreen extends StatefulWidget {
  final int einsatzId;

  const EinsatzDetailScreen({super.key, required this.einsatzId});

  @override
  State<EinsatzDetailScreen> createState() => _EinsatzDetailScreenState();
}

class _EinsatzDetailScreenState extends State<EinsatzDetailScreen> {
  Einsatz? _einsatz;
  bool _loading = true;
  bool _generatingPdf = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final e = await context.read<AppProvider>().getEinsatzDetail(widget.einsatzId);
    setState(() {
      _einsatz = e;
      _loading = false;
    });
  }

  Future<void> _generatePdf() async {
    if (_einsatz == null) return;
    setState(() => _generatingPdf = true);
    try {
      await PdfGenerator.generateAndShare(_einsatz!);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF-Fehler: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _generatingPdf = false);
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Einsatz löschen'),
        content: const Text('Diesen Einsatz wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Abbrechen')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      if (mounted) {
        await context.read<AppProvider>().deleteEinsatz(widget.einsatzId);
        if (mounted) Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_einsatz == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Einsatz')),
        body: const Center(child: Text('Einsatz nicht gefunden')),
      );
    }

    final e = _einsatz!;

    return Scaffold(
      appBar: AppBar(
        title: Text(e.einsatzart.isNotEmpty ? e.einsatzart : 'Einsatz'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Bearbeiten',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EinsatzFormScreen(einsatz: e)),
              );
              await _load();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: 'Löschen',
            onPressed: _delete,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          _HeaderCard(einsatz: e),

          // PDF Button
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _generatingPdf ? null : _generatePdf,
            icon: _generatingPdf
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.picture_as_pdf),
            label: const Text('Einsatzbericht als PDF'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: Colors.red.shade700,
            ),
          ),

          // Sections
          if (e.strasse.isNotEmpty || e.ort.isNotEmpty) ...[
            const SectionHeader(title: 'Einsatzadresse', icon: Icons.location_on),
            infoRow('Adresse', [e.strasse, e.hausnummer].where((s) => s.isNotEmpty).join(' ')),
            infoRow('Ort', [e.plz, e.ort, e.ortsteil].where((s) => s.isNotEmpty).join(' ')),
          ],

          const SectionHeader(title: 'Zeiten', icon: Icons.schedule),
          infoRow('Datum', '${e.datum} (${e.wochentag})'),
          if (e.einsatznummerLeitstelle.isNotEmpty)
            infoRow('Einsatznummer Leitstelle', e.einsatznummerLeitstelle),
          infoRow('Alarmzeit', e.alarmzeit.isNotEmpty ? '${e.alarmzeit} Uhr' : '—'),
          infoRow('Einsatzbeginn', e.einsatzBeginn.isNotEmpty ? '${e.einsatzBeginn} Uhr' : '—'),
          infoRow('Einsatzende', e.einsatzEnde.isNotEmpty ? '${e.einsatzEnde} Uhr' : '—'),
          if (e.gesamteEinsatzzeitStunden > 0 || e.gesamteEinsatzzeitMinuten > 0)
            infoRow(
              'gesamte Einsatzzeit',
              '${e.gesamteEinsatzzeitStunden} h ${e.gesamteEinsatzzeitMinuten} min',
            ),

          const SectionHeader(title: 'Alarmierung', icon: Icons.notifications),
          infoRow('Meldeweg', e.meldeweg),
          Row(children: [
            if (e.alarmLeitstelle) infoChip('Leitstelle'),
            if (e.alarmPolizei) infoChip('Polizei'),
            if (e.alarmMuendlich) infoChip('Mündlich'),
          ]),

          if (e.einsatzleiter.isNotEmpty) ...[
            const SectionHeader(title: 'Personal', icon: Icons.person),
            infoRow('Einsatzleiter', e.einsatzleiter),
            if (e.einsatztagebuchPolizei.isNotEmpty)
              infoRow('EB-Nr. Polizei', e.einsatztagebuchPolizei),
            if (e.sonstigeAnwesende.isNotEmpty)
              infoRow('Sonstige Anwesende', e.sonstigeAnwesende),
          ],

          if (e.fahrzeuge.isNotEmpty) ...[
            SectionHeader(title: 'Fahrzeuge (${e.fahrzeuge.length})', icon: Icons.fire_truck, color: Colors.orange),
            ...e.fahrzeuge.map((fz) => _FahrzeugDetail(fz)),
          ],

          if (e.kameraden.isNotEmpty) ...[
            SectionHeader(title: 'Kameraden (${e.kameraden.length})', icon: Icons.people, color: Colors.blue),
            ...e.kameraden.map((k) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.person, color: Colors.blue),
              title: Text(k.kameradName ?? ''),
              subtitle: k.fahrzeug.isNotEmpty ? Text(k.fahrzeug) : null,
            )),
          ],

          if (e.weitereEinsatzmittel.isNotEmpty) ...[
            SectionHeader(title: 'Weitere Einsatzmittel', icon: Icons.emergency, color: Colors.purple),
            ...e.weitereEinsatzmittel.map((w) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.emergency, color: Colors.purple),
              title: Text('${w.organisation}${w.einheit.isNotEmpty ? ' – ${w.einheit}' : ''}'),
              subtitle: Text('Stärke: ${w.staerke}'),
            )),
          ],

          if (e.vorgefundeneLage.isNotEmpty || e.einsatzmassnahmen.isNotEmpty || e.einsatzverlauf.isNotEmpty) ...[
            const SectionHeader(title: 'Einsatzdetails', icon: Icons.description),
            if (e.vorgefundeneLage.isNotEmpty) infoBlock('Vorgefundene Lage', e.vorgefundeneLage),
            if (e.einsatzmassnahmen.isNotEmpty) infoBlock('Maßnahmen', e.einsatzmassnahmen),
            if (e.einsatzverlauf.isNotEmpty) infoBlock('Verlauf', e.einsatzverlauf),
          ],

          if (e.verletzte > 0 || e.gerettete > 0 || e.tote > 0) ...[
            const SectionHeader(title: 'Personen', icon: Icons.personal_injury),
            if (e.verletzte > 0) infoRow('Verletzte', '${e.verletzte}'),
            if (e.gerettete > 0) infoRow('Gerettete', '${e.gerettete}'),
            if (e.tote > 0) infoRow('Tote', '${e.tote}'),
          ],

          if (e.eigentuemerName.isNotEmpty ||
              e.eigentuemerStrasse.isNotEmpty ||
              e.eigentuemerPlzWohnort.isNotEmpty ||
              e.eigentuemerGeburtsdatum.isNotEmpty ||
              e.eigentuemerTaetigkeiten.isNotEmpty ||
              e.eigentuemerReanimation ||
              e.unfallbeteiligte.any(
                (u) =>
                    u.name.isNotEmpty ||
                    u.strasse.isNotEmpty ||
                    u.plzWohnort.isNotEmpty ||
                    u.geburtsdatum.isNotEmpty ||
                    u.pkwTyp.isNotEmpty ||
                    u.kennzeichen.isNotEmpty ||
                    u.taetigkeitenAmFahrzeug.isNotEmpty,
              )) ...[
            const SectionHeader(
              title: 'Unfallbeteiligte / Geschädigte / Eigentümer',
              icon: Icons.car_crash,
            ),
            if (e.eigentuemerName.isNotEmpty ||
                e.eigentuemerStrasse.isNotEmpty ||
                e.eigentuemerPlzWohnort.isNotEmpty ||
                e.eigentuemerGeburtsdatum.isNotEmpty ||
                e.eigentuemerTaetigkeiten.isNotEmpty ||
                e.eigentuemerReanimation)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Eigentümer Grundstück / Wald / Gebäude',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      infoRow('Name', e.eigentuemerName),
                      infoRow('Straße', e.eigentuemerStrasse),
                      infoRow('PLZ, Wohnort', e.eigentuemerPlzWohnort),
                      infoRow('Geb.-Datum', e.eigentuemerGeburtsdatum),
                      if (e.eigentuemerTaetigkeiten.isNotEmpty)
                        infoBlock('Durchgeführte Tätigkeiten', e.eigentuemerTaetigkeiten),
                      infoRow('Reanimation', e.eigentuemerReanimation ? 'Ja' : 'Nein'),
                    ],
                  ),
                ),
              ),
            ...e.unfallbeteiligte
                .where(
                  (u) =>
                      u.name.isNotEmpty ||
                      u.strasse.isNotEmpty ||
                      u.plzWohnort.isNotEmpty ||
                      u.geburtsdatum.isNotEmpty ||
                      u.pkwTyp.isNotEmpty ||
                      u.kennzeichen.isNotEmpty ||
                      u.taetigkeitenAmFahrzeug.isNotEmpty,
                )
                .map(
                  (u) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Unfallbeteiligter ${u.position}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          infoRow('Name', u.name),
                          infoRow('Straße', u.strasse),
                          infoRow('PLZ, Wohnort', u.plzWohnort),
                          infoRow('Geb.-Datum', u.geburtsdatum),
                          infoRow('PKW-Typ', u.pkwTyp),
                          infoRow('Kennzeichen', u.kennzeichen),
                          if (u.taetigkeitenAmFahrzeug.isNotEmpty)
                            infoBlock('Tätigkeiten am Fahrzeug', u.taetigkeitenAmFahrzeug),
                        ],
                      ),
                    ),
                  ),
                ),
          ],

          // Material
          _buildMaterialSection(e),

          if (e.atemschutz.isNotEmpty) ...[
            SectionHeader(title: 'Atemschutzüberwachung (${e.atemschutz.length})', icon: Icons.air, color: Colors.teal),
            ...e.atemschutz.map((a) => Card(
              margin: const EdgeInsets.only(bottom: 6),
              child: ListTile(
                title: Text(a.kameradName.isNotEmpty ? a.kameradName : 'Träger'),
                subtitle: Text(
                  'PA: ${a.paNummer}  •  ${a.druckVor}→${a.druckNach} bar  •  ${a.dauer} min  •  ${a.zustand}',
                ),
              ),
            )),
          ],

          const SectionHeader(title: 'Nachbereitung', icon: Icons.post_add),
          infoRow('Nachsorge', e.nachsorge ? 'Ja' : 'Nein'),
          if (e.nachsorge && e.nachsorgeBeschreibung.isNotEmpty)
            infoBlock('Nachsorge-Beschreibung', e.nachsorgeBeschreibung),
          infoRow('Übergabeprotokoll', e.uebergabeprotokoll ? 'Ja' : 'Nein'),
          if (e.einsatzstelleUebergebenAn.isNotEmpty)
            infoRow('Einsatzstelle übergeben an', e.einsatzstelleUebergebenAn),
          if (e.kostenersatzVorschlag.isNotEmpty)
            infoRow('Vorschlag auf Kostenersatz', e.kostenersatzVorschlag),
          if (e.bemerkung.isNotEmpty) infoBlock('Bemerkung', e.bemerkung),

          const SectionHeader(title: 'Bericht', icon: Icons.assignment_turned_in),
          infoRow('Ort, Datum', '${e.ortBericht}, ${e.datumBericht}'),
          infoRow('Unterschrift', e.unterschrift),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildMaterialSection(Einsatz e) {
    final hasMaterial = e.wasserentnahme.isNotEmpty ||
        e.schaumBildner.isNotEmpty ||
        e.schaumLiterCa > 0 ||
        e.loeschmittelAuswurfgeraetC > 0 ||
        e.loeschmittelAuswurfgeraetB > 0 ||
        e.atemschutzPa200 > 0 ||
        e.atemschutzPa300 > 0 ||
        e.atemschutzReserveAufgabentraeger > 0 ||
        e.atemschutzReserveFtz > 0 ||
        e.oelbinderLandTyp.isNotEmpty ||
        e.oelbinderLand > 0 ||
        e.oelbinderWasserTyp.isNotEmpty ||
        e.oelbinderWasser > 0 ||
        e.handfeuerloecherTyp.isNotEmpty ||
        e.handfeuerloecher > 0 ||
        e.besondereGeraete.isNotEmpty;

    if (!hasMaterial) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Material & Verbrauch', icon: Icons.build),
        if (e.wasserentnahme.isNotEmpty) infoRow('Wasserentnahme', e.wasserentnahme),
        if (e.schaumBildner.isNotEmpty)
          infoRow('Schaum', '${e.schaumBildner}${e.schaumMenge > 0 ? ' (${e.schaumMenge} kg)' : ''}'),
        if (e.schaumLiterCa > 0) infoRow('Schaum in Liter ca.', '${e.schaumLiterCa}'),
        if (e.loeschmittelAuswurfgeraetC > 0)
          infoRow('Löschmittelauswurfgeräte C', '${e.loeschmittelAuswurfgeraetC}'),
        if (e.loeschmittelAuswurfgeraetB > 0)
          infoRow('Löschmittelauswurfgeräte B', '${e.loeschmittelAuswurfgeraetB}'),
        if (e.atemschutzPa200 > 0) infoRow('PA 200 bar', '${e.atemschutzPa200}'),
        if (e.atemschutzPa300 > 0) infoRow('PA 300 bar', '${e.atemschutzPa300}'),
        if (e.atemschutzReserveAufgabentraeger > 0)
          infoRow('Reserveflaschen Aufgabenträger', '${e.atemschutzReserveAufgabentraeger}'),
        if (e.atemschutzReserveFtz > 0)
          infoRow('Reserveflaschen FTZ', '${e.atemschutzReserveFtz}'),
        if (e.oelbinderLandTyp.isNotEmpty) infoRow('Ölbinder Land Typ', e.oelbinderLandTyp),
        if (e.oelbinderLand > 0) infoRow('Ölbinder Land', '${e.oelbinderLand} kg'),
        if (e.oelbinderLandEntsorgungMit || e.oelbinderLandEntsorgungOhne)
          infoRow(
            'Ölbinder Land Entsorgung',
            e.oelbinderLandEntsorgungMit ? 'mit' : 'ohne',
          ),
        if (e.oelbinderWasserTyp.isNotEmpty)
          infoRow('Ölbinder Wasser Typ', e.oelbinderWasserTyp),
        if (e.oelbinderWasser > 0) infoRow('Ölbinder Wasser', '${e.oelbinderWasser} kg'),
        if (e.oelbinderWasserEntsorgungMit || e.oelbinderWasserEntsorgungOhne)
          infoRow(
            'Ölbinder Wasser Entsorgung',
            e.oelbinderWasserEntsorgungMit ? 'mit' : 'ohne',
          ),
        if (e.handfeuerloecherTyp.isNotEmpty)
          infoRow('Handfeuerlöscher Typ', e.handfeuerloecherTyp),
        if (e.handfeuerloecher > 0) infoRow('Handfeuerlöscher', '${e.handfeuerloecher}'),
        if (e.handfeuerloecherEntsorgungMit || e.handfeuerloecherEntsorgungOhne)
          infoRow(
            'Handfeuerlöscher Entsorgung',
            e.handfeuerloecherEntsorgungMit ? 'mit' : 'ohne',
          ),
        if (e.besondereGeraete.isNotEmpty) infoRow('Besondere Geräte', e.besondereGeraete),
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final Einsatz einsatz;

  const _HeaderCard({required this.einsatz});

  Color get _color {
    switch (einsatz.einsatzart) {
      case 'Brand':
        return Colors.red;
      case 'Hilfeleistung':
      case 'Technische Hilfeleistung':
        return Colors.orange;
      case 'Fehlalarm':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _color.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.local_fire_department, color: _color, size: 32),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (einsatz.lfdNummer.isNotEmpty)
                        Text('Einsatz #${einsatz.lfdNummer}',
                            style: TextStyle(color: _color, fontSize: 13, fontWeight: FontWeight.w600)),
                      Text(
                        einsatz.einsatzart.isNotEmpty ? einsatz.einsatzart : 'Einsatz',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      if (einsatz.stichwort.isNotEmpty)
                        Text(einsatz.stichwort, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
            if (einsatz.feuerwehrName.isNotEmpty) ...[
              const Divider(height: 20),
              Text(einsatz.feuerwehrName, style: const TextStyle(color: Colors.grey)),
            ],
          ],
        ),
      ),
    );
  }
}

Widget infoRow(String label, String value) {
  if (value.isEmpty || value == '0') return const SizedBox.shrink();
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
      ],
    ),
  );
}

Widget infoBlock(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value, style: const TextStyle(fontSize: 14)),
        ),
      ],
    ),
  );
}

Widget infoChip(String label) {
  return Container(
    margin: const EdgeInsets.only(right: 8, bottom: 4),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.blue.withAlpha(30),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.blue)),
  );
}

class _FahrzeugDetail extends StatelessWidget {
  final EinsatzFahrzeug fz;

  const _FahrzeugDetail(this.fz);

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
                const Icon(Icons.fire_truck, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Text(fz.kennung, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const Spacer(),
                Text('Stärke: ${fz.staerke}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Table(
              columnWidths: const {0: FlexColumnWidth(), 1: FlexColumnWidth()},
              children: [
                if (fz.wacheAb.isNotEmpty || fz.estelleAn.isNotEmpty)
                  TableRow(children: [
                    Text('Wache ab: ${fz.wacheAb}', style: const TextStyle(fontSize: 13)),
                    Text('E-Stelle an: ${fz.estelleAn}', style: const TextStyle(fontSize: 13)),
                  ]),
                if (fz.estelleAb.isNotEmpty || fz.wacheAn.isNotEmpty)
                  TableRow(children: [
                    Text('E-Stelle ab: ${fz.estelleAb}', style: const TextStyle(fontSize: 13)),
                    Text('Wache an: ${fz.wacheAn}', style: const TextStyle(fontSize: 13)),
                  ]),
                if (fz.km > 0)
                  TableRow(children: [
                    Text('${fz.km} km', style: const TextStyle(fontSize: 13)),
                    Text(fz.nrEbOfw.isNotEmpty ? 'Nr. EB: ${fz.nrEbOfw}' : '', style: const TextStyle(fontSize: 13)),
                  ]),
                if (fz.einsatzZeit.isNotEmpty)
                  TableRow(children: [
                    Text('Einsatzzeit: ${fz.einsatzZeit}', style: const TextStyle(fontSize: 13)),
                    const Text('', style: TextStyle(fontSize: 13)),
                  ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
