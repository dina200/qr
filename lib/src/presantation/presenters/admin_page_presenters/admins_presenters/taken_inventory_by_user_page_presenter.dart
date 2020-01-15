import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class TakenInventoriesPagePresenter with ChangeNotifier {
  final AdminRepository _adminRepository = injector.get<UserRepository>();

  bool _isLoading = false;

  User _user;

  List<Inventory> _inventories;

  bool get isLoading => _isLoading;

  List<Inventory> get inventories => _inventories;

  TakenInventoriesPagePresenter(this._user) {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    try {
      _inventories = await _adminRepository.getTakenInventoriesByUser(_user.id);
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
