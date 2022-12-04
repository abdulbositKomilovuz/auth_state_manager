class UnInitializedState implements Exception {
  final String? message;

  UnInitializedState([this.message]) : super();

  @override
  String toString() {
    return 'UnInitializedState: $message ${ErrorSuffixes.unInitialized}';
  }
}

class NoTokenToAuthorize implements Exception {
  final String? message;

  NoTokenToAuthorize([this.message]) : super();

  @override
  String toString() {
    return 'NoTokenToAuthorize: $message';
  }
}

class ErrorSuffixes {
  static const unInitialized =
      'This error occurs when you forget to add AuthState.initializeAuthState() in you root widget.';
}
