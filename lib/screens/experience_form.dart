import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _org = TextEditingController();
  final _description = TextEditingController();
  final _startText = TextEditingController();
  final _endText = TextEditingController();
  String _category = 'full-time';
  DateTime? _start;
  DateTime? _end;
  bool _ongoing = true;

  @override
  void dispose() {
    for (final controller in [
      _title,
      _org,
      _description,
      _startText,
      _endText,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  InputDecoration _decoration(String label, {IconData? icon}) =>
      InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: icon == null ? null : Icon(icon),
        errorMaxLines: 3,
      );

  Future<void> _pickDate({required bool isStart}) async {
    FocusScope.of(context).unfocus();
    final date = await showDatePicker(
      context: context,
      initialDate: (isStart ? _start : _end) ?? _start ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100, 12, 31),
      helpText: isStart ? 'Tanggal mulai' : 'Tanggal selesai',
    );
    if (!mounted || date == null) return;
    setState(() {
      if (isStart) {
        _start = date;
        _startText.text = Experience.formatDate(date);
      } else {
        _end = date;
        _endText.text = Experience.formatDate(date);
      }
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final experience = Experience(
      title: _title.text.trim(),
      org: _org.text.trim(),
      description: _description.text.trim(),
      category: _category,
      startedAt: _start!,
      endedAt: _ongoing ? null : _end,
    );
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ringkasan Pengalaman'),
        scrollable: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jabatan: ${experience.title}'),
            const SizedBox(height: 8),
            Text('Organisasi: ${experience.org}'),
            const SizedBox(height: 8),
            Text('Deskripsi: ${experience.description}'),
            const SizedBox(height: 8),
            Text('Kategori: ${Experience.categories[experience.category]}'),
            const SizedBox(height: 8),
            Text(
              'Tanggal mulai: ${Experience.formatDate(experience.startedAt)}',
            ),
            const SizedBox(height: 8),
            Text(
              'Tanggal selesai: ${experience.endedAt == null ? 'Belum selesai' : Experience.formatDate(experience.endedAt!)}',
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${experience.endedAt == null ? 'Masih berlangsung' : 'Selesai'}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pengalaman'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Ceritakan pengalamanmu',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Isi pengalaman kerja, riset, atau kegiatan relawan. '
                  'Simpan akan menampilkan ringkasan; data belum dikirim ke server.',
                ),
                const SizedBox(height: 24),
                TextFormField(
                  key: const Key('experience-title'),
                  controller: _title,
                  decoration: _decoration('Jabatan / Peran'),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (value) => Experience.validateRequired(
                    value,
                    'Jabatan',
                    maxLength: 255,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('experience-org'),
                  controller: _org,
                  decoration: _decoration('Organisasi'),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (value) => Experience.validateRequired(
                    value,
                    'Organisasi',
                    maxLength: 255,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('experience-description'),
                  controller: _description,
                  decoration: _decoration('Deskripsi'),
                  minLines: 3,
                  maxLines: 6,
                  keyboardType: TextInputType.multiline,
                  validator: (value) =>
                      Experience.validateRequired(value, 'Deskripsi'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  key: const Key('experience-category'),
                  initialValue: _category,
                  isExpanded: true,
                  decoration: _decoration('Kategori'),
                  items: Experience.categories.entries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _category = value);
                  },
                  validator: (value) => Experience.categories.containsKey(value)
                      ? null
                      : 'Pilih kategori yang tersedia.',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('experience-start'),
                  controller: _startText,
                  decoration: _decoration(
                    'Tanggal mulai',
                    icon: Icons.calendar_month,
                  ),
                  readOnly: true,
                  onTap: () => _pickDate(isStart: true),
                  validator: (_) =>
                      _start == null ? 'Tanggal mulai wajib dipilih.' : null,
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Masih berlangsung'),
                  value: _ongoing,
                  onChanged: (value) => setState(() {
                    _ongoing = value;
                    if (value) {
                      _end = null;
                      _endText.clear();
                    }
                  }),
                ),
                if (!_ongoing) ...[
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('experience-end'),
                    controller: _endText,
                    decoration: _decoration(
                      'Tanggal selesai',
                      icon: Icons.calendar_month,
                    ),
                    readOnly: true,
                    onTap: () => _pickDate(isStart: false),
                    validator: (_) =>
                        Experience.validateEndDate(_start, _end, _ongoing),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check),
                  label: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
