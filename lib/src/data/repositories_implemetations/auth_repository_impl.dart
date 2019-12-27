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

class LoginWithEmailPayload extends LoginPayload {
  final String password;

  LoginWithEmailPayload(String email, this.password) : super(email);
}

class LoginWithGooglePayload extends LoginPayload {
  final String googleId;

  LoginWithGooglePayload(String email, this.googleId) : super(email);
}

class RegisterWithEmailPayload extends RegisterPayload {
  final String password;

  RegisterWithEmailPayload(String name, String email, this.password) : super(name, email);
}

class RegisterWithGooglePayload extends RegisterPayload {
  final String googleId;

  RegisterWithGooglePayload(String name, String email, this.googleId) : super(name, email);
}
