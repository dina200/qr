import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/entities/user.dart';

abstract class UserRepository {
  Future<Inventory> getInventoryInfo(String inventoryId);

  Future<List<Inventory>> getTakenInventories(String userId);

  Future<List<Inventory>> getHistory(String userId);

  Future<void> takeInventory(String inventoryId);//todo: test

  Future<void> returnInventory(String inventoryId);//todo: test
}

abstract class AdminRepository extends UserRepository {
  Future<List<User>> getAllUsers();//todo: test

  Future<User> getUserInfo(String userId);//todo: test

  Future<List<Inventory>> getAllInventoriesInfo();//todo: test

  Future<void> addNewInventoryToDatabase(Inventory inventory);//todo: test

  Future<void> removeInventoryFromDatabase(String inventoryId);//todo: test

  Future<void> setInventoryStatus(String inventoryId);//todo: test
}

///Only for SuperAdmin
abstract class SuperAdminRepository extends AdminRepository {
  Future<void> addUserToAdmins(String userId);//todo: test

  Future<void> removeUserFromAdmins(String userId);//todo: test
}
