import 'dart:async';

import 'package:auth_state_manager/auth_state_manager.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthStateManager.initializeAuthState();
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final StreamSubscription _authStateSub;

  @override
  void initState() {
    super.initState();
    _authStateSub = AuthStateManager.instance.authStateAsStream.listen((state) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('isAuthenticated: $state'),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _authStateSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return const AuthStateListener(
      authenticated: MainScreen(),
      unAuthenticated: LoginScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth State Manager'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Authenticated',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                AuthStateManager.instance.logOut();
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth State Manager'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'UnAuthenticated',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final bool isSuccessful =
                    await AuthStateManager.instance.setToken('MyToken');
                if (isSuccessful) {
                  AuthStateManager.instance.login();
                }
              },
              child: const Text(
                'Log in',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
