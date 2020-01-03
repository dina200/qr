import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:qr/src/data/repositories_implemetations/auth_repository_impl.dart';
import 'package:qr/src/domain/repositories_contracts/auth_repository.dart';
import 'package:qr/src/presantation/presenters/auth_presenters/auth_payload.dart';
import 'package:qr/src/utils/google_sign_in.dart';
import 'package:qr/src/utils/injector.dart';


class AuthPagePresenter with ChangeNotifier {
  final _authRepo = injector.get<AuthRepository>();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> loginWithGoogle(GoogleSignInAccount googleData) async {
    final loginPayload = LoginWithGooglePayload(
      googleData.email,
      googleData.id,
    );
    await _authRepo.loginWith(loginPayload);
  }

  Future<GooglePayload> authGoogle([Function loginWithGoogle]) async {
    _isLoading = true;
    notifyListeners();

    try {
      final googleData = await getGoogleData();

      if (loginWithGoogle != null) {
        await loginWithGoogle(googleData);
      }

      return _getGooglePayload(googleData);
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
