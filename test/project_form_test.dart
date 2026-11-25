import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Drawer mengganti halaman ke Add Project saat sudah login', (
    tester,
  ) async {
    await tester.pumpWidget(
      MyApp(apiClient: ApiClient(), initialToken: 'test-token'),
    );
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.byType(ProjectFormPage))).canPop(),
      isFalse,
    );
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Nashri Khalid'), findsOneWidget);
  });

  testWidgets('Validasi, POST terautentikasi, dialog, dan reset form', (
    tester,
  ) async {
    final mockClient = MockClient((request) async {
      if (request.url.path == '/api/v1/projects/' && request.method == 'POST') {
        expect(request.headers['Authorization'], 'Token test-token');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode({
            'id': '00000000-0000-0000-0000-000000000001',
            'title': body['title'],
            'description': body['description'],
            'tech_stack': body['tech_stack'],
            'project_url': body['project_url'],
            'project_image_url': body['project_image_url'] ?? '',
          }),
          201,
        );
      }
      return http.Response('Not Found', 404);
    });

    final apiClient = ApiClient(client: mockClient);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: apiClient),
          ChangeNotifierProvider(
            create: (_) => AuthState(apiClient, initialToken: 'test-token'),
          ),
        ],
        child: const MaterialApp(home: ProjectFormPage()),
      ),
    );

    final fields = find.byType(TextFormField);
    Future<void> save() async {
      await tester.ensureVisible(find.text('Save'));
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
    }

    await tester.enterText(fields.at(0), '   ');
    await save();
    expect(find.text('Title cannot be empty!'), findsOneWidget);
    expect(find.text('Description cannot be empty!'), findsOneWidget);
    expect(find.text('Tech stack cannot be empty!'), findsOneWidget);
    expect(find.text('Project URL cannot be empty!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    await tester.enterText(fields.at(0), 'Portfolio');
    await tester.enterText(fields.at(1), 'Aplikasi portofolio pribadi');
    await tester.enterText(fields.at(2), 'Flutter, Django');
    await tester.enterText(fields.at(3), 'https://example.com');
    await save();

    for (final text in [
      'Title: Portfolio',
      'Description: Aplikasi portofolio pribadi',
      'Tech Stack: Flutter, Django',
      'Project URL: https://example.com',
    ]) {
      expect(find.text(text), findsOneWidget);
    }

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    for (final field in tester.widgetList<EditableText>(
      find.byType(EditableText),
    )) {
      expect(field.controller.text, isEmpty);
    }
    expect(tester.takeException(), isNull);
  });
}
