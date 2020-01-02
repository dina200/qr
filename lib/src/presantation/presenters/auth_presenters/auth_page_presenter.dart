import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:qr/src/presantation/presenters/auth_presenters/auth_payload.dart';
import 'package:qr/src/utils/exceptions.dart';
import 'package:qr/src/utils/google.dart';

class AuthPagePresenter with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> loginWithGoogle(GoogleSignInAccount googleData) async {
    await _auth.signInWithEmailAndPassword(
      email: googleData.email,
      password: googleData.id,
    );
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
    } on StateError catch (e) {
      throw QrStateException(e.message);
    } on PlatformException catch (e) {
      throw QrPlatformException(e.code);
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
