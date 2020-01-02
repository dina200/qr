import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/domain/repositories_contracts/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User> loginWith(LoginPayload loginPayload) {
    // TODO: implement loginWith
    return null;
  }

  @override
  Future<User> registerWith(RegisterPayload registerPayload) {
    // TODO: implement registerWith
    return null;
  }

  @override
  Future<void> restorePassword(String email) {
    // TODO: implement restorePassword
    return null;
  }
}

class LoginWithGooglePayload extends LoginPayload {
  final String googleId;

  LoginWithGooglePayload(String email, this.googleId) : super(email);
}

class RegisterWithGooglePayload extends RegisterPayload {
  final String googleId;

  RegisterWithGooglePayload(
      String name, String email, String position, String phone, this.googleId)
      : super(
          name,
          email,
          position,
          phone,
        );
}
