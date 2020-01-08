import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:qr/src/domain/entities/user.dart';

import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';
import 'package:qr/src/utils/store_interactor.dart';

class QrDrawerPresenter with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _userRepo = injector.get<UserRepository>();

  User _user;

  User get user => _user;

  QrDrawerPresenter() {
    _init();
  }

  Future<void> _init() async {
    _user = await _userRepo.getCurrentUser();
    notifyListeners();
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
      await StoreInteractor.clear();
      injector
        ..removeEntity<UserRepository>()
        ..removeEntity<AdminRepository>()
        ..removeEntity<SuperAdminRepository>();
    } catch (e) {
      print('QrDrawerPresenter: $e');
      rethrow;
    }
  }
}
