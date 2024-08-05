import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'PostDetailScreen.dart';

class CommunityTab extends StatelessWidget {
  final String tabType;

  CommunityTab({required this.tabType});

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
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return ListTile(
              title: Text(post['title']),
              subtitle: Text(post['content']),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  FirebaseFirestore.instance.collection('posts').doc(post.id).delete();
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostDetailScreen(postId: post.id)),
                );
              },
            );
          },
        );
      },
    );
  }
}