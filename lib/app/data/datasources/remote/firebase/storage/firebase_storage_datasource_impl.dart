import 'dart:io';

import 'package:chatter_app/app/data/datasources/remote/firebase/storage/firebase_storage_datasource.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageDataSourceImpl extends FirebaseStorageDataSource {
  final FirebaseStorage _firebaseStorage;

  FirebaseStorageDataSourceImpl({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  @override
  Future<String> uploadImage(String imagePath, String imageName) async {
    try {
      final storageRef = _firebaseStorage.ref().child(imageName);
      final uploadTask = storageRef.putFile(File(imagePath));
      await uploadTask.whenComplete(() {});
      final downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      throw Exception('Lỗi khi tải lên hình ảnh: $e');
    }
  }
}
