import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class AddUserToAdminsPagePresenter with ChangeNotifier {
  final SuperAdminRepository _adminRepo = injector.get<UserRepository>();

  List<User> _onlyUsers;

  bool _isLoading = false;

  List<User> get onlyUsers => _onlyUsers;

  bool get isLoading => _isLoading;

  AddUserToAdminsPagePresenter() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _fetchOnlyUsers();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addUserToAdmin(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _adminRepo.addUserToAdmins(userId);
      await _fetchOnlyUsers();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchOnlyUsers() async {
    final users = await _adminRepo.getAllUsers();
    _onlyUsers =
        users.where((user) => user.status == UserStatus.user).toList();
    notifyListeners();
  }
}
