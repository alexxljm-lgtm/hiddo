import '../entities/user.dart';

abstract class AuthRepository {
  Future<UserEntity> signInAnonymously();
  Future<UserEntity?> getCurrentUser();
  Stream<UserEntity?> authStateChanges();
}