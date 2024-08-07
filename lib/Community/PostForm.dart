//게시물
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PostForm extends StatefulWidget {
  final String? postId;
  final String? initialType;

  PostForm({this.postId, this.initialType});

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _selectedType;
  final List<String> _categories = ['자유로그', '질문로그', '꿀팁로그', '자랑로그'];
  File? _image;

  @override
  void initState() {
    super.initState();
    if (widget.postId != null) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .get()
          .then((doc) {
        _titleController.text = doc['title'];
        _contentController.text = doc['content'];
        _selectedType = doc['type'];
        if (doc['image'] != null) {
          setState(() {
            _image = File(doc['image']);
          });
        }
      });
    } else {
      _selectedType = widget.initialType ?? _categories.first;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _savePost() async {
    final title = _titleController.text;
    final content = _contentController.text;

    if (_selectedType == null || title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            width: double.infinity,
            color: Color(0XFFFFDCB2),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                '모든 필드를 채워주세요!',
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
        ),
      );
      return;
    }

    final postData = {
      'title': title,
      'content': content,
      'type': _selectedType,
      'createdAt': Timestamp.now(),
    };

    if (_image != null) {
      postData['image'] = _image!.path;
    }

    if (widget.postId == null) {
      FirebaseFirestore.instance.collection('posts').add(postData);
    } else {
      FirebaseFirestore.instance.collection('posts').doc(widget.postId).update(postData);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, 'fromPostForm');
          },
          icon: Icon(Icons.arrow_back_ios, color: Color(0XFF1C1B1F)),
        ),
        title: Center(
          child: Text(
            '새 게시물',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0XFFFF9C27),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              '완료',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0XFFFF9C27),
              ),
            ),
            onPressed: _savePost,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8.0,
              children: _categories.map((category) {
                return ChoiceChip(
                  showCheckmark: false,
                  label: Text(
                    category,
                    style: TextStyle(
                      color: _selectedType == category ? Colors.white : Color(0XFFFF9C27),
                    ),
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: const Color(0XFFFF9C27),
                  side: BorderSide(color: Color(0XFFFF9C27)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                  selected: _selectedType == category,
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = selected ? category : null;
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            if (_selectedType == '자랑로그')
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _image != null
                      ? Image.file(_image!)
                      : Text('사진을 선택하세요'),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('사진 선택'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            TextField(
              controller: _titleController,
              cursorColor: Color(0XFFFFDCB2),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '제목',
                hintStyle: TextStyle(
                  color: Color(0XFFA8A8A8),
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
              maxLines: 1,
            ),
            Divider(thickness: 2, color: Color(0XFFF2F3F5)),
            TextField(
              controller: _contentController,
              cursorColor: Color(0XFFFFDCB2),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '내용을 입력하세요.',
                hintStyle: TextStyle(
                  color: Color(0XFFA8A8A8),
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                ),
              ),
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}