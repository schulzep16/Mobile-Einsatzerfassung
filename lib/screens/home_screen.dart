// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'kameraden/kameraden_list_screen.dart';
import 'fahrzeuge/fahrzeuge_list_screen.dart';
import 'einsaetze/einsaetze_list_screen.dart';
import 'einsaetze/einsatz_form_screen.dart';
import 'settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/Logo.png',
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Einsatzdokumentation',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (provider.feuerwehrName.isNotEmpty)
                  Text(
                    provider.feuerwehrName,
                    style: const TextStyle(fontSize: 13),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              provider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : provider.themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.brightness_auto,
            ),
            tooltip: 'Thema wechseln',
            onPressed: () {
              final next = provider.themeMode == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark;
              provider.setThemeMode(next);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Einstellungen',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stats row
          Row(
            children: [
              _StatCard(
                label: 'Einsätze',
                value: '${provider.einsaetze.length}',
                icon: Icons.local_fire_department,
                color: Colors.red,
              ),
              const SizedBox(width: 12),
              _StatCard(
                label: 'Kameraden',
                value: '${provider.aktiveKameraden.length}',
                icon: Icons.people,
                color: Colors.blue,
              ),
              const SizedBox(width: 12),
              _StatCard(
                label: 'Fahrzeuge',
                value: '${provider.aktiveFahrzeuge.length}',
                icon: Icons.fire_truck,
                color: Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Primary action
          _MenuCard(
            title: 'Neuer Einsatz',
            subtitle: 'Einsatzbericht erfassen',
            icon: Icons.add_circle,
            color: Colors.red.shade700,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EinsatzFormScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _MenuCard(
            title: 'Einsätze',
            subtitle: '${provider.einsaetze.length} Einsätze gespeichert',
            icon: Icons.local_fire_department,
            color: Colors.red,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EinsaetzeListScreen()),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MenuCard(
                  title: 'Kameraden',
                  subtitle: '${provider.kameraden.length} erfasst',
                  icon: Icons.people,
                  color: Colors.blue,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const KameradenListScreen(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MenuCard(
                  title: 'Fahrzeuge',
                  subtitle: '${provider.fahrzeuge.length} erfasst',
                  icon: Icons.fire_truck,
                  color: Colors.orange,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FahrzeugeListScreen(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Recent Einsätze
          if (provider.einsaetze.isNotEmpty) ...[
            Text(
              'Letzte Einsätze',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...provider.einsaetze.take(5).map((e) => _EinsatzTile(einsatz: e)),
          ] else
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Column(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      size: 64,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Noch keine Einsätze erfasst',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EinsatzFormScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text('Ersten Einsatz erfassen'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(80)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(label, style: TextStyle(fontSize: 11, color: color)),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}

class _EinsatzTile extends StatelessWidget {
  final dynamic einsatz;

  const _EinsatzTile({required this.einsatz});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red.withAlpha(30),
          child: const Icon(Icons.local_fire_department, color: Colors.red),
        ),
        title: Text(
          '${einsatz.einsatzart.isNotEmpty ? einsatz.einsatzart : "Einsatz"}${einsatz.ort.isNotEmpty ? " – ${einsatz.ort}" : ""}',
        ),
        subtitle: Text(einsatz.datum),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EinsaetzeListScreen(highlightId: einsatz.id),
          ),
        ),
      ),
    );
  }
}
