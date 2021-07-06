import 'dart:io';

import 'package:flutter/foundation.dart';
import '../utils/upload_files_util.dart';

class ImageUploadProvider with ChangeNotifier {
  List<String?> _imageUrls = [];
  bool? _uploadingImages;

  bool? get isUploadingImages => _uploadingImages;
  List<String?> get imageUrls {
    return _imageUrls;
  }

  uploadImages(List<File> files) async {
    _uploadingImages = true;
    notifyListeners();
    for (var image in files) {
      String? _imageUrl = await uploadFile(image);
      _imageUrls.add(_imageUrl);
    }
    _uploadingImages = false;
    notifyListeners();
  }

  deleteImageUrls() {
    _imageUrls.clear();
    _uploadingImages = null;
    notifyListeners();
  }
}
