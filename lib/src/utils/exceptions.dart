class WrongEmailOrPasswordException implements Exception {
  @override
  String toString() {
    return 'Wrong email or рassword';
  }
}

class UserIsAlreadyRegisteredException implements Exception {
  @override
  String toString() {
    return 'User is already registered';
  }
}

class GoogleLoginException implements Exception {
  @override
  String toString() {
    return 'Google login exception';
  }
}

class QrPlatformException implements Exception {
  final String code;

  QrPlatformException(this.code);

  @override
  String toString() {
    return 'QrPlatformException: $code';
  }
}

class QrStateException implements Exception {
  final String message;

  QrStateException(this.message);

  @override
  String toString() {
    return 'QrStateException: $message';
  }
}
