import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey[300],
        child: GestureDetector(
          onTap: _pickImage,
          child: ClipOval(
            child: _selectedImage != null
                ? Image.file(
                    _selectedImage!,
                    width: 65,
                    height: 65,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 35,
                    height: 35,
                    color: Colors.grey[400],
                    child: const Icon(
                      Icons.camera_alt,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
