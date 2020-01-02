import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr/src/data/models/user_model.dart';
import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/presantation/presenters/auth_presenters/auth_payload.dart';
import 'package:qr/src/utils/exceptions.dart';
import 'package:qr/src/utils/firebase_endpoints.dart' as firebaseEndpoints;
import 'package:qr/src/utils/store_interactor.dart';

class RegistrationPagePresenter with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _fireStore = Firestore.instance;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> register(GoogleRegistrationPayload googlePayload) async {
    _isLoading = true;
    notifyListeners();

    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: googlePayload.email,
        password: googlePayload.googleId,
      );

      final userToken = authResult.user.uid;

      await StoreInteractor.setToken(userToken);

      _fireStore.collection(firebaseEndpoints.users).document(userToken)
        ..setData(_getNewUser(userToken, googlePayload).toJson());

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

  UserModel _getNewUser(String userToken, GoogleRegistrationPayload googlePayload) {
    return UserModel(
      id: userToken,
      name: googlePayload.name,
      phone: googlePayload.phone,
      position: googlePayload.position,
      status: UserStatus.user,
    );
  }
}
