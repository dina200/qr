import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class InventoryPagePresenter with ChangeNotifier {
  final UserRepository _userRepo = injector.get<UserRepository>();

  Inventory _inventory;
  String _userId;
  bool _isLoading = false;

  Inventory get inventory => _inventory;

  bool get isLoading => _isLoading;

  InventoryPagePresenter(this._inventory) {
    _userId = _userRepo.currentUser.id;
    notifyListeners();
  }

  List<UserStatistic> getUserStatistic(Inventory inventory) {
    final statisticByUserId =
        inventory.statistic.where((stat) => stat.userId == _userId).toList();
    return statisticByUserId..sort(UserStatistic.reverseSort);
  }

  Future<void> changeInventoryStatus(InventoryStatus status) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _userRepo.setInventoryStatus(_inventory.id, status);
      _inventory = await _userRepo.getInventoryInfo(_inventory.id);
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
