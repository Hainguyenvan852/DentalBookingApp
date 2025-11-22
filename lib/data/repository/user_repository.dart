import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class UserRepository{

  UserRepository(){
    _db = FirebaseFirestore.instance;
    usersRef = _db
      .collection('users')
      .withConverter<UserModel>(
        fromFirestore: (snap, _) => UserModel.fromMap(snap.data()!),
        toFirestore: (user, _) => user.toMap(),
      );
  }

  late final FirebaseFirestore _db;
  late final CollectionReference<UserModel> usersRef;

  Future<UserModel?> getUser(String userId) async{
    final doc = await usersRef
        .doc(userId)
        .get();

    return doc.data();
  }

  Future<void> createUser(UserModel user) async{
    await usersRef.doc(user.uid).set(user);
  }

  Future<String> update(UserModel user) async {
    try{
      await usersRef.doc(user.uid).update(user.toMap());
      return 'success';

    } catch(e){
      return e.toString();
    }
  }
}