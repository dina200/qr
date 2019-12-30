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
