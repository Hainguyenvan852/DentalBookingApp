import 'package:cloud_firestore/cloud_firestore.dart';

class Dentist{
  final String id;
  final String name;

  const Dentist({
    required this.id,
    required this.name,
  });

  factory Dentist.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return Dentist(
      id: snap.id,
      name: data['name'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
  };
}