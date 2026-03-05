import '../../data/datasources/photo_storage_datasource.dart';

class UploadPhoto {

  final PhotoStorageDatasource datasource;

  UploadPhoto(this.datasource);

  Future<String> call({
    required String gameId,
    required String userId,
    required String item,
    required String filePath,
  }) {

    return datasource.uploadPhoto(
      gameId: gameId,
      userId: userId,
      item: item,
      filePath: filePath,
    );
  }

}