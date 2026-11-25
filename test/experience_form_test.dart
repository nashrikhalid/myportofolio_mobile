import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

void main() {
  test('Batas panjang, spasi, dan urutan tanggal', () {
    expect(Experience.validateRequired('   ', 'Jabatan'), isNotNull);
    expect(
      Experience.validateRequired('a' * 255, 'Jabatan', maxLength: 255),
      isNull,
    );
    expect(
      Experience.validateRequired('a' * 256, 'Jabatan', maxLength: 255),
      isNotNull,
    );
    expect(
      Experience.validateEndDate(
        DateTime(2026, 5, 2),
        DateTime(2026, 5, 1),
        false,
      ),
      isNotNull,
    );
    expect(
      Experience.validateEndDate(
        DateTime(2026, 5, 2),
        DateTime(2026, 5, 2),
        false,
      ),
      isNull,
    );
    expect(Experience.validateEndDate(DateTime(2026), null, false), isNotNull);
    expect(Experience.validateEndDate(DateTime(2026), null, true), isNull);
  });

  testWidgets('Kartu push, kembali, drawer, dan Home pada layar ponsel', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));
    final card = find.widgetWithText(ItemCard, 'Tambah Pengalaman');
    await tester.ensureVisible(card);
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.byType(ExperienceFormPage), findsOneWidget);
    final navigator = Navigator.of(
      tester.element(find.byType(ExperienceFormPage)),
    );
    expect(navigator.canPop(), isTrue);
    navigator.pop();
    await tester.pumpAndSettle();
    expect(find.text('Nashri Khalid'), findsOneWidget);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Tambah Pengalaman'));
    await tester.pumpAndSettle();
    expect(find.byType(ExperienceFormPage), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.byType(ExperienceFormPage))).canPop(),
      isFalse,
    );
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.text('Add Project'), findsOneWidget);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Nashri Khalid'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Form menolak input invalid dan menampilkan semua isian terbaru',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const MaterialApp(home: ExperienceFormPage()));
      Finder field(String name) => find.byKey(Key('experience-$name'));
      Future<void> save() async {
        await tester.ensureVisible(find.text('Simpan'));
        await tester.tap(find.text('Simpan'));
        await tester.pumpAndSettle();
      }

      Future<void> date(String name, String input) async {
        await tester.ensureVisible(field(name));
        await tester.tap(field(name));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.edit_outlined));
        await tester.pumpAndSettle();
        final inputField = find.descendant(
          of: find.byType(DatePickerDialog),
          matching: find.byType(TextField),
        );
        await tester.enterText(inputField, input);
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
      }

      await tester.enterText(field('title'), '   ');
      await save();
      expect(find.text('Jabatan wajib diisi.'), findsOneWidget);
      expect(find.text('Organisasi wajib diisi.'), findsOneWidget);
      expect(find.text('Deskripsi wajib diisi.'), findsOneWidget);
      expect(find.text('Tanggal mulai wajib dipilih.'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
      await tester.enterText(field('title'), 'a' * 256);
      await tester.enterText(field('org'), 'b' * 256);
      await save();
      expect(find.text('Jabatan maksimal 255 karakter.'), findsOneWidget);
      expect(find.text('Organisasi maksimal 255 karakter.'), findsOneWidget);
      await tester.enterText(field('title'), '  Mobile Developer  ');
      await tester.enterText(field('org'), 'Organisasi Contoh');
      await tester.enterText(
        field('description'),
        'Membangun aplikasi Flutter.',
      );
      await tester.ensureVisible(field('category'));
      await tester.tap(field('category'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Internship').last);
      await tester.pumpAndSettle();
      await date('start', '05/02/2026');
      await tester.ensureVisible(find.byType(SwitchListTile));
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      await save();
      expect(find.text('Tanggal selesai wajib dipilih.'), findsOneWidget);
      await date('end', '05/01/2026');
      await save();
      expect(
        find.text('Tanggal selesai tidak boleh sebelum tanggal mulai.'),
        findsOneWidget,
      );
      expect(find.byType(AlertDialog), findsNothing);
      await date('end', '05/03/2026');
      await save();
      for (final value in [
        'Jabatan: Mobile Developer',
        'Organisasi: Organisasi Contoh',
        'Deskripsi: Membangun aplikasi Flutter.',
        'Kategori: Internship',
        'Tanggal mulai: 02/05/2026',
        'Tanggal selesai: 03/05/2026',
        'Status: Selesai',
      ]) {
        expect(find.text(value), findsOneWidget);
      }
      await tester.tap(find.text('Tutup'));
      await tester.pumpAndSettle();
      expect(find.byType(ExperienceFormPage), findsOneWidget);
      await tester.enterText(field('title'), 'Judul baru');
      await tester.ensureVisible(find.byType(SwitchListTile));
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpAndSettle();
      await save();
      expect(find.text('Jabatan: Judul baru'), findsOneWidget);
      expect(find.text('Status: Masih berlangsung'), findsOneWidget);
      expect(find.text('Tanggal selesai: Belum selesai'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
