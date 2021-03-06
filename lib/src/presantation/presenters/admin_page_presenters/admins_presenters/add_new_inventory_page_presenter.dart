import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class AddNewInventoryPagePresenter with ChangeNotifier {
  final AdminRepository _adminRepo = injector.get<UserRepository>();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> addNewInventoryToDatabase({
    @required String id,
    @required String name,
    @required String description,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _adminRepo.addNewInventoryToDatabase(id, name, description);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
