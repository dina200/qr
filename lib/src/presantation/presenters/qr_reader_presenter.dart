import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class QrReaderPagePresenter with ChangeNotifier {
  final _userRepo = injector.get<UserRepository>();

  User _user;
  User _anotherUser;
  Inventory _inventory;
  List<Inventory> _inventories;
  List<User> _users;
  bool _isLoading = false;

  User get user => _user;

  Inventory get inventory => _inventory;

  List<Inventory> get inventories => _inventories;

  List<User> get users => _users;

  User get anotherUser => _anotherUser;

  bool get isLoading => _isLoading;

  QrReaderPagePresenter() {
    _init();
  }

  Future<void> _init() async {
    await _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    try {
      _user = _userRepo.currentUser;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getInventoryInfo(String inventoryId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _inventory = await _userRepo.getInventoryInfo(inventoryId);
      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearInventoryInfo() {
    _inventory = null;
    notifyListeners();
  }

  Future<void> takeInventory() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _userRepo.takeInventory(inventory.id);
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> returnInventory() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _userRepo.returnInventory(inventory.id);
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCurrentUserHistory() async {
    try {
      _inventories = await _userRepo.getCurrentUserHistory();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getCurrentUserTakenInventories() async {
    try {
      _inventories = await _userRepo.getCurrentUserTakenInventories();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  ////////////ADMIN//////////////

  Future<void> getAllUser() async {
    try {
      _users = await (_userRepo as AdminRepository).getAllUsers();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getUserInfo(String userId) async {
    try {
      _anotherUser = await (_userRepo as AdminRepository).getUserInfo(userId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getUserHistory(String userId) async {
    try {
      _inventories = await (_userRepo as AdminRepository).getUserHistory(userId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getTakenInventoriesByUser(String userId) async {
    try {
      _inventories = await (_userRepo as AdminRepository).getTakenInventoriesByUser(userId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getAllInventoriesInfo() async {
    try {
      _inventories = await (_userRepo as AdminRepository).getAllInventoriesInfo();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addNewInventoryToDatabase({
    @required String id,
    @required String name,
    @required String info,
  }) async {
    try {
      await (_userRepo as AdminRepository).addNewInventoryToDatabase(id, name, info);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeInventoryFromDatabase(String inventoryId) async {
    try {
      await (_userRepo as AdminRepository).removeInventoryFromDatabase(inventoryId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setInventoryStatus(
      String inventoryId, InventoryStatus status) async {
    try {
      await (_userRepo as AdminRepository).setInventoryStatus(inventoryId, status);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  ////////////SUPER ADMIN//////////////

  Future<void> addUserToAdmins(String userId) async {
    try {
      await (_userRepo as SuperAdminRepository).addUserToAdmins(userId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeUserFromAdmins(String userId) async {
    try {
      await (_userRepo as SuperAdminRepository).removeUserFromAdmins(userId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeInventoryStatistic(String inventoryId) async {
    try {
      await (_userRepo as SuperAdminRepository).removeInventoryStatistic(inventoryId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
