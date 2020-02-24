import 'dart:convert';

import 'package:qr/src/data/models/inventory_model.dart';
import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';

import '../../../../fixtures/fixture_reader.dart';

class UserRepositoryMock implements UserRepository {
  List<dynamic> _listJson;

  UserRepositoryMock() {
    _listJson = json.decode(fixture('all_inventories.json'));
  }

   @override
  Future<Inventory> getInventoryInfo(String inventoryId) async {
    final inventoryJson = _listJson
        .firstWhere((obj) => obj['id'] == inventoryId, orElse: () => null);
    return InventoryModel.fromJson(inventoryJson);
  }
  
  @override
  User get currentUser {
    // TODO: implement getCurrentUser
    return null;
  }

  @override
  Future<List<Inventory>> getCurrentUserHistory() {
    // TODO: implement getCurrentUserHistory
    return null;
  }

  @override
  Future<List<Inventory>> getCurrentUserTakenInventories() {
    // TODO: implement getCurrentUserTakenInventories
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

  @override
  Future<void> setInventoryStatus(String inventoryId, InventoryStatus status) {
    // TODO: implement setInventoryStatus
    return null;
  }
}

class AdminRepositoryMock extends UserRepositoryMock
    implements AdminRepository {
  @override
  Future<void> addNewInventoryToDatabase(
    String id,
    String name,
    String info,
  ) {
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
  Future<List<Inventory>> getUserHistory(String userId) {
    // TODO: implement getUserHistory
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
  Future<void> setInventoryStatus(String inventoryId, InventoryStatus status) {
    // TODO: implement setInventoryStatus
    return null;
  }

  @override
  Future<List<Inventory>> getTakenInventoriesByUser(String userId) {
    // TODO: implement getTakenInventoriesByUserId
    return null;
  }
}

class SuperAdminRepositoryMock extends AdminRepositoryMock
    implements SuperAdminRepository {
  @override
  Future<void> addUserToAdmins(String userId) async {
    // TODO: implement addUserToAdmins
    return null;
  }

  @override
  Future<void> removeUserFromAdmins(String userId) async {
    // TODO: implement removeUserFromAdmins
    return null;
  }

  @override
  Future<void> removeInventoryStatistic(String inventoryId) {
    // TODO: implement removeInventoryStatistic
    return null;
  }
}
