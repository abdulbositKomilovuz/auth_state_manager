import 'dart:async';

import 'package:auth_state_manager/src/auth_state_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStateManager {
  final _authStateToken = 'APP_TOKEN';

  final SharedPreferences? _preferences;

  final StreamController<bool>? _authStateController;

  AuthStateManager._(
    this._preferences,
    this._authStateController,
  );

  static AuthStateManager? _authStateInstance;

  /// Initializes state for app authentication.
  /// 1. Make sure to initialize this line on `main()` functions
  /// or on top of the root widget before using any functions
  /// of [AuthStateManager] or [AuthStateListener].
  ///
  /// 2. Make sure to add `WidgetsFlutterBinding.ensureInitialized()`
  /// before calling `AuthStateManager.initializeAuthState()`
  ///
  /// 3. Make sure to `await` when calling [AuthStateManager.initializeAuthState]
  static Future<void> initializeAuthState() async {
    if (_authStateInstance != null) return;

    final pref = await SharedPreferences.getInstance();

    _authStateInstance = AuthStateManager._(
      pref,
      StreamController<bool>.broadcast(),
    );
    Future.delayed(const Duration(milliseconds: 100), () {
      _authStateInstance!._authStateController!.sink.add(
        _authStateInstance!.isAuthenticated,
      );
    });
  }

  /// Provides possibility to listen to Auth States.
  ///
  /// This is `Stream<bool>` type where `bool` is auth state.
  ///
  /// true = authenticated.
  ///
  /// false = unauthenticated.
  Stream<bool> get authStateAsStream {
    assert(
      _authStateController != null,
      throw UnInitializedState(
        'You are trying to listen to authStateStream but it is null.',
      ),
    );

    return _authStateController!.stream;
  }

  static AuthStateManager get instance {
    assert(
        _authStateInstance != null,
        throw UnInitializedState(
            'You are trying to get instance of the AuthSate but it is null.'));
    return _authStateInstance!;
  }

  /// Sets your token to state and saves.
  Future<bool> setToken(String token) async {
    assert(
      _preferences != null && _authStateController != null,
      throw UnInitializedState(),
    );
    return _preferences!.setString(_authStateToken, token);
  }

  /// Changes to state of auth to Authenticated.
  ///
  /// `Note:` auth state cannot be changed if there is no token.
  /// use [setToken] to save your token first.
  void login() {
    assert(
      isAuthenticated,
      throw NoTokenToAuthorize(
        'To be able to authorize your app. You should use setToken() first.',
      ),
    );
    _authStateController!.sink.add(isAuthenticated);
  }

  /// Clears the state, removes all tokens and resets the state to UnAuthenticated.
  void logOut() {
    assert(
      _preferences != null && _authStateController != null,
      throw UnInitializedState(),
    );
    _preferences!.remove(_authStateToken);
    _authStateController!.sink.add(isAuthenticated);
  }

  String? get token {
    return _preferences?.getString(_authStateToken);
  }

  bool get isAuthenticated {
    return _preferences?.getString(_authStateToken)?.isNotEmpty ?? false;
  }
}
