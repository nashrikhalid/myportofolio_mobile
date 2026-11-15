import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/menu.dart';

void main() {
  testWidgets('Profil pemilik dan setiap aksi tampil dengan benar', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    for (final value in ['Nashri Khalid', '2506657131', 'PBP F']) {
      expect(find.text(value), findsOneWidget);
    }

    final colors = <Color?>{};
    for (final label in ['Lihat Proyek', 'Tambah Proyek', 'Logout']) {
      final card = find.widgetWithText(ItemCard, label);
      final surface = find.descendant(
        of: card,
        matching: find.byType(Material),
      );
      colors.add(tester.widget<Material>(surface).color);
      await tester.ensureVisible(card);
      await tester.tap(card);
      await tester.pumpAndSettle();
      expect(find.text('Kamu telah menekan tombol $label!'), findsOneWidget);
    }
    expect(colors.length, 3);
  });
}
