import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class QrReaderPagePresenter with ChangeNotifier {
  final UserRepository _userRepo;

  User _user;
  Inventory _inventory;
  bool _isLoading = false;

  User get user => _user;

  Inventory get inventory => _inventory;

  bool get isLoading => _isLoading;

  QrReaderPagePresenter() : _userRepo = injector.get<UserRepository>() {
    _getCurrentUser();
  }

  void _getCurrentUser() {
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
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

  void clearInventoryInfo() {
    _inventory = null;
    notifyListeners();
  }
}
