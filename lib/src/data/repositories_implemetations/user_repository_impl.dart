import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:qr/src/data/models/inventory_model.dart';
import 'package:qr/src/data/models/user_model.dart';
import 'package:qr/src/domain/repositories_contracts/user_repository.dart';
import 'package:qr/src/utils/exceptions.dart';
import 'package:qr/src/utils/firebase_endpoints.dart' as firebaseEndpoints;
import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/utils/injector.dart';
import 'package:qr/src/utils/store_interactor.dart';

class UserRepositoryFirestoreFactory extends UserRepositoryFactory {
  @override
  Future<void> registerUserRepository() async {
    try {
      User user = await _initUser();
      if (user != null) {
        switch (user.status.value) {
          case 3:
            injector.register<UserRepository>(UserRepositoryFirestoreImpl(user));
            break;
          case 2:
            injector.register<UserRepository>(AdminRepositoryFirestoreImpl(user));
            break;
          case 1:
            injector.register<UserRepository>(SuperAdminRepositoryFirestoreImpl(user));
            break;
          default:
            throw ArgumentError();
        }
      }
    } catch (e) {
      print('UserRepositoryFirestoreFactory, getUserRepository: $e');
      rethrow;
    }
  }

  Future<User> _initUser() async {
    final Firestore _fireStore = Firestore.instance;
    final userId = await StoreInteractor.getToken();
    if (userId != null) {
      final snapshot = await _fireStore
          .collection(firebaseEndpoints.users)
          .document(userId)
          .get();
      return _getUserFromSnapshot(snapshot);
    }
    return null;
  }

  User _getUserFromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      return UserModel.fromJson(snapshot.data);
    } else {
      throw UserNotExist();
    }
  }
}

class UserRepositoryFirestoreImpl extends UserRepository {
  final User _user;

  UserRepositoryFirestoreImpl(this._user) : assert(_user != null);

  final _fireStore = Firestore.instance;

  @override
  User get currentUser => _user;

  @override
  Future<Inventory> getInventoryInfo(String inventoryId) async {
    final snapshot = await _fireStore
        .collection(firebaseEndpoints.inventories)
        .document(inventoryId)
        .get();
    return _getInventoryFromSnapshot(snapshot);
  }

  @override
  Future<List<Inventory>> getCurrentUserHistory() async {
    final snapshot = await _fireStore
        .collection(firebaseEndpoints.inventories)
        .getDocuments();
    return _getInventoriesHistoryByUserIdFromSnapshot(snapshot, _user.id);
  }

  @override
  Future<List<Inventory>> getCurrentUserTakenInventories() async {
    final snapshot = await _fireStore
        .collection(firebaseEndpoints.inventories)
        .getDocuments();
    return _getTakenInventoriesByUserIdFromSnapshot(snapshot, _user.id);
  }

  @override
  Future<void> returnInventory(String inventoryId) async {
    final snapshot = await _fireStore
        .collection(firebaseEndpoints.inventories)
        .document(inventoryId)
        .get();

    final lastDataStatistic =
        _getInventoryFromSnapshot(snapshot).statistic.last;

    if (lastDataStatistic.userId == _user.id &&
        lastDataStatistic.status == InventoryStatus.taken) {
      await _fireStore
          .collection(firebaseEndpoints.inventories)
          .document(inventoryId)
          .updateData({
        firebaseEndpoints.status: InventoryStatus.free.value,
        firebaseEndpoints.statistic: FieldValue.arrayUnion([
          UserStatisticModel(
            userId: _user.id,
            status: InventoryStatus.free,
            dateTime: DateTime.now(),
          ).toJson()
        ]),
      });
    } else if (lastDataStatistic.userId != _user.id) {
      throw InventoryUsedByAnotherUser(_user);
    } else if (lastDataStatistic.status != InventoryStatus.taken) {
      throw InventoryNotTakenByTheUser();
    } else {
      throw InventoryStatusException();
    }
  }

  @override
  Future<void> takeInventory(String inventoryId) async {
    final snapshot = await _fireStore
        .collection(firebaseEndpoints.inventories)
        .document(inventoryId)
        .get();

    final inventory = _getInventoryFromSnapshot(snapshot);
    if (inventory.status == InventoryStatus.free) {
      await _fireStore
          .collection(firebaseEndpoints.inventories)
          .document(inventoryId)
          .updateData({
        firebaseEndpoints.status: InventoryStatus.taken.value,
        firebaseEndpoints.statistic: FieldValue.arrayUnion([
          UserStatisticModel(
            userId: _user.id,
            status: InventoryStatus.taken,
            dateTime: DateTime.now(),
          ).toJson()
        ]),
      });
    } else {
      throw InventoryStatusException();
    }
  }

  @override
  Future<void> setInventoryStatus(String inventoryId, InventoryStatus status) async {
    try {
      await _fireStore
          .collection(firebaseEndpoints.inventories)
          .document(inventoryId)
          .updateData({firebaseEndpoints.status: status.value});
    } catch (e) {
      throw InventoryNotExist(inventoryId);
    }
  }

