import 'package:qr/src/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> loginWith(LoginPayload loginPayload);

  Future<User> registerWith(RegisterPayload registerPayload);

  Future<void> restorePassword(String email);
}

abstract class LoginPayload {
  final String email;

  LoginPayload(this.email);
}

abstract class RegisterPayload {
  final String name;
  final String email;
  final String position;
  final String phone;

  RegisterPayload(this.name, this.email, this.position, this.phone);
}