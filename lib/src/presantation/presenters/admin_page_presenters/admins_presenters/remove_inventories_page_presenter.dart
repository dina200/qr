import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class RemoveInventoriesPagePresenter with ChangeNotifier {
  final AdminRepository _adminRepo = injector.get<UserRepository>();

  List<Inventory> _freeInventories;

  bool _isLoading = false;

  List<Inventory> get inventories => _freeInventories;

  bool get isLoading => _isLoading;

  RemoveInventoriesPagePresenter() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _fetchFreeInventories();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeInventory(String inventoryId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _adminRepo.removeInventoryFromDatabase(inventoryId);
      await _fetchFreeInventories();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchFreeInventories() async {
    final inventories = await _adminRepo.getAllInventoriesInfo();
    _freeInventories = inventories
        .where((inventory) => inventory.status == InventoryStatus.free)
        .toList();
    notifyListeners();
  }
}
