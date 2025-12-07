import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String ?address;
  final String fullName;
  final DateTime ?dob;
  final String phone;
  final String role;
  final int credibility;
  final bool isActive;


  UserModel({required this.uid, required this.email, required this.isActive, required this.role, required this.fullName, required this.phone, required this.address, required this.dob, required this.credibility,});

  UserModel copyWith({String? uid, String? email, String ?address, String? fullName, DateTime ?dob, String? phone, String? role, bool? isActive, int? credibility}){
    return UserModel(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        dob: dob ?? this.dob,
        role: role ?? this.role,
        isActive: isActive ?? this.isActive,
        credibility: credibility ?? this.credibility
    );
  }

  Map<String, dynamic> toMap() => {
    'email': email,
    'fullName': fullName,
    'dob': dob,
    'credibility': 100,
    'address': address,
    'phone': phone,
    'createdAt': DateTime.now().toIso8601String(),
  };


  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    final m = snap.data() as Map<String, dynamic>;
    Timestamp ts = m['dob'] as Timestamp;

    return UserModel(
      uid: snap.id,
      email: m['email'] as String,
      fullName: m['fullName'] as String,
      phone: m['phone'] as String,
      address: m['address'] as String?,
      dob: ts.toDate(),
      role: m['role'],
      isActive: m['isActive'],
      credibility: m['credibility']
    );
  }
}