import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'likes.dart';
import 'comments.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  PostDetailScreen({required this.postId});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late LikeService _likeService;
  late CommentService _commentService;
  late String _currentUserId;
  bool _isFavorited = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _currentUserId = user.uid;

      // LikeService와 CommentService를 초기화합니다.
      _likeService = LikeService(widget.postId, _currentUserId);
      _commentService = CommentService(widget.postId);

      // 좋아요 상태를 업데이트합니다.
      _updateFavoriteStatus();
    } else {
      // 사용자가 로그인하지 않았을 때의 처리
      print("사용자가 로그인하지 않았습니다.");
    }
  }

  Future<void> _updateFavoriteStatus() async {
    final isLiked = await _likeService.isFavorited();

    setState(() {
      _isFavorited = isLiked;
    });
  }

  void _toggleFavorite() async {
    await _likeService.toggleFavorite(_isFavorited);
    _updateFavoriteStatus();
  }

  void _addComment() async {
    final content = _commentController.text.trim();
    if (content.isNotEmpty) {
      await _commentService.addComment(content);
      _commentController.clear();
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context, 'fromPostDetailScreen');
        },
        icon: Icon(Icons.arrow_back_ios, color: Color(0XFF1C1B1F)),
      ),
      actions: [
        IconButton(
          icon: Icon(CupertinoIcons.ellipsis_vertical),
          onPressed: () {},
        ),
      ],
    ),
    backgroundColor: Colors.white,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('posts').doc(widget.postId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return Center(child: Text('게시글이 없습니다.'));
            }

            final post = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['title'],
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    post['content'],
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
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
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        Divider(thickness: 2, color: Color(0XFFF2F3F5)),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _commentService.getComments(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('답글이 없습니다.'));
              }

              final comments = snapshot.data!.docs;
              return ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return ListTile(
                    title: Text(
                      comment['content'],
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () => _commentService.likeComment(comment.id),
                        ),
                        Text('${comment['likesCount']}'),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    labelText: '답글을 작성하세요',
                    labelStyle: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onSubmitted: (_) => _addComment(),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: _addComment,
              ),
            ],
          ),
        ),
      ],
    ),
  );
 }
}