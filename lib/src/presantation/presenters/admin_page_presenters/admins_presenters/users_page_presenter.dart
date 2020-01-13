import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class UsersPagePresenter with ChangeNotifier {
  final AdminRepository _adminRepo = injector.get<UserRepository>();

  List<User> _users;
  List<User> _filteredUsers;
  UserFilter _selectedFilter = UserFilter.all;
  bool _isLoading = false;

  List<User> get users => _filteredUsers;

  UserFilter get selectedFilter => _selectedFilter;

  bool get isLoading => _isLoading;

  UsersPagePresenter() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    try {
      _users = await _adminRepo.getAllUsers();
      _filteredUsers = _users;
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void fetchUsers(UserFilter filter) {
    _selectedFilter = filter;
    notifyListeners();
    switch (filter) {
      case UserFilter.all:
        _fetchAllUsers();
        break;
      case UserFilter.users:
        _fetchOnlyUsers();
        break;
      case UserFilter.admins:
        _fetchAdmins();
        break;
      default:
        throw ArgumentError();
    }
  }

  Future<void> _fetchAllUsers() async {
    _filteredUsers = _users;
    notifyListeners();
  }

  Future<void> _fetchOnlyUsers() async {
    _filteredUsers =
        _users.where((user) => user.status == UserStatus.user).toList();
    notifyListeners();
  }

  Future<void> _fetchAdmins() async {
    _filteredUsers = _users
        .where((user) =>
            user.status == UserStatus.admin ||
            user.status == UserStatus.superAdmin)
        .toList();
    notifyListeners();
  }
}
