

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel(
      {super.uid, super.email, super.displayName, super.phone, super.photoUrl});

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      phone: data['phone'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phone': phone,
      'photoUrl': photoUrl,
    };
  }

  UserModel.fromEntity(UserEntity userEntity)
      : super(
            uid: userEntity.uid,
            email: userEntity.email,
            displayName: userEntity.displayName,
            phone: userEntity.phone,
            photoUrl: userEntity.photoUrl);

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      displayName: displayName,
      phone: phone,
      photoUrl: photoUrl,
    );
  }
}
