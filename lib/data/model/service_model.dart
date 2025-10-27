import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String id;
  final String name;
  final int durationMinutes;
  final String description;
  final String imageUrl;

  Service({required this.id, required this.name, required this.durationMinutes, required this.description, required this.imageUrl});

  factory Service.fromSnapshot(DocumentSnapshot snap){
    final data = snap.data() as Map<String, dynamic>;

    return Service(
        name: data['name'],
        description: data['description'],
        id: snap.id,
        imageUrl : data['imageUrl'],
        durationMinutes: data['durationMinutes']
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'durationMinutes': durationMinutes,
    'description': description,
    'imageUrl': imageUrl
  };
}