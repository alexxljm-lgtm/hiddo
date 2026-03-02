import '../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> signInAnonymously();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> authStateChanges();
}