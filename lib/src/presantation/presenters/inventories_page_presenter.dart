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
  List<Inventory> _inventoriesLost;

  UserInventoryFilter get selectedFilter => _selectedFilter;

  bool get isLoading => _isLoading;

  List<Inventory> get inventories => _inventories;

  InventoriesPagePresenter() {
    update();
  }

  Future<void> update() async {
    _isLoading = true;
    notifyListeners();
    try {
      _inventories = null;
      notifyListeners();
      _inventoriesTaken = await _userRepo.getCurrentUserTakenInventories();
      final userHistory = await _userRepo.getCurrentUserHistory();
      _inventoriesLost = userHistory
          .where((inventory) => inventory.status == InventoryStatus.lost)
          .toList();
      fetchInventories(_selectedFilter);
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
      case UserInventoryFilter.lost:
        _fetchCurrentUserLostInventories();
        break;
      default:
        throw ArgumentError();
    }
  }

  void _fetchCurrentUserTakenInventories() {
    _inventories = _inventoriesTaken;
    notifyListeners();
  }

  void _fetchCurrentUserLostInventories() {
    _inventories = _inventoriesLost;
    notifyListeners();
  }
}
