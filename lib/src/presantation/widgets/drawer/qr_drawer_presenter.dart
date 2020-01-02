import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import 'package:qr/src/utils/store_interactor.dart';

class QrDrawerPresenter with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logOut() async {
    try {
      await _auth.signOut();
      await StoreInteractor.clear();
    } catch (e) {
      print('QrDrawerPresenter: $e');
      rethrow;
    }
  }
}
