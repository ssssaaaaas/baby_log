import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String note;
  final Timestamp timestamp;

  Note({
    required this.note,
    required this.timestamp,
  });

  factory Note.fromDocument(DocumentSnapshot doc) {
    return Note(
      note: doc['note'] ?? '',
      timestamp: doc['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'note': note,
      'timestamp': timestamp,
    };
  }
}