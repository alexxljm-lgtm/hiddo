import '../../domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    super.displayName,
    super.photoUrl,
  });

  factory UserModel.fromFirebaseUser(
      {required String id,
      String? displayName,
      String? photoUrl}) {
    return UserModel(
      id: id,
      displayName: displayName,
      photoUrl: photoUrl,
    );
  }
}