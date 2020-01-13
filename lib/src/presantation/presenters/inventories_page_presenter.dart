import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class InventoriesPagePresenter with ChangeNotifier {
  final UserRepository _userRepo = injector.get<UserRepository>();

  UserInventoryFilter _selectedFilter = UserInventoryFilter.taken;
  bool _isLoading = false;

  List<Inventory> _inventories;
  List<Inventory> _inventoriesTaken;
  List<Inventory> _inventoriesHistory;

  UserInventoryFilter get selectedFilter => _selectedFilter;

  bool get isLoading => _isLoading;

  List<Inventory> get inventories => _inventories;

  InventoriesPagePresenter() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    try {
      _inventoriesTaken = await _userRepo.getCurrentUserTakenInventories();
      _inventoriesHistory = await _userRepo.getCurrentUserHistory();
      _inventories = _inventoriesTaken;
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchInventories(UserInventoryFilter filter) async {
    _selectedFilter = filter;
    notifyListeners();
    switch (filter) {
      case UserInventoryFilter.taken:
        _fetchCurrentUserTakenInventories();
        break;
      case UserInventoryFilter.history:
        _fetchCurrentUserHistory();
        break;
      default:
        throw ArgumentError();
    }
  }

  void _fetchCurrentUserTakenInventories() {
    _inventories = _inventoriesTaken;
    notifyListeners();
  }

  void _fetchCurrentUserHistory() {
    _inventories = _inventoriesHistory;
    notifyListeners();
  }
}
