import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';


class UserRepositoryImpl implements UserRepository {
  @override
  Future<List<Inventory>> getHistory(String userId) {
    // TODO: implement getHistory
    return null;
  }

  @override
  Future<Inventory> getInventoryInfo(String inventoryId) {
    // TODO: implement getInventoryInfo
    return null;
  }

  @override
  Future<List<Inventory>> getTakenInventories(String userId) {
    // TODO: implement getTakenInventories
    return null;
  }

  @override
  Future<void> returnInventory(String inventoryId) {
    // TODO: implement returnInventory
    return null;
  }

  @override
  Future<void> takeInventory(String inventoryId) {
    // TODO: implement takeInventory
    return null;
  }

}

class AdminRepositoryImpl extends UserRepositoryImpl
    implements AdminRepository {
  @override
  Future<void> addNewInventoryToDatabase(Inventory inventory) {
    // TODO: implement addNewInventoryToDatabase
    return null;
  }

  @override
  Future<List<Inventory>> getAllInventoriesInfo() {
    // TODO: implement getAllInventoriesInfo
    return null;
  }

  @override
  Future<List<User>> getAllUsers() {
    // TODO: implement getAllUsers
    return null;
  }

  @override
  Future<User> getUserInfo(String userId) {
    // TODO: implement getUserInfo
    return null;
  }

  @override
  Future<void> removeInventoryFromDatabase(String inventoryId) {
    // TODO: implement removeInventoryFromDatabase
    return null;
  }

  @override
  Future<void> setInventoryStatus(String inventoryId) {
    // TODO: implement setInventoryStatus
    return null;
  }

}

class SuperAdminRepositoryImpl extends AdminRepositoryImpl
    implements SuperAdminRepository {
  @override
  Future<void> addUserToAdmins(String userId) {
    // TODO: implement addUserToAdmins
    return null;
  }

  @override
  Future<void> removeUserFromAdmins(String userId) {
    // TODO: implement removeUserFromAdmins
    return null;
  }

}
