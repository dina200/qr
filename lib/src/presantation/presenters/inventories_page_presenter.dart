import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class InventoriesPagePresenter with ChangeNotifier {
  final _userRepo = injector.get<UserRepository>();

  InventoryFilter _selectedFilter = InventoryFilter.taken;
  bool _isLoading = false;
  User _user;
  List<Inventory> _inventories;

  InventoryFilter get selectedFilter => _selectedFilter;

  bool get isLoading => _isLoading;

  User get user => _user;

  List<Inventory> get inventories => _inventories;

  InventoriesPagePresenter() {
    _getCurrentUser();
    fetchInventories(_selectedFilter);
  }

  void _getCurrentUser() {
    try {
      _user = _userRepo.currentUser;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchInventories(InventoryFilter filter) async {
    _selectedFilter = filter;
    notifyListeners();
    switch (filter) {
      case InventoryFilter.history:
        await _getCurrentUserHistory();
        break;
      case InventoryFilter.taken:
        await _getCurrentUserTakenInventories();
        break;
      default:
        throw ArgumentError();
    }
  }

  Future<void> _getCurrentUserHistory() async {
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

  Future<void> _getCurrentUserTakenInventories() async {
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
