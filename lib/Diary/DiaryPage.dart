import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'firestore_service.dart';

class DiaryPage extends StatefulWidget {
  final DateTime date;
  final String? initialNote;
  final Uint8List? initialImage;
  final void Function(Uint8List? image, String note) onSave;
  final VoidCallback onDelete;

  DiaryPage({
    required this.date,
    this.initialNote,
    this.initialImage,
    required this.onSave,
    required this.onDelete,
  });

  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  Uint8List? _image;
  late TextEditingController _noteController;
  final ImagePicker _picker = ImagePicker();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isSaved = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.initialNote);
    _image = widget.initialImage;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _image = imageBytes;
      });
    }
  }

  Future<void> _save() async {
    final user = FirebaseAuth.instance.currentUser;
    _showCustomSnackbar();
    widget.onSave(_image, _noteController.text);
    setState(() {
      _isSaved = true;
      _isEditing = false;
    });
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _isSaved = false;
    });
  }

  void _showBottomSheet() {
    if (!_isSaved) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0XFFFFF4E7),
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildBottomSheetTile(
                icon: Icons.edit,
                text: '수정',
                onTap: () {
                  Navigator.pop(context);
                  _startEditing();
                },
              ),
              Divider(color: Color(0XFFEEE5DA)),
              _buildBottomSheetTile(
                icon: Icons.delete,
                text: '삭제',
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmationDialog();
                },
              ),
              Divider(color: Color(0XFFEEE5DA)),
              _buildBottomSheetTile(
                text: '취소',
                onTap: () {
                  Navigator.pop(context);
                },
                isCancel: true,
              ),
            ],
          ),
        );
      },
    );
  }

  Container _buildBottomSheetTile({
    IconData? icon,
    required String text,
    required VoidCallback onTap,
    bool isCancel = false,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isCancel ? Colors.transparent : Color(0XFFFFF4E7),
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: <Widget>[
              if (icon != null)
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Icon(icon),
                ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '아니오',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.onDelete();
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: Text(
                '예',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
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
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left),
        ),
        title: Center(
          child: Text(
            DateFormat('yyyy년 M월').format(widget.date),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        actions: [
          if (!_isSaved)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _save,
            ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                    Spacer(),
                    if (_isSaved)
                      IconButton(
                        onPressed: _showBottomSheet,
                        icon: Icon(Icons.more_vert),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _noteController,
                      cursorColor: Color(0XFFFF9C27),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '소중한 추억을 기록하세요...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      maxLines: null,
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: Stack(
                          children: [
                            if (_image != null)
                              Image.memory(
                                _image!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
