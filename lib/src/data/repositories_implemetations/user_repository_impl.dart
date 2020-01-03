import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:qr/src/data/models/inventory_model.dart';
import 'package:qr/src/data/models/user_model.dart';
import 'package:qr/src/utils/firebase_endpoints.dart' as firebaseEndpoints;
import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/utils/store_interactor.dart';

class UserRepositoryFirebaseImpl {
  String _userId;
  final _fireStore = Firestore.instance;

  Future<void> init() async {
    _userId = await StoreInteractor.getToken();
  }

  Stream<User> get currentUser => _fireStore
      .collection(firebaseEndpoints.users)
      .document(_userId)
      .snapshots()
      .map(_getUserFromSnapshot);

  User _getUserFromSnapshot(DocumentSnapshot snapshot) =>
      UserModel.fromJson(snapshot.data);

  Stream<Inventory> getInventoryInfo(String inventoryId) => _fireStore
      .collection(firebaseEndpoints.inventories)
      .document(inventoryId)
      .snapshots()
      .map(_getInventoryFromSnapshot);

  Stream<List<Inventory>> getCurrentUserHistory() {
    return _fireStore.collection(firebaseEndpoints.inventories).snapshots().map(
        (snapshot) => _getInventoriesByUserIdFromSnapshot(snapshot, _userId));
  }

  List<Inventory> _getInventoriesByUserIdFromSnapshot(
          QuerySnapshot snapshot, String userId) =>
      snapshot.documents
          .where((document) => jsonEncode(document.data).contains(userId))
          .map(_getInventoryFromSnapshot)
          .toList();

  Inventory _getInventoryFromSnapshot(DocumentSnapshot snapshot) =>
      InventoryModel.fromJson(_getCleanMap(snapshot.data));

  Map<String, dynamic> _getCleanMap(Map<String, dynamic> dirtyMap) {
    return jsonDecode(jsonEncode(dirtyMap));
  }

  Future<void> returnInventory(String inventoryId) {
    return null;
  }

  Future<void> takeInventory(String inventoryId) {
    return null;
  }
}

class AdminRepositoryFirestoreImpl extends UserRepositoryFirebaseImpl {
  Stream<User> getUserById(String userId) => _fireStore
      .collection(firebaseEndpoints.users)
      .document(userId)
      .snapshots()
      .map(_getUserFromSnapshot);

  Stream<List<Inventory>> getHistoryByUserId(String userId) {
    return _fireStore.collection(firebaseEndpoints.inventories).snapshots().map(
        (snapshot) => _getInventoriesByUserIdFromSnapshot(snapshot, userId));
  }

  Stream<List<Inventory>> get allInventories => _fireStore
      .collection(firebaseEndpoints.inventories)
      .snapshots()
      .map(_getAllInventoriesFromSnapshot);

  List<Inventory> _getAllInventoriesFromSnapshot(QuerySnapshot snapshot) =>
      snapshot.documents.map(_getInventoryFromSnapshot).toList();

  Stream<List<User>> getAllUsers() {
    return _fireStore
        .collection(firebaseEndpoints.users)
        .snapshots()
        .map(_getAllUsersFromSnapshot);
  }

  List<User> _getAllUsersFromSnapshot(QuerySnapshot snapshot) =>
      snapshot.documents.map(_getUserFromSnapshot).toList();

  Future<void> addNewInventoryToDatabase(Inventory inventory) {
    return null;
  }

  Future<void> removeInventoryFromDatabase(String inventoryId) {
    return null;
  }

  Future<void> setInventoryStatus(String inventoryId) {
    return null;
  }
}

class SuperAdminRepositoryFirestoreImpl extends AdminRepositoryFirestoreImpl {
  Future<void> addUserToAdmins(String userId) {
    return null;
  }

  Future<void> removeUserFromAdmins(String userId) {
    return null;
  }
}
