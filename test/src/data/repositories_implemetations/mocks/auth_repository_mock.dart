import 'package:qr/src/domain/repositories_contracts/auth_repository.dart';

class AuthRepositoryMock extends AuthRepository {
  @override
  Future<void> loginWith(LoginPayload loginPayload) {
    // TODO: implement loginWith
    return null;
  }

  @override
  Future<void> registerWith(RegisterPayload registerPayload) {
    // TODO: implement registerWith
    return null;
  }

  @override
  Future<void> restorePassword(String email) {
    // TODO: implement restorePassword
    return null;
  }
}
