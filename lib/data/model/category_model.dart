import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCatalog {
  final String id;
  final String name;
  final String imageUrl;

  const ProductCatalog({required this.id, required this.name, required this.imageUrl});

  Map<String, dynamic> toMap() => {
    'name': name,
    'imageUrl': imageUrl,
  };

  factory ProductCatalog.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return ProductCatalog(
      id: snap.id,
      name: data['name'] as String,
      imageUrl: data['imageUrl'] as String,
    );
  }
}