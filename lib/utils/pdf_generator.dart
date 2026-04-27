// lib/utils/pdf_generator.dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/einsatz.dart';

class PdfGenerator {
  static Future<void> generateAndShare(Einsatz e) async {
    final pdf = pw.Document();

    final headerColor = PdfColors.red800;
    final sectionColor = PdfColors.red100;
    final borderColor = PdfColors.grey400;

    pw.Widget section(String title, List<pw.Widget> children) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: double.infinity,
            margin: const pw.EdgeInsets.only(top: 10, bottom: 4),
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: pw.BoxDecoration(
              color: sectionColor,
              border: pw.Border(left: pw.BorderSide(color: headerColor, width: 3)),
            ),
            child: pw.Text(title,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: headerColor)),
          ),
          ...children,
        ],
      );
    }

    pw.Widget row(String label, String value, {bool bold = false}) {
      if (value.isEmpty || value == '0') return pw.SizedBox();
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 1.5),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 130,
              child: pw.Text(label, style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey700)),
            ),
            pw.Expanded(
              child: pw.Text(
                value,
                style: pw.TextStyle(
                  fontSize: 8.5,
                  fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        header: (ctx) => pw.Column(children: [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: headerColor,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('EINSATZBERICHT',
                        style: pw.TextStyle(
                            color: PdfColors.white, fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                      e.feuerwehrName.isNotEmpty ? e.feuerwehrName : 'Feuerwehr',
                      style: const pw.TextStyle(color: PdfColors.white, fontSize: 9),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    if (e.lfdNummer.isNotEmpty)
                      pw.Text('Nr. ${e.lfdNummer}',
                          style: pw.TextStyle(
                              color: PdfColors.white, fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.Text(e.datum,
                        style: const pw.TextStyle(color: PdfColors.white, fontSize: 9)),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 4),
        ]),
        build: (ctx) => [
          // ── Grunddaten ──────────────────────────────────────────────────────
          section('Grunddaten', [
            pw.Row(children: [
              pw.Expanded(child: row('Datum', '${e.datum} (${e.wochentag})')),
              pw.Expanded(child: row('Alarmzeit', '${e.alarmzeit} Uhr')),
            ]),
            if (e.einsatznummerLeitstelle.isNotEmpty)
              row('Einsatznummer Leitstelle', e.einsatznummerLeitstelle),
            pw.Row(children: [
              pw.Expanded(child: row('Einsatzbeginn', '${e.einsatzBeginn} Uhr')),
              pw.Expanded(child: row('Einsatzende', '${e.einsatzEnde} Uhr')),
            ]),
            if (e.gesamteEinsatzzeitStunden > 0 || e.gesamteEinsatzzeitMinuten > 0)
              row(
                'gesamte Einsatzzeit',
                '${e.gesamteEinsatzzeitStunden} h ${e.gesamteEinsatzzeitMinuten} min',
              ),
          ]),

          // ── Einsatzadresse ──────────────────────────────────────────────────
          section('Einsatzadresse', [
            row('Straße, Hausnummer',
                '${e.strasse} ${e.hausnummer}'.trim()),
            row('PLZ, Ort, Ortsteil',
                '${e.plz} ${e.ort}${e.ortsteil.isNotEmpty ? ", ${e.ortsteil}" : ""}'.trim()),
          ]),

          // ── Einsatzart ──────────────────────────────────────────────────────
          section('Einsatzart & Alarmierung', [
            pw.Row(children: [
              pw.Expanded(child: row('Einsatzart', e.einsatzart, bold: true)),
              pw.Expanded(child: row('Stichwort', e.stichwort)),
            ]),
            row('Meldeweg', e.meldeweg),
            pw.Row(
              children: [
                if (e.alarmLeitstelle)
                  pw.Container(
                    margin: const pw.EdgeInsets.only(right: 6),
                    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue100,
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                    ),
                    child: pw.Text('Leitstelle', style: const pw.TextStyle(fontSize: 8)),
                  ),
                if (e.alarmPolizei)
                  pw.Container(
                    margin: const pw.EdgeInsets.only(right: 6),
                    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue100,
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                    ),
                    child: pw.Text('Polizei', style: const pw.TextStyle(fontSize: 8)),
                  ),
                if (e.alarmMuendlich)
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue100,
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                    ),
                    child: pw.Text('Mündlich', style: const pw.TextStyle(fontSize: 8)),
                  ),
              ],
            ),
          ]),

          // ── Einsatzleiter ───────────────────────────────────────────────────
          section('Einsatzleiter', [
            row('Name', e.einsatzleiter, bold: true),
            if (e.einsatztagebuchPolizei.isNotEmpty)
              row('EB-Nr. Polizei', e.einsatztagebuchPolizei),
            if (e.sonstigeAnwesende.isNotEmpty)
              row('Sonstige Anwesende', e.sonstigeAnwesende),
          ]),

          // ── Fahrzeuge ───────────────────────────────────────────────────────
          if (e.fahrzeuge.isNotEmpty)
            section('Beteiligte Einsatzmittel der Feuerwehr', [
              pw.Table(
                border: pw.TableBorder.all(color: borderColor, width: 0.5),
                columnWidths: const {
                  0: pw.FlexColumnWidth(2),
                  1: pw.FlexColumnWidth(1.2),
                  2: pw.FlexColumnWidth(1.2),
                  3: pw.FlexColumnWidth(1.2),
                  4: pw.FlexColumnWidth(1.2),
                  5: pw.FlexColumnWidth(0.8),
                  6: pw.FlexColumnWidth(0.8),
                  7: pw.FlexColumnWidth(1.2),
                },
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: sectionColor),
                    children: [
                      'Fahrzeug', 'Wache ab', 'E-Stelle an', 'E-Stelle ab', 'Wache an', 'Stärke', 'km', 'Einsatzzeit'
                    ].map((h) => pw.Padding(
                      padding: const pw.EdgeInsets.all(3),
                      child: pw.Text(h,
                          style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold)),
                    )).toList(),
                  ),
                  ...e.fahrzeuge.map((fz) => pw.TableRow(
                    children: [
                      fz.kennung, fz.wacheAb, fz.estelleAn, fz.estelleAb, fz.wacheAn,
                      '${fz.staerke}', fz.km > 0 ? '${fz.km}' : '', fz.einsatzZeit,
                    ].map((v) => pw.Padding(
                      padding: const pw.EdgeInsets.all(3),
                      child: pw.Text(v, style: const pw.TextStyle(fontSize: 7.5)),
                    )).toList(),
                  )),
                ],
              ),
            ]),

          // ── Weitere Einsatzmittel ────────────────────────────────────────────
          if (e.weitereEinsatzmittel.isNotEmpty)
            section('Weitere beteiligte Einsatzmittel', [
              pw.Table(
                border: pw.TableBorder.all(color: borderColor, width: 0.5),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: sectionColor),
                    children: ['Organisation', 'Einheit', 'Stärke'].map((h) => pw.Padding(
                      padding: const pw.EdgeInsets.all(3),
                      child: pw.Text(h, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                    )).toList(),
                  ),
                  ...e.weitereEinsatzmittel.map((w) => pw.TableRow(
                    children: [w.organisation, w.einheit, '${w.staerke}'].map((v) => pw.Padding(
                      padding: const pw.EdgeInsets.all(3),
                      child: pw.Text(v, style: const pw.TextStyle(fontSize: 8)),
                    )).toList(),
                  )),
                ],
              ),
            ]),

          // ── Einsatzdetails ───────────────────────────────────────────────────
          section('Vorgefundene Lage / Einsatzmaßnahmen / -verlauf', [
            if (e.vorgefundeneLage.isNotEmpty)
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: borderColor, width: 0.5),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
                ),
                child: pw.Text(e.vorgefundeneLage, style: const pw.TextStyle(fontSize: 8.5)),
              ),
            if (e.einsatzmassnahmen.isNotEmpty) ...[
              pw.SizedBox(height: 6),
              pw.Text('Maßnahmen:',
                  style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: borderColor, width: 0.5),
                ),
                child: pw.Text(e.einsatzmassnahmen, style: const pw.TextStyle(fontSize: 8.5)),
              ),
            ],
          ]),

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
              ))
            section('Unfallbeteiligte / Geschädigte / Eigentümer', [
              if (e.eigentuemerName.isNotEmpty ||
                  e.eigentuemerStrasse.isNotEmpty ||
                  e.eigentuemerPlzWohnort.isNotEmpty ||
                  e.eigentuemerGeburtsdatum.isNotEmpty ||
                  e.eigentuemerTaetigkeiten.isNotEmpty ||
                  e.eigentuemerReanimation) ...[
                row('Eigentümer Name', e.eigentuemerName),
                row('Eigentümer Straße', e.eigentuemerStrasse),
                row('Eigentümer PLZ, Wohnort', e.eigentuemerPlzWohnort),
                row('Eigentümer Geb.-Datum', e.eigentuemerGeburtsdatum),
                row(
                  'Eigentümer Reanimation',
                  e.eigentuemerReanimation ? 'Ja' : 'Nein',
                ),
                if (e.eigentuemerTaetigkeiten.isNotEmpty)
                  row('Eigentümer Tätigkeiten', e.eigentuemerTaetigkeiten),
              ],
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
                    (u) => pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Unfallbeteiligter ${u.position}',
                          style: pw.TextStyle(
                            fontSize: 8.5,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        row('Name', u.name),
                        row('Straße', u.strasse),
                        row('PLZ, Wohnort', u.plzWohnort),
                        row('Geb.-Datum', u.geburtsdatum),
                        row('PKW-Typ', u.pkwTyp),
                        row('Kennzeichen', u.kennzeichen),
                        row('Tätigkeiten am Fahrzeug', u.taetigkeitenAmFahrzeug),
                      ],
                    ),
                  ),
            ]),

          // ── Beteiligte Kameraden ─────────────────────────────────────────────
          if (e.kameraden.isNotEmpty)
            section('Am Einsatz beteiligte Kameraden', [
              pw.Wrap(
                spacing: 6,
                runSpacing: 4,
                children: e.kameraden.map((k) => pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: borderColor, width: 0.5),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
                  ),
                  child: pw.Text(
                    '${k.kameradName ?? ""}${k.fahrzeug.isNotEmpty ? " (${k.fahrzeug})" : ""}',
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                )).toList(),
              ),
            ]),

          // ── Atemschutz ───────────────────────────────────────────────────────
          if (e.atemschutz.isNotEmpty)
            section('Atemschutzüberwachung', [
              pw.Table(
                border: pw.TableBorder.all(color: borderColor, width: 0.5),
                columnWidths: const {
                  0: pw.FlexColumnWidth(2),
                  1: pw.FlexColumnWidth(1),
                  2: pw.FlexColumnWidth(1),
                  3: pw.FlexColumnWidth(1),
                  4: pw.FlexColumnWidth(1),
                  5: pw.FlexColumnWidth(1.5),
                },
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: sectionColor),
                    children: ['Name', 'PA-Nr.', 'Druck vor', 'Druck nach', 'Dauer', 'Zustand']
                        .map((h) => pw.Padding(
                              padding: const pw.EdgeInsets.all(3),
                              child: pw.Text(h,
                                  style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold)),
                            ))
                        .toList(),
                  ),
                  ...e.atemschutz.map((a) => pw.TableRow(
                    children: [
                      a.kameradName,
                      a.paNummer,
                      '${a.druckVor} bar',
                      '${a.druckNach} bar',
                      '${a.dauer} min',
                      a.zustand,
                    ].map((v) => pw.Padding(
                      padding: const pw.EdgeInsets.all(3),
                      child: pw.Text(v, style: const pw.TextStyle(fontSize: 7.5)),
                    )).toList(),
                  )),
                ],
              ),
            ]),

          // ── Material & Verbrauch ─────────────────────────────────────────────
          section('Material & Verbrauch', [
            pw.Row(children: [
              pw.Expanded(child: row('Wasserentnahme', e.wasserentnahme)),
              pw.Expanded(child: row('Schaum', '${e.schaumBildner} ${e.schaumMenge > 0 ? "${e.schaumMenge} kg" : ""}'.trim())),
            ]),
            pw.Row(children: [
              pw.Expanded(child: row('Schaum in Liter ca.', e.schaumLiterCa > 0 ? '${e.schaumLiterCa}' : '')),
              pw.Expanded(child: row('Löschmittelauswurfgeräte C', e.loeschmittelAuswurfgeraetC > 0 ? '${e.loeschmittelAuswurfgeraetC}' : '')),
              pw.Expanded(child: row('Löschmittelauswurfgeräte B', e.loeschmittelAuswurfgeraetB > 0 ? '${e.loeschmittelAuswurfgeraetB}' : '')),
            ]),
            pw.Row(children: [
              pw.Expanded(child: row('PA 200 bar', e.atemschutzPa200 > 0 ? '${e.atemschutzPa200}' : '')),
              pw.Expanded(child: row('PA 300 bar', e.atemschutzPa300 > 0 ? '${e.atemschutzPa300}' : '')),
              pw.Expanded(child: row('Reserve Aufgabenträger', e.atemschutzReserveAufgabentraeger > 0 ? '${e.atemschutzReserveAufgabentraeger}' : '')),
            ]),
            pw.Row(children: [
              pw.Expanded(child: row('Reserve FTZ', e.atemschutzReserveFtz > 0 ? '${e.atemschutzReserveFtz}' : '')),
              pw.Expanded(child: row('Reserve gesamt', e.atemschutzReserve > 0 ? '${e.atemschutzReserve}' : '')),
              pw.Expanded(child: row('', '')),
            ]),
            pw.Row(children: [
              pw.Expanded(child: row('Ölbinder Land', e.oelbinderLand > 0 ? '${e.oelbinderLand} kg' : '')),
              pw.Expanded(child: row('Ölbinder Wasser', e.oelbinderWasser > 0 ? '${e.oelbinderWasser} kg' : '')),
            ]),
            if (e.oelbinderLandTyp.isNotEmpty) row('Ölbinder Land Typ', e.oelbinderLandTyp),
            if (e.oelbinderLandEntsorgungMit || e.oelbinderLandEntsorgungOhne)
              row('Ölbinder Land Entsorgung', e.oelbinderLandEntsorgungMit ? 'mit' : 'ohne'),
            if (e.oelbinderWasserTyp.isNotEmpty) row('Ölbinder Wasser Typ', e.oelbinderWasserTyp),
            if (e.oelbinderWasserEntsorgungMit || e.oelbinderWasserEntsorgungOhne)
              row('Ölbinder Wasser Entsorgung', e.oelbinderWasserEntsorgungMit ? 'mit' : 'ohne'),
            if (e.oelbinderEntsorgung.isNotEmpty) row('Entsorgung (Legacy)', e.oelbinderEntsorgung),
            if (e.handfeuerloecherTyp.isNotEmpty) row('Handfeuerlöscher Typ', e.handfeuerloecherTyp),
            if (e.handfeuerloecher > 0) row('Handfeuerlöscher', '${e.handfeuerloecher}'),
            if (e.handfeuerloecherEntsorgungMit || e.handfeuerloecherEntsorgungOhne)
              row('Handfeuerlöscher Entsorgung', e.handfeuerloecherEntsorgungMit ? 'mit' : 'ohne'),
            if (e.besondereGeraete.isNotEmpty) row('Besondere Geräte', e.besondereGeraete),
          ]),

          // ── Nachbereitung ────────────────────────────────────────────────────
          section('Nachbereitung', [
            pw.Row(children: [
              pw.Expanded(child: row('Nachsorge (§35 BbgBKG)', e.nachsorge ? 'Ja' : 'Nein')),
              pw.Expanded(child: row('Übergabeprotokoll', e.uebergabeprotokoll ? 'Ja' : 'Nein')),
            ]),
            if (e.einsatzstelleUebergebenAn.isNotEmpty)
              row('Einsatzstelle übergeben an', e.einsatzstelleUebergebenAn),
            if (e.kostenersatzVorschlag.isNotEmpty)
              row('Vorschlag auf Kostenersatz', e.kostenersatzVorschlag),
            if (e.nachsorge && e.nachsorgeBeschreibung.isNotEmpty)
              row('Nachsorge-Beschreibung', e.nachsorgeBeschreibung),
          ]),

          if (e.bemerkung.isNotEmpty)
            section('Bemerkung', [
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: borderColor, width: 0.5),
                ),
                child: pw.Text(e.bemerkung, style: const pw.TextStyle(fontSize: 8.5)),
              ),
            ]),

          // ── Unterschrift ─────────────────────────────────────────────────────
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '${e.ortBericht}, ${e.datumBericht}',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Container(width: 200, height: 0.5, color: PdfColors.black),
                  pw.SizedBox(height: 2),
                  pw.Text('Ort, Datum', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 20),
                  pw.Container(width: 200, height: 0.5, color: PdfColors.black),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    'Unterschrift (${e.unterschrift})',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Einsatzbericht_${e.lfdNummer.isNotEmpty ? e.lfdNummer : e.datum.replaceAll('.', '-')}.pdf',
    );
  }
}
