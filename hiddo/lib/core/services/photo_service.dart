import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PhotoService {
  final ImagePicker picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String?> takePhotoAndUpload({
    required String gameId,
    required String userId,
    required String item,
  }) async {
    try {
      final picked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (picked == null) return null;

      final safeItem = _sanitizeFileName(item);
      final path =
          'games/$gameId/$userId/${DateTime.now().millisecondsSinceEpoch}_$safeItem.jpg';

      final ref = storage.ref().child(path);

      if (kIsWeb) {
        final Uint8List bytes = await picked.readAsBytes();

        await ref.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else {
        final bytes = await picked.readAsBytes();

        await ref.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      }

      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      debugPrint('PHOTO UPLOAD ERROR: $e');
      rethrow;
    }
  }

  String _sanitizeFileName(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(' ', '_');
  }
}