  User _getUserFromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      return UserModel.fromJson(snapshot.data);
    } else {
      throw UserNotExist();
    }
  }

  List<Inventory> _getInventoriesHistoryByUserIdFromSnapshot(
      QuerySnapshot snapshot, String userId) {
    return snapshot.documents
        .where((document) => jsonEncode(document.data).contains(userId))
        .map(_getInventoryFromSnapshot)
        .toList();
  }

  List<Inventory> _getTakenInventoriesByUserIdFromSnapshot(
      QuerySnapshot snapshot, String userId) {
    return snapshot.documents
        .where((document) => document.data[firebaseEndpoints.status] == 1)
        .where((document) =>
          jsonEncode(document.data[firebaseEndpoints.statistic].last)
          .contains(userId))
        .map(_getInventoryFromSnapshot)
        .toList();
  }

  Inventory _getInventoryFromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      return InventoryModel.fromJson(_getCleanMap(snapshot.data));
    } else {
      return null;
    }
  }

  Map<String, dynamic> _getCleanMap(Map<String, dynamic> dirtyMap) {
    return jsonDecode(jsonEncode(dirtyMap));
  }
}

class AdminRepositoryFirestoreImpl extends UserRepositoryFirestoreImpl
    implements AdminRepository {
  AdminRepositoryFirestoreImpl(User user) : super(user);

  @override
  Future<List<User>> getAllUsers() async {
    final snapshot =
        await _fireStore.collection(firebaseEndpoints.users).getDocuments();
    return _getAllUsersFromSnapshot(snapshot);
  }

  @override
  Future<User> getUserInfo(String userId) async {
    final snapshot = await _fireStore
        .collection(firebaseEndpoints.users)
        .document(userId)
        .get();
    return _getUserFromSnapshot(snapshot);
  }

  @override
  Future<List<Inventory>> getUserHistory(String userId) async {
    final snapshot = await _fireStore
        .collection(firebaseEndpoints.inventories)
        .getDocuments();
    return _getInventoriesHistoryByUserIdFromSnapshot(snapshot, userId);
  }

  ///are not used anywhere
  @override
  Future<List<Inventory>> getTakenInventoriesByUser(String userId) async {
    final snapshot = await _fireStore
        .collection(firebaseEndpoints.inventories)
        .getDocuments();
    return _getTakenInventoriesByUserIdFromSnapshot(snapshot, userId);
  }

  @override
  Future<List<Inventory>> getAllInventoriesInfo() async {
    final snapshot = await _fireStore
        .collection(firebaseEndpoints.inventories)
        .getDocuments();
    return _getAllInventoriesFromSnapshot(snapshot);
  }

  Future<void> addNewInventoryToDatabase(
      String id, String name, String info) async {
    final snapshot = await _fireStore
        .collection(firebaseEndpoints.inventories)
        .document(id)
        .get();

    final inventory = Inventory(
      id: id,
      name: name,
      info: info,
      status: InventoryStatus.free,
    );

    if (!snapshot.exists) {
      await _fireStore
          .collection(firebaseEndpoints.inventories)
          .document(inventory.id)
          .setData(_inventoryModelFromInventoryEntity(inventory).toJson());
    } else {
      throw InventoryAlreadyExist();
    }
  }

  Future<void> removeInventoryFromDatabase(String inventoryId) async {
    final snapshot = await _fireStore
        .collection(firebaseEndpoints.inventories)
        .document(inventoryId)
        .get();

    if (snapshot.exists) {
      await _fireStore
          .collection(firebaseEndpoints.inventories)
          .document(inventoryId)
          .delete();
    } else {
      throw InventoryNotExist(inventoryId);
    }
  }

  List<User> _getAllUsersFromSnapshot(QuerySnapshot snapshot) =>
      snapshot.documents.map(_getUserFromSnapshot).toList();

  List<Inventory> _getAllInventoriesFromSnapshot(QuerySnapshot snapshot) =>
      snapshot.documents.map(_getInventoryFromSnapshot).toList();

  InventoryModel _inventoryModelFromInventoryEntity(Inventory inventory) {
    return InventoryModel(
        id: inventory.id,
        info: inventory.info,
        name: inventory.name,
        status: inventory.status,
        statistic: inventory.statistic
            .map(
              (stat) => UserStatistic(
                userId: stat.userId,
                status: stat.status,
                dateTime: stat.dateTime,
              ),
            )
            .toList());
  }
}

class SuperAdminRepositoryFirestoreImpl extends AdminRepositoryFirestoreImpl
    implements SuperAdminRepository {
  SuperAdminRepositoryFirestoreImpl(User user) : super(user);

  Future<void> addUserToAdmins(String userId) async {
    try {
      await _fireStore
          .collection(firebaseEndpoints.users)
          .document(userId)
          .updateData({firebaseEndpoints.userStatus: UserStatus.admin.value});
    } catch (e) {
      throw UserNotExist();
    }
  }

  Future<void> removeUserFromAdmins(String userId) async {
    try {
      if (_user.id == userId) {
        throw UserStatusCanNotBeChange();
      }
      await _fireStore
          .collection(firebaseEndpoints.users)
          .document(userId)
          .updateData({firebaseEndpoints.userStatus: UserStatus.user.value});
    } on UserStatusCanNotBeChange {
      throw UserStatusCanNotBeChange();
    } catch (e) {
      throw UserNotExist();
    }
  }

  @override
  Future<void> removeInventoryStatistic(String inventoryId) async {
    final snapshot = await _fireStore
        .collection(firebaseEndpoints.inventories)
        .document(inventoryId)
        .get();

    if (snapshot.exists) {
      await _fireStore
          .collection(firebaseEndpoints.inventories)
          .document(inventoryId)
          .updateData({firebaseEndpoints.statistic: []});
    } else {
      throw InventoryNotExist(inventoryId);
    }
  }
}
