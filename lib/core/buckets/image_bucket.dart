import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:rickandmorty/core/resources/data/data_state.dart';
import 'package:velocity_x/velocity_x.dart';

abstract class ImageBucket {
  final Reference _imageDirectoryReference;

  const ImageBucket(this._imageDirectoryReference);

  Future<DataState<String>> uploadImageByPath(
      String localPath, String remoteNameWithoutExtension) async {
    final file = File(localPath);
    if (await file.exists()) {
      try {
        final reference =
            _imageDirectoryReference.child("$remoteNameWithoutExtension.png");
        await reference.putFile(file);
        final downloadUrl = await reference.getDownloadURL();
        if (downloadUrl.isNotBlank) {
          return DataSuccess(downloadUrl);
        } else {
          return const DataFailed.withMessage(
              "Failed to get download URL for image.");
        }
      } on FirebaseException catch (e) {
        return DataFailed.withMessage(e.message ?? e.code);
      }
    }
    return const DataFailed.withMessage("The given image file does not exist.");
  }

  Future<DataState<String>> uploadImagePngRawData(
      Uint8List data, String remoteNameWithoutExtension) async {
    try {
      final reference =
          _imageDirectoryReference.child("$remoteNameWithoutExtension.png");
      await reference.putData(
        data,
        SettableMetadata(
            cacheControl: "public,max-age=300", contentType: "image/png"),
      );
      final downloadUrl = await reference.getDownloadURL();
      if (downloadUrl.isNotBlank) {
        return DataSuccess(downloadUrl);
      } else {
        return const DataFailed.withMessage(
            "Failed to get download URL for image.");
      }
    } on FirebaseException catch (e) {
      return DataFailed.withMessage(e.message ?? e.code);
    }
  }

  Future<DataState<String>> getImageDownloadUrl(String remoteName) async {
    try {
      final reference = _imageDirectoryReference.child(remoteName);
      final downloadUrl = await reference.getDownloadURL();
      if (downloadUrl.isNotBlank) {
        return DataSuccess(downloadUrl);
      } else {
        return const DataFailed.withMessage(
            "Failed to get download URL for image.");
      }
    } on FirebaseException catch (e) {
      return DataFailed.withMessage(e.message ?? e.code);
    }
  }
}
