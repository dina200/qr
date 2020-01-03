import 'dart:convert';

import 'package:test/test.dart';

import 'package:qr/src/data/models/inventory_model.dart';
import 'package:qr/src/domain/entities/inventory.dart';

import '../../../fixtures/fixture_reader.dart';

main() {
  final inventoryModelEmptyStatistic = InventoryModel(
    id: 'ZXCVBN0987654321',
    name: 'Keyboard',
    info: 'Some info about the keyboard',
    status: InventoryStatus.free,
  );

  final inventoryModel = InventoryModel(
    id: 'QWERTY1234567890',
    name: 'Phone',
    info: 'Some info',
    status: InventoryStatus.taken,
    statistic: [
      UserStatisticModel(
        userId: "NAME1234567890",
        taken: DateTime.fromMillisecondsSinceEpoch(1575972600000),
        returned: DateTime.fromMillisecondsSinceEpoch(1576836600000),
      ),
      UserStatisticModel(
        userId: "DARYA987654321",
        taken: DateTime.fromMillisecondsSinceEpoch(1576836600000),
      ),
    ],
  );

  test(
    'Inventory type',
    () {
      expect(inventoryModelEmptyStatistic, isA<Inventory>());
      expect(inventoryModel, isA<Inventory>());
    },
  );

  group('fromJson', () {
    test(
      'get model from jsonList: empty statistic',
      () {
        final listJson = json.decode(fixture('all_inventories.json'));
        final jsonModel =
            listJson.where(((obj) => obj['id'] == 'ZXCVBN0987654321')).first;

        final result = InventoryModel.fromJson(jsonModel);
        expect(result, equals(inventoryModelEmptyStatistic));
      },
    );

    test(
      'get model from jsonList: statistic',
      () {
        final listJson = json.decode(fixture('all_inventories.json'));
        final jsonModel =
            listJson.where(((obj) => obj['id'] == 'QWERTY1234567890')).first;
        final result = InventoryModel.fromJson(jsonModel);
        print(result);
        print(inventoryModel);
        expect(result, equals(inventoryModel));
      },
    );
  });

  group('toJson', () {
    test(
      'convert model to Json: empty statistic',
      () {
        final result = inventoryModelEmptyStatistic.toJson();

        final expectedInventoryJson = {
          "id": "ZXCVBN0987654321",
          "name": "Keyboard",
          "info": "Some info about the keyboard",
          "status": 0,
          "statistic": [],
        };
        expect(result, equals(expectedInventoryJson));
      },
    );

    test(
      'convert model to Json: statistic',
      () {
        final result = inventoryModel.toJson();
        final expectedInventoryJson = {
          "id": "QWERTY1234567890",
          "name": "Phone",
          "info": "Some info",
          "status": 1,
          "statistic": [
            {
              "userId": "NAME1234567890",
              "taken": 1575972600,
              "returned": 1576836600
            },
            {
              "userId": "DARYA987654321",
              "taken": 1576836600,
            }
          ],
        };
        expect(result, equals(expectedInventoryJson));
      },
    );
  });
}
