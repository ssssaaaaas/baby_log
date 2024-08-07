import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserData(String uid, String note) async {
    try {
      await _db.collection('users').doc(uid).collection('notes').add({
        'note': note,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> getUserNotes(String uid) async {
    try {
      QuerySnapshot snapshot = await _db.collection('users').doc(uid).collection('notes').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}