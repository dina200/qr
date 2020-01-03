import 'package:meta/meta.dart';

class Inventory {
  final String id;
  final String name;
  final String info;
  final InventoryStatus status;
  final List<UserStatistic> statistic;

  Inventory({
    @required this.id,
    @required this.name,
    @required this.info,
    @required this.status,
    List<UserStatistic> statistic,
  })  : statistic = statistic ?? [],
        assert(id != null),
        assert(name != null),
        assert(info != null),
        assert(status != null);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Inventory &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              info == other.info &&
              status == other.status;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      info.hashCode ^
      status.hashCode;

  @override
  String toString() {
    return 'Inventory{id: $id, name: $name, info: $info, status: $status, statistic: $statistic}';
  }
}

class InventoryStatus {
  final int value;

  InventoryStatus._(this.value);

  factory InventoryStatus(int status) {
    switch (status) {
      case 0:
        return free;
      case 1:
        return taken;
      case 2:
        return lost;
    }
    throw ArgumentError();
  }

  static InventoryStatus get free {
    return InventoryStatus._(0);
  }

  static InventoryStatus get taken {
    return InventoryStatus._(1);
  }

  static InventoryStatus get lost {
    return InventoryStatus._(2);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryStatus &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'InventoryStatus{value: $value}';
  }
}

class UserStatistic {
  final String userId;
  final DateTime taken;
  final DateTime returned;

  UserStatistic({
    @required this.userId,
    @required this.taken,
    this.returned,
  })  : assert(userId != null),
        assert(taken != null);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserStatistic &&
              runtimeType == other.runtimeType &&
              userId == other.userId &&
              taken == other.taken &&
              returned == other.returned;

  @override
  int get hashCode =>
      userId.hashCode ^
      taken.hashCode ^
      returned.hashCode;

  @override
  String toString() {
    return 'UserStatistic{userId: $userId, taken: $taken, returned: $returned}';
  }
}
