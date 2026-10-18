import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/material.dart';

import '../../../client.dart';
import '../../core/actions.dart';
import '../../core/app_session.dart';
import '../../widgets/section.dart';

/// Demo sign-in: pick a seeded account (one per role) or type handle + PIN.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late Future<List<DemoAccount>> _accounts;
  final _handle = TextEditingController();
  final _pin = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _accounts = client.account.demoAccounts();
  }

  Future<void> _signIn(String handle, String pin) async {
    setState(() => _busy = true);
    await runAction(context, () => AppSession.instance.signIn(handle, pin));
    if (mounted) setState(() => _busy = false);
  }

  IconData _icon(UserRole role) => switch (role) {
    UserRole.command => Icons.space_dashboard_outlined,
    UserRole.medical => Icons.local_hospital_outlined,
    UserRole.responder => Icons.directions_run,
    UserRole.admin => Icons.admin_panel_settings_outlined,
    UserRole.member => Icons.sos_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CareGrid · sign in')),
      body: PageBody(
        maxWidth: 760,
        children: [
          Text(
            'AI emergency response operating system',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          const Text(
            'Prototype with seeded data. Each account opens the console for '
            'its role. Open two browser windows (e.g. command + responder) '
            'to watch one incident move through every role live.',
          ),
          const SizedBox(height: 16),
          Section(
            title: 'Demo accounts',
            child: FutureBuilder<List<DemoAccount>>(
              future: _accounts,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    'Server unreachable: ${describeError(snapshot.error!)}',
                  );
                }
                final accounts = snapshot.data;
                if (accounts == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  children: [
                    for (final a in accounts)
                      Card(
                        child: ListTile(
                          leading: Icon(_icon(a.role)),
                          title: Text('${a.displayName} · ${a.role.label}'),
                          subtitle: Text(
                            '${a.title}\n${a.description}\n'
                            'Handle ${a.handle} · PIN ${a.pinHint}',
                          ),
                          isThreeLine: true,
                          trailing: const Icon(Icons.login),
                          enabled: !_busy,
                          onTap: () => _signIn(a.handle, a.pinHint),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Section(
            title: 'Manual sign-in',
            child: Column(
              children: [
                TextField(
                  controller: _handle,
                  decoration: const InputDecoration(labelText: 'Handle'),
                ),
                TextField(
                  controller: _pin,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'PIN'),
                  onSubmitted: (_) => _signIn(_handle.text, _pin.text),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: _busy
                        ? null
                        : () => _signIn(_handle.text, _pin.text),
                    child: const Text('Sign in'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
