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
  Future<List<Inventory>> getHistory(String userId) async {
    // TODO: implement getHistory
    return null;
  }

  @override
  Future<Inventory> getInventoryInfo(String inventoryId) async {
    final inventoryJson = _listJson
        .firstWhere((obj) => obj['id'] == inventoryId, orElse: () => null);
    return InventoryModel.fromJson(inventoryJson);
  }

  @override
  Future<List<Inventory>> getTakenInventories(String userId) async {
    // TODO: implement getTakenInventories
    return null;
  }

  @override
  Future<void> returnInventory(String inventoryId) async {
    // TODO: implement returnInventory
    return null;
  }

  @override
  Future<void> takeInventory(String inventoryId) async {
    // TODO: implement takeInventory
    return null;
  }
}

class AdminRepositoryMock extends UserRepositoryMock
    implements AdminRepository {
  @override
  Future<void> addNewInventoryToDatabase(Inventory inventory) async {
    // TODO: implement addNewInventoryToDatabase
    return null;
  }

  @override
  Future<List<Inventory>> getAllInventoriesInfo() async {
    // TODO: implement getAllInventoriesInfo
    return null;
  }

  @override
  Future<List<User>> getAllUsers() async {
    // TODO: implement getAllUsers
    return null;
  }

  @override
  Future<User> getUserInfo(String userId) async {
    // TODO: implement getUserInfo
    return null;
  }

  @override
  Future<void> removeInventoryFromDatabase(String inventoryId) async {
    // TODO: implement removeInventoryFromDatabase
    return null;
  }

  @override
  Future<void> setInventoryStatus(String inventoryId) async {
    // TODO: implement setInventoryStatus
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
}
