import 'package:cloud_firestore/cloud_firestore.dart';

class Dentist{
  final String id;
  final String name;
  final String address;
  final String phone;
  final bool sex;
  final String email;
  final String description;
  final String specialized;
  final DateTime dob;
  final List<dynamic> certificates;


  const Dentist({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.specialized,
    required this.sex,
    required this.description,
    required this.certificates,
    required this.dob,
  });

  factory Dentist.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    final dob = data['dob'] as Timestamp;

    return Dentist(
      id: snap.id,
      name: data['name'] as String,
      sex: data['sex'] as bool,
      address: data['address'] as String,
      phone: data['phone'] as String,
      email: data['email'] as String,
      specialized: data['specialized'] as String,
      description: data['description'] as String,
      certificates: data['certificate'] as List<dynamic>,
      dob: dob.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'sex': sex,
    'address': address,
    'phone': phone,
    'email': email,
    'specialized': specialized,
    'description': description,
  };
}