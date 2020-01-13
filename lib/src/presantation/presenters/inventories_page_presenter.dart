import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class InventoriesPagePresenter with ChangeNotifier {
  final UserRepository _userRepo = injector.get<UserRepository>();

  UserInventoryFilter _selectedFilter = UserInventoryFilter.taken;
  bool _isLoading = false;
  User _user;
  List<Inventory> _inventories;

  UserInventoryFilter get selectedFilter => _selectedFilter;

  bool get isLoading => _isLoading;

  User get user => _user;

  List<Inventory> get inventories => _inventories;

  InventoriesPagePresenter() {
    _user = _userRepo.currentUser;
    notifyListeners();
    fetchInventories(_selectedFilter);
  }

  Future<void> fetchInventories(UserInventoryFilter filter) async {
    _selectedFilter = filter;
    _inventories = null;
    notifyListeners();
    switch (filter) {
      case UserInventoryFilter.history:
        await _fetchCurrentUserHistory();
        break;
      case UserInventoryFilter.taken:
        await _fetchCurrentUserTakenInventories();
        break;
      default:
        throw ArgumentError();
    }
  }

  Future<void> _fetchCurrentUserHistory() async {
    _isLoading = true;
    notifyListeners();
    try {
      _inventories = await _userRepo.getCurrentUserHistory();
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchCurrentUserTakenInventories() async {
    _isLoading = true;
    notifyListeners();
    try {
      _inventories = await _userRepo.getCurrentUserTakenInventories();
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
