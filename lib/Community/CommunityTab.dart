import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'likes.dart';  // 좋아요 기능을 위한 파일
import 'comments.dart';  // 댓글 기능을 위한 파일
import 'PostDetailScreen.dart';

class CommunityTab extends StatelessWidget {
  final String tabType;

  CommunityTab({required this.tabType});

  Stream<int> _getCommentCount(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> _toggleFavorite(DocumentSnapshot post) async {
    final postId = post.id;
    final likes = post['likes'] ?? 0;
    final isFavorited = post['isFavorited'] ?? false; // 필드가 없을 경우 false로 처리

    final likeService = LikeService(postId, "현재 사용자 ID"); // 실제 사용자 ID로 대체해야 함

    await likeService.toggleFavorite(isFavorited);

    // 최신 데이터로 업데이트
    final updatedLikes = await likeService.getFavoriteCount();
    FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'likes': updatedLikes,
      'isFavorited': !isFavorited,
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('type', isEqualTo: tabType)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('게시글이 없습니다.'));
        }

        final posts = snapshot.data!.docs;
        return ListView.separated(
          itemCount: posts.length,
          separatorBuilder: (context, index) => Divider(thickness: 2, color: Color(0XFFF2F3F5)),
          itemBuilder: (context, index) {
            final post = posts[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailScreen(postId: post.id),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      post['content'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // 넘칠 경우 '...' 표시
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        StreamBuilder<int>(
                          stream: _getCommentCount(post.id),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Row(
                                children: [
                                  Icon(Symbols.message),
                                  SizedBox(width: 4),
                                  Text('0'),
                                ],
                              );
                            }
                            return Row(
                              children: [
                                Icon(Symbols.message),
                                SizedBox(width: 4),
                                Text('${snapshot.data}'),
                              ],
                            );
                          },
                        ),
                        SizedBox(width: 16), // 아이콘 간격 추가
                        FutureBuilder<bool>(
                          future: LikeService(post.id, "현재 사용자 ID").isFavorited(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Icon(Icons.favorite_border);
                            }
                            final isFavorited = snapshot.data!;
                            return IconButton(
                              icon: Icon(
                                isFavorited ? Icons.favorite : Icons.favorite_border,
                                color: isFavorited ? Colors.red : Colors.black,
                              ),
                              onPressed: () => _toggleFavorite(post),
                            );
                          },
                        ),
                        FutureBuilder<int>(
                          future: LikeService(post.id, "현재 사용자 ID").getFavoriteCount(),
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
              ),
            );
          },
        );
      },
    );
  }
}
