import 'package:flutter/widgets.dart';

import 'package:qr/src/data/repositories_implemetations/user_repository_impl.dart';
import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/utils/injector.dart';

class QrReaderPagePresenter with ChangeNotifier {
  final userRepo = injector.get<UserRepositoryFirebaseImpl>();
  User _user;
  Inventory _inventory;

  User get user => _user;

  Inventory get inventory => _inventory;

  bool _isLoading = false;

  bool get isLoading => _isLoading;
}
