class UserEntity {
  final String id;
  final String? displayName;
  final String? photoUrl;

  const UserEntity({
    required this.id,
    this.displayName,
    this.photoUrl,
  });
}