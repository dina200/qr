import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:qr/src/data/repositories_implemetations/auth_repository_impl.dart';
import 'package:qr/src/domain/repositories_contracts/auth_repository.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/presantation/presenters/auth_presenters/auth_payload.dart';
import 'package:qr/src/utils/google_sign_in.dart';
import 'package:qr/src/utils/injector.dart';

class AuthPagePresenter with ChangeNotifier {
  final AuthRepository _authRepo;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  AuthPagePresenter() : _authRepo = injector.get<AuthRepository>();

  Future<GooglePayload> authGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final googleData = await getGoogleData();

      return _getGooglePayload(googleData);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final googleData = await getGoogleData();

      final loginPayload = LoginWithGooglePayload(
        googleData.email,
        googleData.id,
      );

      await _authRepo.loginWith(loginPayload);

      await injector.get<UserRepositoryFactory>().registerUserRepository();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  GooglePayload _getGooglePayload(GoogleSignInAccount googleData) {
    return GooglePayload(
      googleData.displayName,
      googleData.email,
      googleData.id,
    );
  }
}
