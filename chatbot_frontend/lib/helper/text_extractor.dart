
import 'dart:io';

import 'package:file_picker/file_picker.dart';

class TextExtractor {
  static Future<String?> fromFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      final message = await file.readAsString();
      if (message.isNotEmpty) {
        return message;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
