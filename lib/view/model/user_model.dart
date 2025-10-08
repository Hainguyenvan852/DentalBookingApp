import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String ?address;
  final String fullName;
  final DateTime ?dob;
  final String phone;
  final bool isActive;


  UserModel({required this.uid, required this.email, required this.fullName, required this.phone, required this.address, required this.dob, required this.isActive});


  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'fullName': fullName,
    'dob': dob,
    'address': address,
    'phone': phone,
    'createdAt': DateTime.now().toIso8601String(),
    'isActive' : isActive
  };


  factory UserModel.fromMap(Map<String, dynamic> m) {
    Timestamp ts = m['dob'] as Timestamp;

    return UserModel(
      uid: m['uid'] as String,
      email: m['email'] as String,
      fullName: m['fullName'] as String,
      phone: m['phone'] as String,
      address: m['address'] as String?,
      dob: ts.toDate(),
      isActive: m['isActive'] as bool,
    );
  }
}