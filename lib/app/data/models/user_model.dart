import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel(
      {super.uid,
      super.email,
      super.displayName,
      super.photoUrl,
      super.phone,
      super.conversationIds});

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      phone: data['phone'] ?? '',
      conversationIds: (data['conversationIds'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phone': phone,
      'conversationIds': conversationIds ?? []
    };
  }

  UserModel.fromEntity(UserEntity userEntity)
      : super(
            uid: userEntity.uid,
            email: userEntity.email,
            displayName: userEntity.displayName,
            photoUrl: userEntity.photoUrl,
            phone: userEntity.phone,
            conversationIds: userEntity.conversationIds);

  UserEntity toEntity() {
    return UserEntity(
        uid: uid,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
        phone: phone,
        conversationIds: conversationIds);
  }
}
