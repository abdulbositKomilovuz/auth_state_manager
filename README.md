# Auth State Manager
Auth state manager helps you to monitor auth changes in your app. This package is suitable if you use HTTP requests in your app and you require access-tokens for APIs. The package will save the access-token to shared preferences and returns it when you need.

## Installation 
1. Add the latest version of package to your pubspec.yaml (and run`dart pub get`):
```yaml
dependencies:
  auth_state_manager: ^0.1.1
```

2. Import the package in `main.dart`
```dart
import 'package:auth_state_manager/auth_state_manager.dart';
```

3. Initialize `AuthStateManager`. 
    -   Make sure to add `async` to `main()` function.
    -   Make sure to initialize `FlutterBinding` by  `WidgetsFlutterBinding.ensureInitialized();`
    - Make sure `await` `AuthStateManager` initialization. 
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthStateManager.initializeAuthState();
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}
```

## Usage

1. Wrap your root widget with `AuthStateListener` and provide widgets for both `authenticated` and `unAuthenticated` states. This will help you to control authentication flow of your app. If you did not authorize yet `AuthStateListener` returns `unAuthenticated` widget, if you logged in before it returns `authenticated`. 
```dart
@override
  Widget build(BuildContext context) {
    return const AuthStateListener(
      authenticated: MainScreen(),
      unAuthenticated: LoginScreen(),
    );
  }
```

<br>
<br>

2. Save your access-token to `AuthState` by 
```dart
await AuthStateManager.instance.setToken('MyToken');
```
`setToken()` is `async` so make sure to `await` it. Note that saving your token will not trigger Auth State Change. To change the Auth State you should use `login()` function.
```dart
final bool isSuccessful =
    await AuthStateManager.instance.setToken('MyToken');
if (isSuccessful) {
    AuthStateManager.instance.login();
}
```

<br>
<br>

3. Delete access-token and signOut by
```dart
AuthStateManager.instance.logOut();
```
`logOut()` function will delete access-token and trigger Auth State Change.

<br>
<br>

4. Listen to auth status changes by 
```dart 
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
```

`AuthStateManager.instance.authStateAsStream` returns `Stream<bool>` which you can listen to.

## Example
Check out to github repository `/example` for more information.
