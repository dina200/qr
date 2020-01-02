import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr/src/presantation/presenters/auth_presenters/auth_payload.dart';
import 'package:qr/src/utils/exceptions.dart';

class RegistrationPagePresenter with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> register(GoogleRegistrationPayload googlePayload) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _auth.createUserWithEmailAndPassword(
        email: googlePayload.email,
        password: googlePayload.googleId,
      );
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
}
