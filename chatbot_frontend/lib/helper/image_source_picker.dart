import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourcePicker extends StatelessWidget {
  const ImageSourcePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: () async {
            await ImagePicker()
                .pickImage(
              source: ImageSource.camera,
              imageQuality: 85,
            )
                .then((value) async {
              if (value == null) {
                return;
              } else {
                final imageFile = File(value.path);
                _cropImage(imageFile).then((value) async {
                  if (value == null) return;
                  final imageFile = File(value);
                  Navigator.pop(context, imageFile);
                });
              }
            });
          },
          leading: const Icon(
            Icons.camera_alt,
            color: Colors.blue,
          ),
          title: const Text(
            "Camera",
            style: TextStyle(
                color: Color(0xff333333), fontWeight: FontWeight.w500),
          ),
        ),
        ListTile(
          onTap: () async {
            await ImagePicker()
                .pickImage(
              source: ImageSource.gallery,
              imageQuality: 85,
            )
                .then((value) async {
              if (value == null) {
                return;
              } else {
                final imageFile = File(value.path);
                _cropImage(imageFile).then((value) async {
                  if (value == null) return;
                  final imageFile = File(value);
                  Navigator.pop(context, imageFile);
                });
              }
            });
          },
          leading: const Icon(
            Icons.photo,
            color: Colors.blue,
          ),
          title: const Text(
            "Gallery",
            style: TextStyle(
                color: Color(0xff333333), fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }


  Future<String?> _cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Your Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            hideBottomControls: true,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Crop Your Image',
        ),
      ],
    );
    return croppedFile!.path;
  }
}
