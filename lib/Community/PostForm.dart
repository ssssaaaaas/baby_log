import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'likes.dart';
import 'comments.dart';

class PostForm extends StatefulWidget {
  final String? postId;
  final String? initialType;
  final String currentUserId;

  PostForm({this.postId, this.initialType, required this.currentUserId});

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _selectedType;
  final List<String> _categories = ['자유로그', '질문로그', '꿀팁로그', '자랑로그'];
  Uint8List? _image;
  bool _isFavorited = false;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _commentFocusNode = FocusNode();

  late LikeService _likeService;
  late CommentService _commentService;
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = widget.currentUserId;
    if (widget.postId != null) {
      _initializePost();
    } else {
      _selectedType = widget.initialType ?? _categories.first;
      _titleController.text = '';
      _contentController.text = '';
      _initLikeAndCommentServices(null);
    }
  }

Future<void> _initializePost() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('posts').doc(widget.postId!).get();
      if (doc.exists) {
        setState(() {
          _titleController.text = doc['title'];
          _contentController.text = doc['content'];
          _selectedType = doc['type'];
          _initLikeAndCommentServices(widget.postId!);
          _updateFavoriteStatus();
        });
      } else {
        print('Document does not exist.');
      }
    } catch (e) {
      print("Error fetching post: $e");
    }
  }

  // ....
  void _updateFavoriteStatus() async {
    if (_likeService == null) return; // _likeService가 초기화되지 않은 경우 방지

    final isLiked = await _likeService.isFavorited();
    if (mounted) { // 위젯이 여전히 화면에 있는지 확인
      setState(() {
        _isFavorited = isLiked;
      });
    }
  }

  void _initLikeAndCommentServices(String? postId) {
    _likeService = LikeService(postId!, _currentUserId);
    _commentService = CommentService(postId);
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
        'isFavorited': false,
        'likes': 0,
        'authorId': _currentUserId,
      }).then((docRef) {
        setState(() {
          _likeService = LikeService(docRef.id, _currentUserId);
          _commentService = CommentService(docRef.id);
          _initLikeAndCommentServices(docRef.id);
        });
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

  void _toggleFavorite() async {
    if (widget.postId == null) return;

    await _likeService.toggleFavorite(_isFavorited);
    _updateFavoriteStatus();
  }

  void _scrollToComment() {
    _scrollController
        .animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    )
        .then((value) {
      FocusScope.of(context).requestFocus(_commentFocusNode);
    });
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
            '업로드되었습니다!',
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
          OutlinedButton(
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
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
              Divider(thickness: 2, color: Color(0XFFF2F3F5)),
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
            SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorited ? Colors.red : Colors.black,
                  ),
                  onPressed: _toggleFavorite,
                ),
                StreamBuilder<int>(
                  stream: _likeService.getFavoriteCount(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text('0');
                    }
                    return Text('${snapshot.data}');
                  },
                ),
                StreamBuilder<int>(
                  stream: _commentService.getCommentCount(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text('0');
                    }
                    return Text('${snapshot.data}');
                  },
                ),
                IconButton(
                  icon: Icon(CupertinoIcons.chat_bubble_2),
                  onPressed: _scrollToComment,
                ),
                IconButton(
                  icon: Icon(Icons.bookmark_border),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}