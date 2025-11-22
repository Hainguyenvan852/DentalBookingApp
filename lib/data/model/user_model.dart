import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String ?address;
  final String fullName;
  final DateTime ?dob;
  final String phone;


  UserModel({required this.uid, required this.email, required this.fullName, required this.phone, required this.address, required this.dob,});

  UserModel copyWith({String? uid, String? email, String ?address, String? fullName, DateTime ?dob, String? phone}){
    return UserModel(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        dob: dob ?? this.dob
    );
  }

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'fullName': fullName,
    'dob': dob,
    'address': address,
    'phone': phone,
    'createdAt': DateTime.now().toIso8601String(),
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
    );
  }
}