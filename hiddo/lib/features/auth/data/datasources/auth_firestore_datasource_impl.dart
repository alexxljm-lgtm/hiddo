import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user.dart';
import '../models/user_model.dart';
import 'auth_firestore_datasource.dart';

class AuthFirestoreDatasourceImpl implements AuthFirestoreDatasource {
  final FirebaseFirestore firestore;

  AuthFirestoreDatasourceImpl(this.firestore);

  @override
  Future<void> createUser(UserEntity user) async {

    final userModel = UserModel(
      id: user.id,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
    );

    final userRef = firestore.collection('users').doc(userModel.id);

    await userRef.set({
      'id': userModel.id,
      'displayName': userModel.displayName ?? '',
      'photoUrl': userModel.photoUrl ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}