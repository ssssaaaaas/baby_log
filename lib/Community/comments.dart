import 'package:cloud_firestore/cloud_firestore.dart';

class CommentService {
  final String postId;

  CommentService(this.postId);

  Stream<int> getCommentCount() {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> addComment(String content) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').add({
      'content': content,
      'createdAt': Timestamp.now(),
    });
  }
}