// lib/screens/fahrzeuge/fahrzeuge_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/fahrzeug.dart';

class FahrzeugeListScreen extends StatelessWidget {
  const FahrzeugeListScreen({super.key});

  Future<void> _showForm(BuildContext context, {Fahrzeug? fahrzeug}) async {
    final kennungCtrl = TextEditingController(text: fahrzeug?.kennung ?? '');
    final bezeichCtrl = TextEditingController(
      text: fahrzeug?.bezeichnung ?? '',
    );
    final kennzeichenCtrl = TextEditingController(
      text: fahrzeug?.kennzeichen ?? '',
    );

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: Text(
            fahrzeug == null ? 'Neues Fahrzeug' : 'Fahrzeug bearbeiten',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: kennungCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Funkrufname *',
                    hintText: 'z.B. Florian 1/44/1',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: bezeichCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Bezeichnung',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: kennzeichenCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Kennzeichen',
                    border: OutlineInputBorder(),
                  ),
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
              onPressed: () async {
                if (kennungCtrl.text.trim().isEmpty) return;
                final provider = context.read<AppProvider>();
                final f = Fahrzeug(
                  id: fahrzeug?.id,
                  kennung: kennungCtrl.text.trim(),
                  bezeichnung: bezeichCtrl.text.trim(),
                  kennzeichen: kennzeichenCtrl.text.trim(),
                );
                if (fahrzeug == null) {
                  await provider.addFahrzeug(f);
                } else {
                  await provider.updateFahrzeug(f);
                }
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Speichern'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fahrzeuge = context.watch<AppProvider>().fahrzeuge;

    return Scaffold(
      appBar: AppBar(title: const Text('Fahrzeuge')),
      body: fahrzeuge.isEmpty
          ? const Center(child: Text('Keine Fahrzeuge vorhanden'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: fahrzeuge.length,
              itemBuilder: (_, i) {
                final f = fahrzeuge[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange.withAlpha(30),
                      child: const Icon(Icons.fire_truck, color: Colors.orange),
                    ),
                    title: Text(
                      f.kennung,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (f.bezeichnung.isNotEmpty) Text(f.bezeichnung),
                        if (f.kennzeichen.isNotEmpty)
                          Text(
                            f.kennzeichen,
                            style: const TextStyle(color: Colors.grey),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _showForm(context, fahrzeug: f),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            final appProvider = context.read<AppProvider>();
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Fahrzeug löschen'),
                                content: Text('${f.kennung} wirklich löschen?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Abbrechen'),
                                  ),
                                  FilledButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text('Löschen'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await appProvider.deleteFahrzeug(
                                f.id!,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Fahrzeug hinzufügen'),
      ),
    );
  }
}
