import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

void main() {
  testWidgets('Profil pemilik tampil dan aksi proyek/login bekerja', (
    tester,
  ) async {
    final mockClient = MockClient((request) async {
      if (request.url.path == '/api/v1/projects/' && request.method == 'GET') {
        return http.Response('[]', 200);
      }
      return http.Response('Not Found', 404);
    });

    await tester.pumpWidget(MyApp(apiClient: ApiClient(client: mockClient)));
    for (final value in ['Nashri Khalid', '2506657131', 'PBP F']) {
      expect(find.text(value), findsOneWidget);
    }

    // Lihat Proyek opens ProjectListScreen
    final lihatProyek = find.widgetWithText(ItemCard, 'Lihat Proyek');
    await tester.ensureVisible(lihatProyek);
    await tester.tap(lihatProyek);
    await tester.pumpAndSettle();
    expect(find.text('Achievements: Projects'), findsOneWidget);
    expect(find.text('No projects found.'), findsOneWidget);
    Navigator.of(tester.element(find.byType(Scaffold).last)).pop();
    await tester.pumpAndSettle();

    // Tambah Proyek redirects to LoginScreen when unauthenticated
    final tambahProyek = find.widgetWithText(ItemCard, 'Tambah Proyek');
    await tester.ensureVisible(tambahProyek);
    await tester.tap(tambahProyek);
    await tester.pumpAndSettle();
    expect(find.text('Login'), findsWidgets);
  });
}
