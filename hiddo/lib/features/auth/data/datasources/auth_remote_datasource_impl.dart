import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDatasourceImpl(this.firebaseAuth);

  @override
  Future<UserModel> signInAnonymously() async {
    final credential = await firebaseAuth.signInAnonymously();
    final user = credential.user!;

    return UserModel.fromFirebaseUser(
      id: user.uid,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;

    if (user == null) return null;

    return UserModel.fromFirebaseUser(
      id: user.uid,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  @override
  Stream<UserModel?> authStateChanges() {
    return firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;

      return UserModel.fromFirebaseUser(
        id: user.uid,
        displayName: user.displayName,
        photoUrl: user.photoURL,
      );
    });
  }
}