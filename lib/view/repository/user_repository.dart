import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class UserRepository{

  UserRepository(){
    _db = FirebaseFirestore.instance;
    usersRef = _db
      .collection('users')
      .withConverter<User>(
        fromFirestore: (snap, _) => User.fromMap(snap.data()!),
        toFirestore: (user, _) => user.toMap(),
      );
  }

  late final FirebaseFirestore _db;
  late final CollectionReference<User> usersRef;

  Future<User?> getUser(String userId) async{
    final doc = await usersRef
        .doc(userId)
        .get();

    return doc.data();
  }

  Future<void> createUser(User user) async{
    await usersRef.doc(user.uid).set(user);
  }

  Future<void> updateUser(User user) async {
    await usersRef.doc(user.uid).update(user.toMap());
  }
}