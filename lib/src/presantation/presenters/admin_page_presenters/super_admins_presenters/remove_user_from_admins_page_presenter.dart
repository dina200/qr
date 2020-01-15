import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class RemoveUserFromAdminsPagePresenter with ChangeNotifier {
  final SuperAdminRepository _adminRepo = injector.get<UserRepository>();

  List<User> _onlyAdmins;

  bool _isLoading = false;

  List<User> get onlyAdmins => _onlyAdmins;

  bool get isLoading => _isLoading;

  RemoveUserFromAdminsPagePresenter() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _fetchOnlyAdmins();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeUserFromAdmin(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _adminRepo.removeUserFromAdmins(userId);
      await _fetchOnlyAdmins();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchOnlyAdmins() async {
    final users = await _adminRepo.getAllUsers();
    _onlyAdmins =
        users.where((user) => user.status == UserStatus.admin).toList();
    notifyListeners();
  }
}
