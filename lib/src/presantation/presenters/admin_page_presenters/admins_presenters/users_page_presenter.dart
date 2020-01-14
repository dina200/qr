import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class UsersPagePresenter with ChangeNotifier {
  final AdminRepository _adminRepo = injector.get<UserRepository>();

  List<User> _allUsers;
  List<User> _onlyUsers;
  List<User> _admins;
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
      _allUsers = await _adminRepo.getAllUsers();
      _onlyUsers = _allUsers
          .where((user) => user.status == UserStatus.user)
          .toList();
      _admins = _allUsers
          .where((user) =>
              user.status == UserStatus.admin ||
              user.status == UserStatus.superAdmin)
          .toList();
      _filteredUsers = _allUsers;
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

  void _fetchAllUsers() {
    _filteredUsers = _allUsers;
    notifyListeners();
  }

  void _fetchOnlyUsers() {
    _filteredUsers = _onlyUsers;

    notifyListeners();
  }

  void _fetchAdmins() {
    _filteredUsers = _admins;
    notifyListeners();
  }
}
