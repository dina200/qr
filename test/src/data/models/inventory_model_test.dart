import 'dart:convert';

import 'package:test/test.dart';

import 'package:qr/src/data/models/inventory_model.dart';
import 'package:qr/src/domain/entities/inventory.dart';

import '../../../fixtures/fixture_reader.dart';

main() {
  final inventoryModel = InventoryModel(
    id: 'ZXCVBN0987654321',
    name: 'Keyboard',
    info: 'Some info about the keyboard',
    status: InventoryStatus.free,
  );

  test(
    'Inventory type',
    () async {
      expect(inventoryModel, isA<Inventory>());
    },
  );

  group('fromJson', () {
    test(
      'get model from jsonList',
      () async {
        final listJson = json.decode(fixture('all_inventories.json'));
        final jsonModel =
            listJson.where(((obj) => obj['id'] == 'ZXCVBN0987654321')).first;

        final result = InventoryModel.fromJson(jsonModel);
        expect(result, equals(inventoryModel));
      },
    );
  });

  group('toJson', () {
    test(
      'convert model to Json',
      () async {
        final result = inventoryModel.toJson();
        final expectedInventoryJson =  {
          "id": "ZXCVBN0987654321",
          "name": "Keyboard",
          "info": "Some info about the keyboard",
          "status": 0,
          "statistic": []
        };
        expect(result, equals(expectedInventoryJson));
      },
    );
  });
}
