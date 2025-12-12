import 'package:cloud_firestore/cloud_firestore.dart';

class ImageDoc {
  final String id;
  final String urlFull;
  final String urlThumb;
  final DateTime createdAt;
  final String type;

  ImageDoc({
    required this.id,
    required this.urlFull,
    required this.urlThumb,
    required this.createdAt,
    required this.type,
  });

  factory ImageDoc.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    final ts = d['createdAt'] as Timestamp?;
    return ImageDoc(
      id: doc.id,
      urlFull: d['urlFull'] as String,
      urlThumb: (d['urlThumb'] as String?) ?? (d['urlFull'] as String),
      createdAt: (ts ?? Timestamp.now()).toDate(),
      type: d['type'] as String,
    );
  }
}
