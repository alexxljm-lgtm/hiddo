import 'package:image_picker/image_picker.dart';

class CameraService {

  final ImagePicker _picker = ImagePicker();

  Future<String?> takePhoto() async {

    final photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (photo == null) return null;

    return photo.path;
  }
}