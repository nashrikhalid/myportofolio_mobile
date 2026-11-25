import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _techStack = '';
  String _projectUrl = '';
  String _projectImageUrl = '';
  bool _isSubmitting = false;

  InputDecoration _decoration(String label, [String? hint]) {
    return InputDecoration(
      labelText: label,
      hintText: hint ?? label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
    );
  }

  bool _isValidHttpUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final loggedIn = await ensureLoggedIn(context);
    if (!mounted || !loggedIn) return;

    final authState = context.read<AuthState>();
    final token = authState.token;
    if (token == null) return;

    final newProject = Project(
      title: _title.trim(),
      description: _description.trim(),
      techStack: _techStack.trim(),
      projectUrl: _projectUrl.trim(),
      projectImageUrl: _projectImageUrl.trim(),
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      final created = await context.read<ApiClient>().createProject(
        newProject,
        token: token,
      );
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Project successfully created!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Title: ${created.title}'),
                Text('Description: ${created.description}'),
                Text('Tech Stack: ${created.techStack}'),
                Text('Project URL: ${created.projectUrl}'),
                if (created.projectImageUrl.isNotEmpty)
                  Text('Project Image URL: ${created.projectImageUrl}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _formKey.currentState!.reset();
                setState(() {
                  _title = '';
                  _description = '';
                  _techStack = '';
                  _projectUrl = '';
                  _projectImageUrl = '';
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        await authState.logout();
        if (!mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Session expired. Please log in again.'),
            ),
          );
        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('Failed to create project (HTTP ${e.statusCode}).'),
            ),
          );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Failed to create project: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project Form'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: _decoration('Title'),
                  onChanged: (value) => _title = value,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Title cannot be empty!'
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  maxLines: 5,
                  decoration: _decoration('Description'),
                  onChanged: (value) => _description = value,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Description cannot be empty!'
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: _decoration(
                    'Tech Stack',
                    'e.g. Flutter, Django, PostgreSQL',
                  ),
                  onChanged: (value) => _techStack = value,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Tech stack cannot be empty!'
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: _decoration(
                    'Project URL',
                    'https://github.com/username/project',
                  ),
                  keyboardType: TextInputType.url,
                  onChanged: (value) => _projectUrl = value,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Project URL cannot be empty!';
                    }
                    if (!_isValidHttpUrl(value)) {
                      return 'Please enter a valid http(s) URL!';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: _decoration(
                    'Project Image URL (Optional)',
                    'https://example.com/image.png',
                  ),
                  keyboardType: TextInputType.url,
                  onChanged: (value) => _projectImageUrl = value,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return null;
                    }
                    if (!_isValidHttpUrl(value)) {
                      return 'Please enter a valid http(s) URL!';
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
