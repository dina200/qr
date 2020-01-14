import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class AllInventoriesPagePresenter with ChangeNotifier {
  final AdminRepository _adminRepo = injector.get<UserRepository>();

  List<Inventory> _allInventories;
  List<Inventory> _freeInventories;
  List<Inventory> _takenInventories;
  List<Inventory> _lostInventories;
  List<Inventory> _filteredInventories;

  AdminInventoryFilter _selectedFilter = AdminInventoryFilter.all;
  bool _isLoading = false;

  AdminInventoryFilter get selectedFilter => _selectedFilter;

  bool get isLoading => _isLoading;

  List<Inventory> get inventories => _filteredInventories;

  AllInventoriesPagePresenter() {
    update();
  }

  Future<void> update() async {
    _isLoading = true;
    notifyListeners();
    try {
      _filteredInventories = null;
      notifyListeners();
      _allInventories = await _adminRepo.getAllInventoriesInfo();
      _freeInventories = _allInventories
          .where((inventory) => inventory.status == InventoryStatus.free)
          .toList();
      _takenInventories = _allInventories
          .where((inventory) => inventory.status == InventoryStatus.taken)
          .toList();
      _lostInventories = _allInventories
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
    _filteredInventories = _allInventories;
    notifyListeners();
  }

  void _fetchFree() {
    _filteredInventories = _freeInventories;
    notifyListeners();
  }

  void _fetchTaken() {
    _filteredInventories = _takenInventories;
    notifyListeners();
  }

  void _fetchLost() {
    _filteredInventories = _lostInventories;
    notifyListeners();
  }
}
