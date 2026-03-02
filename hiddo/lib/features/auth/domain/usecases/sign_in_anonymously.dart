import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInAnonymously {
  final AuthRepository repository;

  SignInAnonymously(this.repository);

  Future<UserEntity> call() async {
    return await repository.signInAnonymously();
  }
}