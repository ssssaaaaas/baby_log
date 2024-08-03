import 'dart:io';
import 'package:baby_log/Diary/Calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class DiaryPage extends StatefulWidget {
  final DateTime date;
  final Image? initialImage;
  final String? initialNote;
  final void Function(Image? image, String note) onSave;

  DiaryPage({
    required this.date,
    this.initialImage,
    this.initialNote,
    required this.onSave,
  });

  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  late Image? _image;
  late TextEditingController _noteController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _image = widget.initialImage;
    _noteController = TextEditingController(text: widget.initialNote);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = Image.file(File(pickedFile.path));
      });
    }
  }

  void _save() {
    widget.onSave(_image, _noteController.text);
    _showCustomSnackbar();
  }

  void _showCustomSnackbar() {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final snackbar = SnackBar(
      content: Container(
        width: double.infinity,
        color: Color(0XFFFFDCB2),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text(
            '저장되었습니다!',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Color(0XFFFFDCB2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0,
      duration: Duration(seconds: 1),
    );

    scaffoldMessenger.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => Calendar()),
            );
          },
          icon: Icon(CupertinoIcons.xmark),
        ),
        title: Center(
          child: Text(
            DateFormat('yyyy년 M월').format(widget.date),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _save,
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Text(
                    '${DateFormat('d ').format(widget.date)}',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '${DateFormat('EEEE').format(widget.date)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Stack(
              children: <Widget>[
                TextField(
                  controller: _noteController,
                  cursorColor: Color(0XFFFFDCB2),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    hintText: '소중한 추억을 기록하세요...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  maxLines: 15,
                  onTap: () {
                    if (_noteController.text.isEmpty) {
                      _noteController.text = '';
                    }
                  },
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(CupertinoIcons.photo),
                    onPressed: _pickImage,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (_image != null) Image(image: _image!.image),
          ],
        ),
      ),
    );
  }
}
