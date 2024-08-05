import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  final Function(Uint8List?) onPickImage;

  const UploadImage({super.key, required this.onPickImage});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  Uint8List? file;

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        file = bytes;
      });
      widget.onPickImage(bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.grey[300],
        height: 400,
        width: 400,
        child: (file != null)
            ? Image.memory(
                file!,
                fit: BoxFit.cover,
              )
            : IconButton(
                onPressed: _pickImage,
                icon: Icon(Icons.image),
                iconSize: 50,
                color: Colors.white,
              ),
      ),
    );
  }
}