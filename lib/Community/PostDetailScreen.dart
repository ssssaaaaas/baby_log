import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool _isFavorited = false;
  int _favoriteCount = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _likeService = LikeService(widget.postId, "현재 사용자 ID"); // 실제 사용자 ID로 대체해야 함
    _commentService = CommentService(widget.postId);

    _updateFavoriteCountAndStatus();
  }

  void _updateFavoriteCountAndStatus() async {
    final likeCount = await _likeService.getFavoriteCount();
    final isLiked = await _likeService.isFavorited();

    setState(() {
      _favoriteCount = likeCount;
      _isFavorited = isLiked;
    });
  }

  void _toggleFavorite() async {
    await _likeService.toggleFavorite(_isFavorited);
    _updateFavoriteCountAndStatus();
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
                        Text('$_favoriteCount'),
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
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .snapshots(),
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