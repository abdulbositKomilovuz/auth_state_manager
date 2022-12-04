import 'package:flutter/material.dart';

import 'auth_state_manager.dart';

class AuthStateListener extends StatelessWidget {
  final Widget authenticated;
  final Widget unAuthenticated;

  /// Listens and returns [authenticated] or [unAuthenticated] widgets
  /// according to [AuthStateManager.instance.isAuthenticated].
  const AuthStateListener({
    super.key,
    required this.authenticated,
    required this.unAuthenticated,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthStateManager.instance.authStateAsStream,
      builder: (context, AsyncSnapshot<bool> authStateAsync) {
        if (authStateAsync.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }
        return (authStateAsync.data ?? false) ? authenticated : unAuthenticated;
      },
    );
  }
}
