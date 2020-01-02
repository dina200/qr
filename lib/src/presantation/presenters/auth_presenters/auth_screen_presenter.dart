import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:qr/src/presantation/presenters/auth_presenters/auth_payload.dart';
import 'package:qr/src/utils/exceptions.dart';
import 'package:qr/src/utils/google.dart';

class AuthScreenPresenter with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<GooglePayload> loginWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final googleData = await getGoogleData();

      final googleAuthData = await getGoogleAuthData(googleData);

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuthData.accessToken,
        idToken: googleAuthData.idToken,
      );

      await _auth.signInWithCredential(credential);

//      final authWithCredential = await _auth.signInWithCredential(credential);
//      final FirebaseUser user = authWithCredential.user;

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

  Future<GooglePayload> getGoogleCredential() async {
    _isLoading = true;
    notifyListeners();

    try {
      final googleData = await getGoogleData();
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
