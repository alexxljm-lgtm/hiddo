abstract class PhotoStorageDatasource {

  Future<String> uploadPhoto({
    required String gameId,
    required String userId,
    required String item,
    required String filePath,
  });

}