import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class UserProfilePagePresenter with ChangeNotifier {
  final UserRepository _userRepo = injector.get<UserRepository>();

  User _user;
  bool _isLoading = false;
  bool _isCurrentUser;

  User get user => _user;

  bool get isLoading => _isLoading;

  bool get isCurrentUser => _isCurrentUser;

  UserProfilePagePresenter(User user) {
    _isCurrentUser = user == null;
    _user = user ?? _userRepo.currentUser;
  }
}
