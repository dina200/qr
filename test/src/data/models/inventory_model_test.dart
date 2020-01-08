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
    status: InventoryStatus.lost,
    statistic: [
      UserStatisticModel(
        userId: "NAME1234567890",
        status: InventoryStatus.taken,
        dateTime: DateTime.fromMillisecondsSinceEpoch(1576836600000),
      ),
      UserStatisticModel(
        userId: "NAME1234567890",
        status: InventoryStatus.lost,
        dateTime: DateTime.fromMillisecondsSinceEpoch(1576836600000),
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
          "status": 2,
          "statistic": [
            {
              "userId": "NAME1234567890",
              "status": 1,
              "dateTime": 1576836600,
            },
            {
              "userId": "NAME1234567890",
              "status": 2,
              "dateTime": 1576836600,
            }
          ],
        };
        expect(result, equals(expectedInventoryJson));
      },
    );
  });
}
