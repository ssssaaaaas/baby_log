import 'package:cloud_firestore/cloud_firestore.dart';
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<void> saveDiaryEntry(String userId, DateTime date, String note, String? imageUrl) async {
    try {
      await _db.collection('diaries').doc(userId).collection('entries').doc(date.toIso8601String()).set({
        'note': note,
        'imageUrl': imageUrl,
        'date': date.toIso8601String(), // 저장할 때 date를 문자열로 저장
      });
    } catch (e) {
      print('Failed to save diary entry: $e');
      throw e;
    }
  }
  Future<DiaryEntry?> getDiaryEntry(String userId, DateTime date) async {
    try {
      final snapshot = await _db
          .collection('diaries')
          .doc(userId)
          .collection('entries')
          .doc(date.toIso8601String())
          .get();
      if (snapshot.exists) {
        return DiaryEntry.fromFirestore(snapshot.data()!);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching diary entry: $e');
      return null;
    }
  }
}
// DiaryEntry 클래스의 예시 (Firestore 데이터 모델)
class DiaryEntry {
  final String? note;
  final String? imageUrl;
  final DateTime? date;
  DiaryEntry({this.note, this.imageUrl, this.date});
  factory DiaryEntry.fromFirestore(Map<String, dynamic> data) {
    return DiaryEntry(
      note: data['note'],
      imageUrl: data['imageUrl'],
      date: DateTime.parse(data['date']), // 문자열을 DateTime으로 변환
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      'note': note,
      'imageUrl': imageUrl,
      'date': date?.toIso8601String(), // DateTime을 문자열로 변환
    };
  }
}