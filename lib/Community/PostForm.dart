import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  Uint8List? _image;

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
      });
    } else {
      _selectedType = widget.initialType ?? _categories.first;
    }
  }

  void _savePost() {
    final title = _titleController.text;
    final content = _contentController.text;

    if (_selectedType == null || title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 채워주세요')),
      );
      return;
    }

    if (widget.postId == null) {
      FirebaseFirestore.instance.collection('posts').add({
        'title': title,
        'content': content,
        'type': _selectedType,
        'createdAt': Timestamp.now(),
        'image': _image,
      });
    } else {
      FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
        'title': title,
        'content': content,
        'type': _selectedType,
        'image': _image,
      });
    }

    Navigator.of(context).pop();
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _image = bytes;
      });
    }
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
            '글 쓰기',
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
            if (_selectedType == '자랑로그') ...[
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Stack(
                    children: [
                      if (_image != null)
                        Image.memory(_image!, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Icon(Icons.camera_alt_outlined, color: Colors.grey[600], size: 30),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 2,
                color: Color(0XFFF2F3F5),
              ),
            ],
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
            if (_selectedType != '자랑로그')
              Divider(
                thickness: 2,
                color: Color(0XFFF2F3F5),
              ),
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