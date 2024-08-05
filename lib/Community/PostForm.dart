import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      _selectedType = widget.initialType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.postId == null ? '새 게시글' : '게시글 수정'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: '제목'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: '내용'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedType,
              items: ['자유로그', '질문로그', '꿀팁로그', '자랑로그'].map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedType = newValue;
                });
              },
              decoration: InputDecoration(labelText: '게시글 유형'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
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
                  });
                } else {
                  FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
                    'title': title,
                    'content': content,
                    'type': _selectedType,
                  });
                }

                Navigator.of(context).pop();
              },
              child: Text(widget.postId == null ? '게시글 작성' : '게시글 수정'),
            ),
          ],
        ),
      ),
    );
  }
}