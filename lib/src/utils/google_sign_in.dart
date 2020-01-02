import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';

import 'package:qr/src/utils/exceptions.dart';

Future<GoogleSignInAccount> getGoogleData() async {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  final account = await _googleSignIn.signIn();
  final isSignedIn = await _googleSignIn.isSignedIn();
  if (isSignedIn) {
    await _googleSignIn.disconnect();
    return account;
  }

  throw GoogleLoginException();
}

Future<GoogleSignInAuthentication> getGoogleAuthData(
    GoogleSignInAccount googleData) async {
  return googleData.authentication;
}
