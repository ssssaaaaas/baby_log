import 'package:cloud_firestore/cloud_firestore.dart';

class CommentService {
  final String postId;

  CommentService(this.postId);

  // 실시간으로 댓글 수 스트림을 제공
  Stream<int> getCommentCount() {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // 댓글 추가
  Future<void> addComment(String content) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').add({
      'content': content,
      'createdAt': Timestamp.now(),
      'likesCount': 0,
    });
  }

  // 댓글 좋아요 수 증가
  Future<void> likeComment(String commentId) async {
    final commentRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final commentSnapshot = await transaction.get(commentRef);
      if (commentSnapshot.exists) {
        final currentLikes = commentSnapshot.data()?['likesCount'] ?? 0;
        transaction.update(commentRef, {'likesCount': currentLikes + 1});
      }
    });
  }

  // 댓글 스트림
  Stream<QuerySnapshot> getComments() {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}