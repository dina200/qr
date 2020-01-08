import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/entities/user.dart';

abstract class UserRepository {
  Future<void> init();

  User get currentUser;

  Future<Inventory> getInventoryInfo(String inventoryId);

  Future<List<Inventory>> getCurrentUserHistory();

  Future<List<Inventory>> getCurrentUserTakenInventories();

  Future<void> takeInventory(String inventoryId);

  Future<void> returnInventory(String inventoryId);
}

abstract class AdminRepository extends UserRepository {
  Future<List<User>> getAllUsers();

  Future<User> getUserInfo(String userId);

  Future<List<Inventory>> getUserHistory(String userId);

  Future<List<Inventory>> getTakenInventoriesByUser(String userId);

  Future<List<Inventory>> getAllInventoriesInfo();

  Future<void> addNewInventoryToDatabase(String id, String name, String info);

  Future<void> removeInventoryFromDatabase(String inventoryId);

  Future<void> setInventoryStatus(String inventoryId, InventoryStatus status);
}

///Only for SuperAdmin
abstract class SuperAdminRepository extends AdminRepository {
  Future<void> addUserToAdmins(String userId);

  Future<void> removeUserFromAdmins(String userId);

  Future<void> removeInventoryStatistic(String inventoryId);
}
