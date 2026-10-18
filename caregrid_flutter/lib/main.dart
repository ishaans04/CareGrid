import 'package:flutter/material.dart';

import 'client.dart';
import 'src/core/app_session.dart';
import 'src/features/shell/home_shell.dart';
import 'src/features/sign_in/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  AppSession.instance.restore();
  runApp(const CareGridApp());
}

/// Default Material 3 theme. Visual design is out of scope for the prototype;
/// this is the single place a designer restyles the app.
ThemeData _buildTheme(Brightness brightness) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: brightness,
    ),
  );
}

class CareGridApp extends StatelessWidget {
  const CareGridApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareGrid',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: ListenableBuilder(
        listenable: AppSession.instance,
        builder: (context, _) {
          final session = AppSession.instance;
          if (session.restoring) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final user = session.user;
          return user == null
              ? const SignInScreen()
              : HomeShell(key: ValueKey(user.id), user: user);
        },
      ),
    );
  }
}
