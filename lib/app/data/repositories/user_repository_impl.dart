import 'package:chatter_app/app/data/datasources/remote/firebase/user/firebase_user_datasource.dart';
import 'package:chatter_app/app/domain/entities/user_entity.dart';
import 'package:chatter_app/app/domain/repositories/user_repository.dart';

import '../models/user_model.dart';

class UserRepositoryImpl extends UserRepository {
  final FirebaseUserDataSource firebaseUserDataSource;

  UserRepositoryImpl({required this.firebaseUserDataSource});
  @override
  Future<void> addUser(UserEntity userEntity) {
    // TODO: implement addUser
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUser(String uid) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> getUser(String uid) async {
    var userModel = await firebaseUserDataSource.getUser(uid);
    return userModel.toEntity();
  }

  @override
  Future<void> updateUser(UserEntity userEntity) async {
    await firebaseUserDataSource.updateUser(UserModel.fromEntity(userEntity));
  }

  @override
  Future<UserEntity?> getUserByConversationId(String conversationId) async {
    final userModel =
        await firebaseUserDataSource.getUserByConversationId(conversationId);

    if (userModel != null) {
      return userModel.toEntity();
    } else {
      return null;
    }
  }
}
