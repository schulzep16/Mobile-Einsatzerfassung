// lib/screens/einsaetze/einsaetze_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/einsatz.dart';
import 'einsatz_form_screen.dart';
import 'einsatz_detail_screen.dart';

class EinsaetzeListScreen extends StatefulWidget {
  final bool openNew;
  final int? highlightId;

  const EinsaetzeListScreen({super.key, this.openNew = false, this.highlightId});

  @override
  State<EinsaetzeListScreen> createState() => _EinsaetzeListScreenState();
}

class _EinsaetzeListScreenState extends State<EinsaetzeListScreen> {
  String _search = '';

  @override
  void initState() {
    super.initState();
    if (widget.openNew) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _newEinsatz());
    }
  }

  Future<void> _newEinsatz() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EinsatzFormScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final einsaetze = context.watch<AppProvider>().einsaetze;
    final filtered = einsaetze.where((e) {
      if (_search.isEmpty) return true;
      final s = _search.toLowerCase();
      return e.ort.toLowerCase().contains(s) ||
          e.einsatzart.toLowerCase().contains(s) ||
          e.stichwort.toLowerCase().contains(s) ||
          e.datum.contains(s) ||
          e.lfdNummer.contains(s);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Einsätze')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Suche nach Datum, Ort, Einsatzart...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_fire_department, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text('Keine Einsätze vorhanden', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _newEinsatz,
                          icon: const Icon(Icons.add),
                          label: const Text('Ersten Einsatz erfassen'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _EinsatzCard(einsatz: filtered[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _newEinsatz,
        icon: const Icon(Icons.add),
        label: const Text('Neuer Einsatz'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _EinsatzCard extends StatelessWidget {
  final Einsatz einsatz;

  const _EinsatzCard({required this.einsatz});

  Color get _artColor {
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
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EinsatzDetailScreen(einsatzId: einsatz.id!)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _artColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.local_fire_department, color: _artColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (einsatz.lfdNummer.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: _artColor.withAlpha(30),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('#${einsatz.lfdNummer}',
                                style: TextStyle(fontSize: 11, color: _artColor)),
                          ),
                        Expanded(
                          child: Text(
                            einsatz.einsatzart.isNotEmpty ? einsatz.einsatzart : 'Einsatz',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    if (einsatz.stichwort.isNotEmpty)
                      Text(einsatz.stichwort, style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            [einsatz.strasse, einsatz.ort].where((s) => s.isNotEmpty).join(', '),
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${einsatz.datum}${einsatz.alarmzeit.isNotEmpty ? '  ${einsatz.alarmzeit} Uhr' : ''}',
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
