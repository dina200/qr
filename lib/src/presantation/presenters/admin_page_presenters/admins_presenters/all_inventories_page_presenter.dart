import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class AllInventoriesPagePresenter with ChangeNotifier {
  final AdminRepository _adminRepo = injector.get<UserRepository>();

  AdminInventoryFilter _selectedFilter = AdminInventoryFilter.all;
  bool _isLoading = false;
  List<Inventory> _inventories;
  List<Inventory> _filteredInventories;

  AdminInventoryFilter get selectedFilter => _selectedFilter;

  bool get isLoading => _isLoading;

  List<Inventory> get inventories => _filteredInventories;

  AllInventoriesPagePresenter() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    try {
      _inventories = await _adminRepo.getAllInventoriesInfo();
      _filteredInventories = _inventories;
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void fetchInventories(AdminInventoryFilter filter) {
    _selectedFilter = filter;
    notifyListeners();
    switch (filter) {
      case AdminInventoryFilter.all:
        _fetchAll();
        break;
      case AdminInventoryFilter.free:
        _fetchFree();
        break;
      case AdminInventoryFilter.taken:
        _fetchTaken();
        break;
      case AdminInventoryFilter.lost:
        _fetchLost();
        break;
      default:
        throw ArgumentError();
    }
  }

  void _fetchAll() {
    _filteredInventories = _inventories;
    notifyListeners();
  }

  void _fetchFree() {
    _filteredInventories = _inventories
        .where((inventory) => inventory.status == InventoryStatus.free).toList();
    notifyListeners();
  }

  void _fetchTaken() {
    _filteredInventories = _inventories
        .where((inventory) => inventory.status == InventoryStatus.taken).toList();
    notifyListeners();
  }

  void _fetchLost() {
    _filteredInventories = _inventories
        .where((inventory) => inventory.status == InventoryStatus.lost).toList();
    notifyListeners();
  }
}
