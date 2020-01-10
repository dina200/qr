import 'package:flutter/widgets.dart';

import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/injector.dart';

class AdminPagePresenter with ChangeNotifier {
  final UserRepository _userRepo = injector.get<UserRepository>();

  bool get isSuperUser => _userRepo is SuperAdminRepository;
}
