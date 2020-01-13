import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

enum UserInventoryFilter {
  history,
  taken,
}

enum AdminInventoryFilter {
  all,
  free,
  taken,
  lost,
}

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
}

class InventoryStatus {
  final int value;
  final String status;

  InventoryStatus._(this.value, this.status);

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
    return InventoryStatus._(0, 'free');
  }

  static InventoryStatus get taken {
    return InventoryStatus._(1, 'taken');
  }

  static InventoryStatus get lost {
    return InventoryStatus._(2, 'lost');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryStatus &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class UserStatistic {
  final String userId;
  final InventoryStatus status;
  final DateTime dateTime;

  UserStatistic({
    @required this.userId,
    @required this.status,
    @required this.dateTime,
  })  : assert(userId != null),
        assert(status != null),
        assert(dateTime != null);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserStatistic &&
              runtimeType == other.runtimeType &&
              userId == other.userId &&
              status == other.status &&
              dateTime == other.dateTime;

  @override
  int get hashCode =>
      userId.hashCode ^
      status.hashCode ^
      dateTime.hashCode;

  String get dateFormatted {
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
  }

  static int reverseSort (UserStatistic a, UserStatistic b) {
    if(a.dateTime.isAfter(b.dateTime)) {
      return -1;
    } else if (a.dateTime.isBefore(b.dateTime)) {
      return 1;
    }
    return 0;
  }
}
