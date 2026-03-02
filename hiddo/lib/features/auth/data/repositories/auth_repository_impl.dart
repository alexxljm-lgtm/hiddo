import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl(this.remoteDatasource);

  @override
  Future<UserEntity> signInAnonymously() {
    return remoteDatasource.signInAnonymously();
  }

  @override
  Future<UserEntity?> getCurrentUser() {
    return remoteDatasource.getCurrentUser();
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return remoteDatasource.authStateChanges();
  }
}
