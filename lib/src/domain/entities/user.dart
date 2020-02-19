import 'package:meta/meta.dart';

enum UserFilter {
  all,
  users,
  admins,
}

class User {
  final String id;
  final String name;
  final String email;
  final String position;
  final String phone;
  final UserStatus status;

  User({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.position,
    @required this.phone,
    @required this.status,
  })  : assert(id != null),
        assert(name != null),
        assert(email != null),
        assert(position != null),
        assert(phone != null),
        assert(status != null);

  @override
  bool operator ==(Object other) =>
      other is User &&
      runtimeType == other.runtimeType &&
      id == other.id &&
      name == other.name &&
      email == other.email &&
      position == other.position &&
      phone == other.phone &&
      status == other.status;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      position.hashCode ^
      phone.hashCode ^
      status.hashCode;
}

class UserStatus {
  final int value;
  final String status;

  UserStatus._(this.value, this.status);

  factory UserStatus(int status) {
    switch (status) {
      case 1:
        return superAdmin;
      case 2:
        return admin;
      case 3:
        return user;
      case -1:
        return user;
    }
    throw ArgumentError();
  }

  static UserStatus get superAdmin {
    return UserStatus._(1, 'Super admin');
  }

  static UserStatus get admin {
    return UserStatus._(2, 'Admin');
  }

  static UserStatus get user {
    return UserStatus._(3, 'User');
  }

  static UserStatus get removedUser {
    return UserStatus._(-1, 'Removed User');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStatus &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
