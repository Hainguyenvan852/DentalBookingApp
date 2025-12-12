import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String ?address;
  final String? fullName;
  final DateTime? dob;
  final String? phone;
  final String role;
  final int? credibility;
  final bool isActive;
  final String? staffId;
  final String? clinicId;


  UserModel({required this.staffId, required this.email, required this.isActive, required this.role, required this.fullName, required this.phone, required this.address, required this.dob, required this.credibility, required this.uid,required this.clinicId,});

  UserModel copyWith({String? clinicId, String? uid, String? staffId, String? email, String ?address, String? fullName, DateTime ?dob, String? phone, String? role, bool? isActive, int? credibility}){
    return UserModel(
        uid: uid ?? this.uid,
        staffId: staffId ?? this.staffId,
        email: email ?? this.email,
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        dob: dob ?? this.dob,
        role: role ?? this.role,
        isActive: isActive ?? this.isActive,
        credibility: credibility ?? this.credibility,
        clinicId: clinicId ?? this.clinicId
    );
  }

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'fullName': fullName,
    'dob': dob,
    'credibility': 100,
    'address': address,
    'phone': phone,
    'isActive': true,
    'createdAt': DateTime.now().toIso8601String(),
  };


  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    final m = snap.data() as Map<String, dynamic>;
    Timestamp? ts = m['dob'] as Timestamp?;

    return UserModel(
      uid: snap.id,
      staffId: m['staffId'] as String?,
      email: m['email'] as String,
      fullName: m['fullName'] as String?,
      phone: m['phone'] as String?,
      address: m['address'] as String?,
      dob: ts?.toDate(),
      role: m['role'],
      isActive: m['isActive'],
      credibility: m['credibility'] as int?,
      clinicId: m['clinicId'] as String?
    );
  }
}