import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

Future<Uint8List> imagePicker(ImageSource imageSource) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: imageSource);

  if (file != null) {
    return await file.readAsBytes();
  } else {
    throw Exception;
  }
}
