import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class AdminInventoryPagePresenter with ChangeNotifier {
  final AdminRepository _adminRepo = injector.get<UserRepository>();
  final Inventory inventory;

  List<User> _users;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  AdminInventoryPagePresenter(this.inventory) : assert(inventory != null) {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    try {
      _users = await _adminRepo.getAllUsers();
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<UserStatisticPayload> getUserStatistic(Inventory inventory) {
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

      return payload..sort(UserStatisticPayload.reverseSort);
    }
    return null;
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

  static int reverseSort (UserStatisticPayload a, UserStatisticPayload b) {
    if(a.dateTime.isAfter(b.dateTime)) {
      return -1;
    } else if (a.dateTime.isBefore(b.dateTime)) {
      return 1;
    }
    return 0;
  }
}
