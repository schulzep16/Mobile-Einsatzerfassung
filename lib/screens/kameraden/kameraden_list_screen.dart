// lib/screens/kameraden/kameraden_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/kamerad.dart';
import 'kamerad_form_screen.dart';
import 'kamerad_detail_screen.dart';

class KameradenListScreen extends StatefulWidget {
  const KameradenListScreen({super.key});

  @override
  State<KameradenListScreen> createState() => _KameradenListScreenState();
}

class _KameradenListScreenState extends State<KameradenListScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final all = provider.kameraden;
    final filtered = all.where((k) {
      if (_search.isNotEmpty) {
        final s = _search.toLowerCase();
        return k.vorname.toLowerCase().contains(s) ||
            k.nachname.toLowerCase().contains(s);
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Kameraden')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Suche nach Name...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${filtered.length} Kameraden',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('Keine Kameraden gefunden'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _KameradTile(kamerad: filtered[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const KameradFormScreen()),
        ),
        icon: const Icon(Icons.person_add),
        label: const Text('Kamerad hinzufügen'),
      ),
    );
  }
}

class _KameradTile extends StatelessWidget {
  final Kamerad kamerad;

  const _KameradTile({required this.kamerad});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withAlpha(30),
          child: Text(
            kamerad.vorname.isNotEmpty ? kamerad.vorname[0].toUpperCase() : '?',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
        title: Text(
          '${kamerad.nachname}, ${kamerad.vorname}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => KameradDetailScreen(kamerad: kamerad),
          ),
        ),
      ),
    );
  }
}
