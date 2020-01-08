import 'package:flutter/material.dart';

import 'package:qr/src/data/repositories_implemetations/auth_repository_impl.dart';
import 'package:qr/src/data/repositories_implemetations/user_repository_impl.dart';
import 'package:qr/src/domain/repositories_contracts/auth_repository.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/presantation/presenters/auth_presenters/auth_payload.dart';
import 'package:qr/src/utils/injector.dart';

class RegistrationPagePresenter with ChangeNotifier {
  final _authRepo = injector.get<AuthRepository>();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> register(GoogleRegistrationPayload googlePayload) async {
    _isLoading = true;
    notifyListeners();

    try {
      final registerPayload = RegisterWithGooglePayload(
        googlePayload.name,
        googlePayload.email,
        googlePayload.position,
        googlePayload.phone,
        googlePayload.googleId,
      );

      await _authRepo.registerWith(registerPayload);
      injector.register<UserRepository>(UserRepositoryFirestoreImpl());
      await injector.get<UserRepository>().init();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
