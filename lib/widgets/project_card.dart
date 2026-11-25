import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  const ItemCard(this.item, {super.key});

  final ItemHomepage item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          final messenger = ScaffoldMessenger.of(context);
          if (item.name == 'Lihat Proyek') {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const ProjectListScreen(),
              ),
            );
          } else if (item.name == 'Tambah Proyek') {
            final loggedIn = await ensureLoggedIn(context);
            if (!context.mounted || !loggedIn) return;
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const ProjectFormPage(),
              ),
            );
          } else if (item.name == 'Tambah Pengalaman') {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const ExperienceFormPage(),
              ),
            );
          } else if (item.name == 'Logout') {
            final authState = context.read<AuthState>();
            if (authState.isLoggedIn) {
              await authState.logout();
              if (!context.mounted) return;
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Berhasil logout!')),
                );
            } else {
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Kamu belum login.')),
                );
            }
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: Colors.white, size: 30),
            const SizedBox(height: 6),
            Text(
              item.name,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
