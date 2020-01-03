import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:qr/src/data/models/user_model.dart';
import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/domain/repositories_contracts/auth_repository.dart';
import 'package:qr/src/utils/firebase_endpoints.dart' as firebaseEndpoints;
import 'package:qr/src/utils/exceptions.dart';
import 'package:qr/src/utils/store_interactor.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _fireStore = Firestore.instance;

  @override
  Future<void> loginWith(LoginPayload loginPayload) async {
    if (loginPayload is LoginWithGooglePayload) {
      await _loginWithGoogle(loginPayload);
    } else {
      throw AssertionError();
    }
  }

  @override
  Future<void> registerWith(RegisterPayload registerPayload) async {
    if (registerPayload is RegisterWithGooglePayload) {
      await _registerWithGoogle(registerPayload);
    } else {
      throw AssertionError();
    }
  }

  @override
  Future<void> restorePassword(String email) {
    // TODO: implement restorePassword
    return null;
  }

  Future<void> _loginWithGoogle(LoginWithGooglePayload loginPayload) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(
        email: loginPayload.email,
        password: loginPayload.googleId,
      );

      final userToken = authResult.user.uid;

      await StoreInteractor.setToken(userToken);
    } on StateError catch (e) {
      throw QrStateException(e.message);
    } on PlatformException catch (e) {
      throw QrPlatformException(e.code);
    } catch (e) {
      print('HttpAuthRepo: loginWithGoogle $e');
      rethrow;
    }
  }

  Future<void> _registerWithGoogle(
      RegisterWithGooglePayload registerPayload) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: registerPayload.email,
        password: registerPayload.googleId,
      );

      final userToken = authResult.user.uid;

      await StoreInteractor.setToken(userToken);

      _fireStore.collection(firebaseEndpoints.users).document(userToken)
        ..setData(_getNewUser(userToken, registerPayload).toJson());
    } on StateError catch (e) {
      throw QrStateException(e.message);
    } on PlatformException catch (e) {
      throw QrPlatformException(e.code);
    } catch (e) {
      print('HttpAuthRepo: registerWithGoogle ${e}');
      rethrow;
    }
  }

  UserModel _getNewUser(
      String userToken, RegisterWithGooglePayload registerPayload) {
    return UserModel(
      id: userToken,
      name: registerPayload.name,
      email: registerPayload.email,
      phone: registerPayload.phone,
      position: registerPayload.position,
      status: UserStatus.user,
    );
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
