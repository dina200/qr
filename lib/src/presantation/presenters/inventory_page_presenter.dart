import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class InventoryPagePresenter with ChangeNotifier {
  final UserRepository _userRepo;

  String _userId;

  final Inventory inventory;

  InventoryPagePresenter(this.inventory) : _userRepo = injector.get<UserRepository>() {
    _userId = _userRepo.currentUser.id;
    notifyListeners();
  }

  List<UserStatistic> getUserStatistic(Inventory inventory) {
    final statisticByUserId = inventory.statistic.where((stat) => stat.userId == _userId).toList();
    return statisticByUserId..sort(UserStatistic.reverseSort);
  }
}
