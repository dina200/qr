import 'package:meta/meta.dart';

import 'package:qr/src/domain/entities/user.dart';

class UserModel extends User {
  UserModel.fromJson(Map<String, dynamic> json)
      : super(
          id: json['id'] as String,
          name: json['name'] as String,
          surname: json['surname'] as String,
          phone: json['phone'] as String,
          status: UserStatus(json['userStatus'] as int),
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'phone': phone,
      'userStatus': status.value,
    };
  }

  UserModel({
    @required String id,
    @required String name,
    @required String surname,
    @required String phone,
    @required UserStatus status,
  }) : super(
          id: id,
          name: name,
          surname: surname,
          phone: phone,
          status: status,
        );
}
