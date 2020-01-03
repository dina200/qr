import 'package:meta/meta.dart';

import 'package:qr/src/domain/entities/inventory.dart';

class InventoryModel extends Inventory {
  InventoryModel({
    @required String id,
    @required String name,
    @required String info,
    @required InventoryStatus status,
    List<UserStatistic> statistic,
  }) : super(
          id: id,
          name: name,
          info: info,
          status: status,
          statistic: statistic,
        );

  InventoryModel.fromJson(Map<String, dynamic> json)
      : super(
          id: json['id'] as String,
          name: json['name'] as String,
          info: json['info'] as String,
          status: InventoryStatus(json['status'] as int),
          statistic: (json['statistic'] as List)
              ?.map((e) => e == null
                  ? null
                  : UserStatisticModel.fromJson(e as Map<String, dynamic>))
              ?.toList(),
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'info': info,
      'status': status.value,
      'statistic':
          statistic?.map((e) => (e as UserStatisticModel)?.toJson())?.toList(),
    };
  }
}

class UserStatisticModel extends UserStatistic {
  UserStatisticModel({
    @required String userId,
    @required DateTime taken,
    DateTime returned,
  }) : super(
          userId: userId,
          taken: taken,
          returned: returned,
        );

  UserStatisticModel.fromJson(Map<String, dynamic> json)
      : super(
          userId: json['userId'] as String,
          taken: _fromTimestamp(json['taken'] as int),
          returned: _fromTimestamp(json['returned'] as int),
        );

  static DateTime _fromTimestamp(int timestamp) {
    return timestamp != null
        ? DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000)
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'taken': _toTimestamp(taken),
      if(returned != null) 'returned': _toTimestamp(returned),
    };
  }

  int _toTimestamp(DateTime dateTime) {
    return dateTime != null ? (dateTime.millisecondsSinceEpoch ~/ 1000) : null;
  }
}
