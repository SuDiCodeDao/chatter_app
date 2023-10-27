import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<void> addUser(UserEntity userEntity);
  Future<UserEntity> getUser(String uid);
  Future<void> deleteUser(String uid);
  Future<void> updateUser(UserEntity userEntity);
}
