import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'photo_storage_datasource.dart';

class PhotoStorageDatasourceImpl implements PhotoStorageDatasource {

  final FirebaseStorage storage;

  PhotoStorageDatasourceImpl(this.storage);

  @override
  Future<String> uploadPhoto({
    required String gameId,
    required String userId,
    required String item,
    required String filePath,
  }) async {

    final ref = storage
        .ref()
        .child('games/$gameId/$userId/$item.jpg');

    final file = File(filePath);

    await ref.putFile(file);

    final url = await ref.getDownloadURL();

    return url;
  }
}