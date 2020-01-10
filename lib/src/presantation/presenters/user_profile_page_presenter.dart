import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class UserProfilePagePresenter with ChangeNotifier {
  final UserRepository _userRepo;

  User _user;
  bool _isLoading = false;

  User get user => _user;

  bool get isLoading => _isLoading;

  UserProfilePagePresenter() : _userRepo = injector.get<UserRepository>() {
    _user = _userRepo.currentUser;
    notifyListeners();
  }
}
