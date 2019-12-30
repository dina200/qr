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
