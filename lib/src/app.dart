import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_todos/src/features/login_screen.dart';
import 'package:my_todos/src/features/todo_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    const loginKey = ValueKey('loginScreen');
    const overviewKey = ValueKey('overviewScreen');

    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          return MaterialApp(
            key: user == null ? loginKey : overviewKey,
            theme: ThemeData.from(
                colorScheme:
                    ColorScheme.fromSeed(seedColor: Colors.lightGreen)),
            themeMode: ThemeMode.light,
            home: user == null ? const LoginScreen() : const TodoScreen(),
          );
        });
  }
}
