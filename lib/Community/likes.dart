import 'package:cloud_firestore/cloud_firestore.dart';

class LikeService {
  final String postId;
  final String userId;

  LikeService(this.postId, this.userId);

  // 실시간 좋아요 수 스트림
  Stream<int> getFavoriteCount() {
    final likesRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes');

    return likesRef.snapshots().map((snapshot) => snapshot.docs.length);
  }

  // 특정 사용자가 해당 게시물에 좋아요를 눌렀는가
  Future<bool> isFavorited() async {
    final likesRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes');

    final userLikeRef = likesRef.doc(userId);
    final isLiked = await userLikeRef.get().then((doc) => doc.exists);
    return isLiked;
  }

  // 좋아요를 누르거나 취소
  Future<void> toggleFavorite(bool isFavorited) async {
    final likesRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes');

    final userLikeRef = likesRef.doc(userId);

    if (isFavorited) {
      await userLikeRef.delete();
    } else {
      await userLikeRef.set({'likedAt': Timestamp.now()});
    }

    // 좋아요 수 업데이트
    await updateFavoriteCount();
  }

  // 게시물의 좋아요 수를 firestore에 업데이트
  Future<void> updateFavoriteCount() async {
    final likesRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes');

    final likeCount = await likesRef.get().then((snapshot) => snapshot.docs.length);

    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    await postRef.update({
      'likes': likeCount,
    });
  }
}