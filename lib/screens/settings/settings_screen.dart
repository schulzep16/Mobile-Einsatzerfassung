// lib/screens/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../widgets/custom_text_field.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _feuerwehrCtrl;
  late TextEditingController _einsatzleiterCtrl;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    final p = context.read<AppProvider>();
    _feuerwehrCtrl = TextEditingController(text: p.feuerwehrName);
    _einsatzleiterCtrl = TextEditingController(text: p.standardEinsatzleiter);
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() => _appVersion = '${info.version}+${info.buildNumber}');
    });
  }

  @override
  void dispose() {
    _feuerwehrCtrl.dispose();
    _einsatzleiterCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await context.read<AppProvider>().saveSettings(
      feuerwehrName: _feuerwehrCtrl.text.trim(),
      standardEinsatzleiter: _einsatzleiterCtrl.text.trim(),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Einstellungen gespeichert'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
        actions: [
          TextButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Speichern'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SectionHeader(
              title: 'Feuerwehr',
              icon: Icons.local_fire_department,
            ),
            CustomTextField(
              label: 'Name der Feuerwehr',
              hint: 'z. B. Freiwillige Feuerwehr Beetzsee',
              controller: _feuerwehrCtrl,
              required: true,
              validator: (v) => v == null || v.isEmpty ? 'Pflichtfeld' : null,
            ),
            CustomTextField(
              label: 'Standard-Einsatzleiter',
              hint: 'z. B. Philipp Schulze',
              controller: _einsatzleiterCtrl,
            ),
            const SectionHeader(title: 'Darstellung', icon: Icons.palette),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Farbthema'),
              trailing: SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.light,
                    icon: Icon(Icons.light_mode),
                    label: Text('Hell'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.system,
                    icon: Icon(Icons.brightness_auto),
                    label: Text('Auto'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    icon: Icon(Icons.dark_mode),
                    label: Text('Dunkel'),
                  ),
                ],
                selected: {provider.themeMode},
                onSelectionChanged: (s) => provider.setThemeMode(s.first),
              ),
            ),
            const SizedBox(height: 32),
            if (_appVersion.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Version $_appVersion',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Einstellungen speichern'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
