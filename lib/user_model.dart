class AppUser {
  final String uid;
  final String email;
  final String address;
  final String fullName;
  final String ?dob;
  final String phone;
  final bool isActive = true;


  AppUser({required this.uid, required this.email, required this.fullName, required this.phone, required this.address, required this.dob});


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


  factory AppUser.fromMap(Map<String, dynamic> m) => AppUser(
    uid: m['uid'] as String,
    email: m['email'] as String,
    fullName: m['displayName'] as String,
    phone: m['phone'] as String,
    address: m['address'] as String,
    dob: m['address'] as String?,
  );
}