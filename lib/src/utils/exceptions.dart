import 'package:qr/src/domain/entities/user.dart';

class ConnectionException implements Exception {
  @override
  String toString() {
    return 'Connection exception';
  }
}

class WrongCreditException implements Exception {
  @override
  String toString() {
    return 'Wrong creditials';
  }
}

class UserIsAlreadyRegisteredException implements Exception {
  @override
  String toString() {
    return 'User is already registered';
  }
}

class GoogleLoginException implements Exception {
  @override
  String toString() {
    return 'Google login exception';
  }
}

class QrStateException implements Exception {
  final String message;

  QrStateException(this.message);

  @override
  String toString() {
    return 'QrStateException: $message';
  }
}

class InventoryAlreadyExist implements Exception {
  InventoryAlreadyExist();

  @override
  String toString() {
    return 'The inventory id is already exist';
  }
}

class InventoryNotExist implements Exception {
  String inventoryId;

  InventoryNotExist(this.inventoryId);

  @override
  String toString() {
    return 'The inventory is not exist';
  }
}

class InventoryUsedByAnotherUser implements Exception {
  final User anotherUser;

  InventoryUsedByAnotherUser(this.anotherUser);

  @override
  String toString() {
    return 'The inventory is used by another user';
  }
}

class InventoryNotTakenByTheUser implements Exception {
  InventoryNotTakenByTheUser();

  @override
  String toString() {
    return 'The inventory is not taken by the user';
  }
}
class InventoryNotFree implements Exception {
  InventoryNotFree();

  @override
  String toString() {
    return 'The inventory is not free';
  }
}

class InventoryLost implements Exception {
  InventoryLost();

  @override
  String toString() {
    return 'The inventory is lost';
  }
}

class InventoryStatusException implements Exception {
  InventoryStatusException();

  @override
  String toString() {
    return 'Inventory: something went wrong. Maybe, the inventory is not free ';
  }
}

class UserNotExist implements Exception {
  UserNotExist();

  @override
  String toString() {
    return 'The user is not exist. Maybe, he is removed';
  }
}

class UserStatusCanNotBeChange implements Exception {
  UserStatusCanNotBeChange();

  @override
  String toString() {
    return 'User can not change his status';
  }
}
