import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

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

  static Future<String?> fromImage(File image) async {
    final textRecognizer = TextRecognizer();
    final inputImage = InputImage.fromFile(image);
    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    String scannedText = '';

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = "$scannedText${line.text}\n";
      }
    }
    return scannedText;
  }
}
