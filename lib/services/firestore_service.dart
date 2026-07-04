import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/note.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _notesRef => _db.collection('notes');

  /// Live stream of the signed-in user's notes, ordered by most recent first.
  /// Throws if there is no signed-in user.
  Stream<List<Note>> getNotes() {
    final uid = _requireUid();
    return _notesRef
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Note.fromMap(data, doc.id);
          }).toList();
        });
  }

  /// Create a new note document for the signed-in user.
  Future<DocumentReference> addNote(Note note) {
    final uid = _requireUid();
    return _notesRef.add(note.copyWith(userId: uid).toMap());
  }

  /// Update an existing note by id.
  Future<void> updateNote(Note note) {
    final uid = _requireUid();
    return _notesRef.doc(note.id).update(note.copyWith(userId: uid).toMap());
  }

  /// Delete a note by id.
  Future<void> deleteNote(String id) {
    return _notesRef.doc(id).delete();
  }

  String _requireUid() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError(
        'No signed-in user. Sign in before reading or writing notes.',
      );
    }
    return user.uid;
  }
}
