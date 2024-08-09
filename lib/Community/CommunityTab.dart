import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'likes.dart';
import 'comments.dart';
import 'PostDetailScreen.dart';

class CommunityTab extends StatefulWidget {
  final String tabType;

  CommunityTab({required this.tabType});

  @override
  State<CommunityTab> createState() => _CommunityTabState();
}

class _CommunityTabState extends State<CommunityTab> {
  Stream<int> _getCommentCount(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> _getFavoriteCount(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .snapshots()
        .map((snapshot) => snapshot['likes'] ?? 0);
  }

  Future<void> _toggleFavorite(String postId, bool isFavorited) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

    // Firestore 트랜잭션 사용
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final postSnapshot = await transaction.get(postRef);

      if (!postSnapshot.exists) {
        throw Exception("Post does not exist!");
      }

      final currentFavoriteCount = postSnapshot.data()?['likes'] ?? 0;
      final currentIsFavorited = postSnapshot.data()?['isFavorited'] ?? false;

      if (currentIsFavorited) {
        // 현재 좋아요가 눌린 상태일 때
        await transaction.update(postRef, {
          'isFavorited': false,
          'likes': currentFavoriteCount - 1,
        });
      } else {
        // 현재 좋아요가 눌리지 않은 상태일 때
        await transaction.update(postRef, {
          'isFavorited': true,
          'likes': currentFavoriteCount + 1,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('type', isEqualTo: widget.tabType)
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
          separatorBuilder: (context, index) =>
              Divider(thickness: 2, color: Color(0XFFF2F3F5)),
          itemBuilder: (context, index) {
            final post = posts[index];
            final postId = post.id;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailScreen(postId: postId),
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
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        StreamBuilder<int>(
                          stream: _getCommentCount(postId),
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
                        SizedBox(width: 16),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(postId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Row(
                                children: [
                                  Icon(Icons.favorite_border),
                                  SizedBox(width: 4),
                                  Text('0'),
                                ],
                              );
                            }
                            final post = snapshot.data!;
                            final isFavorited =
                                post['isFavorited'] ?? false;
                            final favoriteCount = post['likes'] ?? 0;

                            return Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isFavorited
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFavorited
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                  onPressed: () async {
                                    await _toggleFavorite(postId, isFavorited);
                                  },
                                ),
                                SizedBox(width: 4),
                                Text('$favoriteCount'),
                              ],
                            );
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