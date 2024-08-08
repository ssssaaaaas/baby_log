import 'package:cloud_firestore/cloud_firestore.dart';

class LikeService {
  final String postId;
  final String userId;

  LikeService(this.postId, this.userId);

  Future<int> getFavoriteCount() async {
    final likesRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes');

    final likeCount = await likesRef.get().then((snapshot) => snapshot.docs.length);
    return likeCount;
  }

  Future<bool> isFavorited() async {
    final likesRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes');

    final userLikeRef = likesRef.doc(userId);
    final isLiked = await userLikeRef.get().then((doc) => doc.exists);
    return isLiked;
  }

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
  }
}