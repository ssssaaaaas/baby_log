import 'dart:io';
import 'package:baby_log/Diary/UploadImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';

class DiaryPage extends StatefulWidget {
  final DateTime date;
  final Image? initialImage;
  final String? initialNote;
  final void Function(Image? image, String note) onSave;
  final VoidCallback onDelete;

  DiaryPage({
    required this.date,
    this.initialImage,
    this.initialNote,
    required this.onSave,
    required this.onDelete,
  });

  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  late Image? _image;
  late TextEditingController _noteController;
  final ImagePicker _picker = ImagePicker();
  double _imageHeight = 200;
  bool _isSaved = false;
  bool _isEditing = false;

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
    setState(() {
      _isSaved = true;
      _isEditing = false;
    });
    _showCustomSnackbar();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _isSaved = false;
    });
  }

  void _showBottomSheet() {
    if (!_isSaved) return; // 저장되지 않은 경우 바텀시트 표시하지 않음
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0XFFFFF4E7),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(8),
              bottom: Radius.circular(8),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildBottomSheetTile(
                icon: Symbols.edit,
                text: '수정',
                onTap: () {
                  Navigator.pop(context);
                  _startEditing();
                },
              ),
              Divider(color: Color(0XFFEEE5DA)),
              _buildBottomSheetTile(
                icon: CupertinoIcons.delete,
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
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
          bottom: Radius.circular(8),
        ),
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
                Navigator.pop(context); // 달력 페이지로 돌아가기
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
                        icon: Icon(CupertinoIcons.ellipsis),
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
                      cursorColor: Color(0XFFFFDCB2),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '소중한 추억을 기록하세요...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      maxLines: null,
                    ),
                    SizedBox(height: 10),
                    if (_image != null)
                      Column(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: _imageHeight,
                            ),
                            child: _image,
                          ),
                          Slider(
                            value: _imageHeight,
                            min: 100,
                            max: 400,
                            divisions: 10,
                            label: 'Image Height',
                            onChanged: (double value) {
                              setState(() {
                                _imageHeight = value;
                              });
                            },
                          ),
                        ],
                      ),
                    SizedBox(height: 10),
                    UploadImage(
                      onPickImage: (image) {
                        setState(() {
                          _image = image as Image?;
                        });
                      },
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
