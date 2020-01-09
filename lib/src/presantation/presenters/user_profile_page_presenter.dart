import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class UserProfilePagePresenter with ChangeNotifier {
  final _userRepo = injector.get<UserRepository>();

  User _user;
  bool _isLoading = false;

  User get user => _user;

  bool get isLoading => _isLoading;

  UserProfilePagePresenter() {
    _getCurrentUser();
  }

  void _getCurrentUser() {
    try {
      _user = _userRepo.currentUser;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
