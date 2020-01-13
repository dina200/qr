import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class RemoveInventoriesPagePresenter with ChangeNotifier {
  final AdminRepository _adminRepo = injector.get<UserRepository>();

  bool _isLoading = false;

  bool get isLoading => _isLoading;
}
