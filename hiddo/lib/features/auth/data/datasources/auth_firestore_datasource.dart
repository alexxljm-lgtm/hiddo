import '../../domain/entities/user.dart';

abstract class AuthFirestoreDatasource {
  Future<void> createUser(UserEntity user);
}