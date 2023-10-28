import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../models/user_model.dart';
import 'firebase_user_datasource.dart';

class FirebaseUserDataSourceImpl implements FirebaseUserDataSource {
  final FirebaseFirestore firestore;

  FirebaseUserDataSourceImpl({required this.firestore});

  @override
  Future<void> addUser(UserModel userModel) async {
    await firestore
        .collection('users')
        .doc(userModel.uid)
        .set(userModel.toMap());
  }

  @override
  Future<void> deleteUser(String uid) async {
    await firestore.collection('users').doc(uid).delete();
  }

  @override
  Future<UserModel> getUser(String uid) async {
    final userDocument = await firestore.collection('users').doc(uid).get();
    if (userDocument.exists) {
      final userData = userDocument.data();
      return UserModel.fromMap(userData!);
    } else {
      throw Exception('User not found');
    }
  }

  @override
  Future<void> updateUser(UserModel userModel) async {
    await firestore
        .collection('users')
        .doc(userModel.uid)
        .update(userModel.toMap());
  }

  @override
  Future<UserModel?> getUserByEmail(String email) async {
    final userQuery = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (userQuery.docs.isNotEmpty) {
      final userData = userQuery.docs.first.data();
      return UserModel.fromMap(userData);
    }
    return null;
  }

  @override
  Future<UserModel?> getUserByPhone(String phone) async {
    final userQuery = await firestore
        .collection('users')
        .where('phone', isEqualTo: phone)
        .get();

    if (userQuery.docs.isNotEmpty) {
      final userData = userQuery.docs.first.data();
      return UserModel.fromMap(userData);
    }
    return null;
  }
}
