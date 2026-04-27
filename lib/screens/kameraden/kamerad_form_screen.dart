// lib/screens/kameraden/kamerad_form_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/kamerad.dart';
import '../../widgets/custom_text_field.dart';

class KameradFormScreen extends StatefulWidget {
  final Kamerad? kamerad;

  const KameradFormScreen({super.key, this.kamerad});

  @override
  State<KameradFormScreen> createState() => _KameradFormScreenState();
}

class _KameradFormScreenState extends State<KameradFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _vornameCtrl;
  late TextEditingController _nachnameCtrl;
  bool _saving = false;

  bool get isEdit => widget.kamerad != null;

  @override
  void initState() {
    super.initState();
    final k = widget.kamerad;
    _vornameCtrl = TextEditingController(text: k?.vorname ?? '');
    _nachnameCtrl = TextEditingController(text: k?.nachname ?? '');
  }

  @override
  void dispose() {
    _vornameCtrl.dispose();
    _nachnameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final provider = context.read<AppProvider>();
    final k = Kamerad(
      id: widget.kamerad?.id,
      vorname: _vornameCtrl.text.trim(),
      nachname: _nachnameCtrl.text.trim(),
    );
    if (isEdit) {
      await provider.updateKamerad(k);
    } else {
      await provider.addKamerad(k);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Kamerad bearbeiten' : 'Neuer Kamerad'),
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SectionHeader(title: 'Persönliche Daten', icon: Icons.person),
            CustomTextField(
              label: 'Vorname',
              controller: _vornameCtrl,
              required: true,
              validator: (v) => v == null || v.isEmpty ? 'Pflichtfeld' : null,
            ),
            CustomTextField(
              label: 'Nachname',
              controller: _nachnameCtrl,
              required: true,
              validator: (v) => v == null || v.isEmpty ? 'Pflichtfeld' : null,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.save),
              label: Text(
                isEdit ? 'Änderungen speichern' : 'Kamerad speichern',
              ),
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
