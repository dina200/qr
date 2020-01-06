import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/entities/user.dart';

abstract class UserRepository {
  Future<Inventory> getInventoryInfo(String inventoryId);

  Future<List<Inventory>> getTakenInventories(String userId);

  Future<List<Inventory>> getHistory(String userId);

  Future<void> takeInventory(String inventoryId);

  Future<void> returnInventory(String inventoryId);
}

abstract class AdminRepository extends UserRepository {
  Future<List<User>> getAllUsers();

  Future<User> getUserInfo(String userId);

  Future<List<Inventory>> getAllInventoriesInfo();

  Future<void> addNewInventoryToDatabase(Inventory inventory);

  Future<void> removeInventoryFromDatabase(String inventoryId);

  Future<void> setInventoryStatus(String inventoryId);
}

///Only for SuperAdmin
abstract class SuperAdminRepository extends AdminRepository {
  Future<void> addUserToAdmins(String userId);

  Future<void> removeUserFromAdmins(String userId);
}
