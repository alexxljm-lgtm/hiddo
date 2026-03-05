import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hiddo/features/game/data/datasources/photo_storage_datasource.dart';
import 'package:hiddo/features/game/data/datasources/photo_storage_datasource_impl.dart';
import 'package:hiddo/features/game/domain/entities/game.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/sign_in_anonymously.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiddo/features/auth/data/datasources/auth_firestore_datasource.dart';
import 'package:hiddo/features/auth/data/datasources/auth_firestore_datasource_impl.dart';
import 'package:hiddo/features/game/data/datasources/game_firestore_datasource.dart';
import 'package:hiddo/features/game/data/datasources/game_firestore_datasource_impl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hiddo/core/services/camera_service.dart';


final gameFirestoreDatasourceProvider =
    Provider<GameFirestoreDatasource>((ref) {

  final firestore = ref.read(firestoreProvider);

  return GameFirestoreDatasourceImpl(firestore);

});

final gameStreamProvider = StreamProvider.family<Game, String>((ref, gameId) {
  final datasource = ref.read(gameFirestoreDatasourceProvider);
  return datasource.watchGame(gameId);
});

final cameraServiceProvider = Provider<CameraService>((ref) {
  return CameraService();
});

final storageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final photoStorageDatasourceProvider =
    Provider<PhotoStorageDatasource>((ref) {

  final storage = ref.read(storageProvider);

  return PhotoStorageDatasourceImpl(storage);
});

final authFirestoreDatasourceProvider = Provider<AuthFirestoreDatasource>((ref) {
  final firestore = ref.read(firestoreProvider);
  return AuthFirestoreDatasourceImpl(firestore);
});

// Firebase
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Datasource
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  return AuthRemoteDatasourceImpl(firebaseAuth);
});

// Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDatasource = ref.read(authRemoteDatasourceProvider);
  return AuthRepositoryImpl(remoteDatasource);
});

// Usecase
final signInAnonymouslyProvider = Provider<SignInAnonymously>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return SignInAnonymously(repository);
});