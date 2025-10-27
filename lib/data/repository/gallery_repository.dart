import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/image_model.dart';

class PageResult {
  final List<ImageDoc> items;
  final DocumentSnapshot<Map<String, dynamic>>? lastDoc;
  PageResult({required this.items, required this.lastDoc});
}

class GalleryRepository {
  final _col = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('picture_storage')
      .withConverter(
        fromFirestore: (snap, _) => snap.data()!,
        toFirestore: (data, _) => data,
      );

  Future<PageResult> fetchPage({
    int limit = 18,
    DocumentSnapshot<Map<String, dynamic>>? cursor,
  }) async {
    Query<Map<String, dynamic>> q = _col.orderBy('createdAt', descending: true);

    if (cursor != null) {
      q = q.startAfterDocument(cursor);
    }

    q = q.limit(limit);

    final snap = await q.get();
    final docs = snap.docs;
    final items = docs.map((d) => ImageDoc.fromDoc(d)).toList();
    final lastDoc = docs.isNotEmpty ? docs.last : null;

    return PageResult(items: items, lastDoc: lastDoc);
  }
}
