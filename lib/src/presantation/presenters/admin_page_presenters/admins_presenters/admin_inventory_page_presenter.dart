import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class AdminInventoryPagePresenter with ChangeNotifier {
  final AdminRepository _adminRepo = injector.get<UserRepository>();
  Inventory _inventory;

  List<User> _users;
  List<UserStatisticPayload> _statistic;
  bool _isLoading = false;

  Inventory get inventory => _inventory;

  List<UserStatisticPayload> get statistic => _statistic;

  bool get isLoading => _isLoading;

  AdminInventoryPagePresenter(this._inventory) : assert(_inventory != null) {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    try {
      _users = await _adminRepo.getAllUsers();
      _fetchUserStatistic();
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _fetchUserStatistic() {
    if (_users != null) {
      final payload = inventory.statistic.map((stat) {
        final user = _users.firstWhere((user) => user.id == stat.userId,
            orElse: () => null);
        return UserStatisticPayload(
          user: user,
          status: stat.status,
          dateTime: stat.dateTime,
        );
      }).toList();

      _statistic = payload..sort(UserStatisticPayload.reverseSort);
    } else {
      _statistic = null;
    }
  }

  Future<void> changeInventoryStatus(
    InventoryStatus status,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _adminRepo.setInventoryStatus(_inventory.id, status);
      _inventory = await _adminRepo.getInventoryInfo(_inventory.id);
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class UserStatisticPayload {
  final User user;
  final InventoryStatus status;
  final DateTime dateTime;

  UserStatisticPayload({
    @required this.user,
    @required this.status,
    @required this.dateTime,
  })  : assert(user != null),
        assert(status != null),
        assert(dateTime != null);

  String get dateFormatted {
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
  }

  static int reverseSort(UserStatisticPayload a, UserStatisticPayload b) {
    if (a.dateTime.isAfter(b.dateTime)) {
      return -1;
    } else if (a.dateTime.isBefore(b.dateTime)) {
      return 1;
    }
    return 0;
  }
}
