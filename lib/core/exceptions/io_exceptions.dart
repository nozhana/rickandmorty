import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerException implements IOException {
  final ImageSource imageSource;
  final String? message;

  const ImagePickerException(this.imageSource, {this.message});

  @override
  String toString() => "ImagePickerException($imageSource, \"$message\")";
}
