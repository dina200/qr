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

  Stream<Inventory> getInventoryInfo(String inventoryId) => _fireStore
      .collection(firebaseEndpoints.inventories)
      .document(inventoryId)
      .snapshots()
      .map(_getInventoryFromSnapshot);

  Stream<List<Inventory>> getCurrentUserHistory() {
    return _fireStore.collection(firebaseEndpoints.inventories).snapshots().map(
        (snapshot) => _getInventoriesByUserIdFromSnapshot(snapshot, _userId));
  }

  Stream<List<Inventory>> getCurrentUserTakenInventories() {
    return _fireStore.collection(firebaseEndpoints.inventories).snapshots().map(
        (snapshot) =>
            _getTakenInventoriesByUserIdFromSnapshot(snapshot, _userId));
  }

  User _getUserFromSnapshot(DocumentSnapshot snapshot) =>
      UserModel.fromJson(snapshot.data);

  List<Inventory> _getInventoriesByUserIdFromSnapshot(
          QuerySnapshot snapshot, String userId) =>
      snapshot.documents
          .where((document) => jsonEncode(document.data).contains(userId))
          .map(_getInventoryFromSnapshot)
          .toList();

  List<Inventory> _getTakenInventoriesByUserIdFromSnapshot(
          QuerySnapshot snapshot, String userId) =>
      snapshot.documents
          .where((document) => document.data['status'] == 1)
          .where((document) => jsonEncode(document.data).contains(userId))
          .map(_getInventoryFromSnapshot)
          .toList();

  Inventory _getInventoryFromSnapshot(DocumentSnapshot snapshot) =>
      InventoryModel.fromJson(_getCleanMap(snapshot.data));

  Map<String, dynamic> _getCleanMap(Map<String, dynamic> dirtyMap) {
    return jsonDecode(jsonEncode(dirtyMap));
  }

  Future<void> returnInventory(String inventoryId) async {

  }

  Future<void> takeInventory(String inventoryId) async {
    return null;
  }
}

class AdminRepositoryFirestoreImpl extends UserRepositoryFirebaseImpl {
  Stream<List<User>> getAllUsers() {
    return _fireStore
        .collection(firebaseEndpoints.users)
        .snapshots()
        .map(_getAllUsersFromSnapshot);
  }

  Stream<User> getUserById(String userId) => _fireStore
      .collection(firebaseEndpoints.users)
      .document(userId)
      .snapshots()
      .map(_getUserFromSnapshot);

  Stream<List<Inventory>> getHistoryByUserId(String userId) {
    return _fireStore.collection(firebaseEndpoints.inventories).snapshots().map(
        (snapshot) => _getInventoriesByUserIdFromSnapshot(snapshot, userId));
  }

  Stream<List<Inventory>> getTakenInventoriesByUserId(String userId) {
    return _fireStore.collection(firebaseEndpoints.inventories).snapshots().map(
        (snapshot) =>
            _getTakenInventoriesByUserIdFromSnapshot(snapshot, userId));
  }

  Stream<List<Inventory>> get allInventories => _fireStore
      .collection(firebaseEndpoints.inventories)
      .snapshots()
      .map(_getAllInventoriesFromSnapshot);

  List<User> _getAllUsersFromSnapshot(QuerySnapshot snapshot) =>
      snapshot.documents.map(_getUserFromSnapshot).toList();

  List<Inventory> _getAllInventoriesFromSnapshot(QuerySnapshot snapshot) =>
      snapshot.documents.map(_getInventoryFromSnapshot).toList();

  Future<void> addNewInventoryToDatabase(Inventory inventory) async {
    await _fireStore
        .collection(firebaseEndpoints.inventories)
        .document(inventory.id)
        .setData((inventory as InventoryModel).toJson());
  }

  Future<void> removeInventoryFromDatabase(String inventoryId) async {
    await _fireStore
        .collection(firebaseEndpoints.inventories)
        .document(inventoryId)
        .delete();
  }

  Future<void> setInventoryStatus(
      String inventoryId, InventoryStatus status) async {
    await _fireStore
        .collection(firebaseEndpoints.inventories)
        .document(inventoryId)
        .setData({firebaseEndpoints.status: status.value});
  }
}

class SuperAdminRepositoryFirestoreImpl extends AdminRepositoryFirestoreImpl {
  Stream<void> addUserToAdmins(String userId) {
    return null;
  }

  Stream<void> removeUserFromAdmins(String userId) {
    return null;
  }
}
