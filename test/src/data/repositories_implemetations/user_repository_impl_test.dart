import 'package:test/test.dart';

import 'package:qr/src/data/models/inventory_model.dart';
import 'package:qr/src/domain/entities/inventory.dart';

import 'mocks/user_repository_mock.dart';

main() {
  final expectedInventory = InventoryModel(
      id: "ASDFGH1234567890",
      name: "Mouse",
      info: "Some info about the mouse",
      status: InventoryStatus.free,
      statistic: [
        UserStatistic(
          userId: "DARYA987654321",
          taken: DateTime.fromMillisecondsSinceEpoch(1577009400000),
          returned: DateTime.fromMillisecondsSinceEpoch(1577010000000),
        ),
        UserStatistic(
          userId: "NAME1234567890",
          taken: DateTime.fromMillisecondsSinceEpoch(1577010000000),
          returned: DateTime.fromMillisecondsSinceEpoch(1578009400000),
        ),
      ]);

  UserRepositoryMock _userRepository;

  setUp(() {
    _userRepository = UserRepositoryMock();
  });

  group('UserRepository', () {
    test(
      'getInventoryInfo',
      () async {
        final inventory =
            await _userRepository.getInventoryInfo('ASDFGH1234567890');
        expect(inventory, equals(expectedInventory));
      },
    );
  });
}
