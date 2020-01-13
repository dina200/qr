import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class UsersPagePresenter with ChangeNotifier {
  final AdminRepository _userRepo = injector.get<UserRepository>();

  List<User> _users;
  UserFilter _selectedFilter = UserFilter.all;
  bool _isLoading = false;

  List<User> get users => _users;

  UserFilter get selectedFilter => _selectedFilter;

  bool get isLoading => _isLoading;

  UsersPagePresenter() {
    fetchUsers(_selectedFilter);
  }

  Future<void> fetchUsers(UserFilter filter) async {
    _selectedFilter = filter;
    _users = null;
    notifyListeners();
    switch (filter) {
      case UserFilter.all:
        await _fetchAllUsers();
        break;
      case UserFilter.users:
        await _fetchOnlyUsers();
        break;
      case UserFilter.admins:
        await _fetchAdmins();
        break;
      default:
        throw ArgumentError();
    }
  }

  Future<void> _fetchAllUsers() async {
    _isLoading = true;
    notifyListeners();
    try {
      _users = await _userRepo.getAllUsers();
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchOnlyUsers() async {
    _isLoading = true;
    notifyListeners();
    try {
      final allUsers = await _userRepo.getAllUsers();
      _users =
          allUsers.where((user) => user.status == UserStatus.user).toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchAdmins() async {
    _isLoading = true;
    notifyListeners();
    try {
      final allUsers = await _userRepo.getAllUsers();
      _users = allUsers
          .where((user) =>
              user.status == UserStatus.admin ||
              user.status == UserStatus.superAdmin)
          .toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
