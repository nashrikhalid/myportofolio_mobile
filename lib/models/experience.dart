/// Form fields mirror the editable fields of Django's Experience model.
class Experience {
  const Experience({
    required this.title,
    required this.org,
    required this.description,
    required this.category,
    required this.startedAt,
    this.endedAt,
  });

  static const categories = {
    'internship': 'Internship',
    'research': 'Research',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'freelance': 'Freelance',
  };
  final String title;
  final String org;
  final String description;
  final String category;
  final DateTime startedAt;
  final DateTime? endedAt;

  static String? validateRequired(
    String? value,
    String label, {
    int? maxLength,
  }) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '$label wajib diisi.';
    if (maxLength != null && text.runes.length > maxLength) {
      return '$label maksimal $maxLength karakter.';
    }
    return null;
  }

  static String? validateEndDate(DateTime? start, DateTime? end, bool ongoing) {
    if (ongoing) return null;
    if (end == null) return 'Tanggal selesai wajib dipilih.';
    if (start != null && end.isBefore(start)) {
      return 'Tanggal selesai tidak boleh sebelum tanggal mulai.';
    }
    return null;
  }

  static String formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';
}
