import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/notification_model.dart';

class NotificationRepository{
  final _auth = FirebaseAuth.instance;

  NotificationRepository(){
    _db = FirebaseFirestore.instance;
    _apmRef = _db
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('notifications')
        .withConverter<NotificationModel>(
        fromFirestore: (snap,_) => NotificationModel.fromSnapshot(snap),
        toFirestore: (apm,_) => apm.toMap()
    );
  }

  late final FirebaseFirestore _db;
  late final CollectionReference<NotificationModel> _apmRef;

  Future<List<NotificationModel>> getAll() async{

    final snapshot = await _apmRef
        .orderBy('createdAt')
        .get();

    return snapshot.docs.map((docs) => docs.data()).toList();
  }

  Future<List<NotificationModel>> getReminderNotif() async{

    final snapshot = await _apmRef
        .where('type', isEqualTo: 'reminder')
        .orderBy('createdAt')
        .get();

    return snapshot.docs.map((docs) => docs.data()).toList();
  }

  Future<List<NotificationModel>> getOverviewNotif() async{
    final today = DateTime.now();
    final day = today.subtract(Duration(days: 15));

    final snapshot = await _apmRef
        .where('createdAt', isGreaterThanOrEqualTo: day)
        .where('type', isEqualTo: 'overview')
        .orderBy('createdAt')
        .get();

    return snapshot.docs.map((docs) => docs.data()).toList();
  }

  Future<List<NotificationModel>> getPaymentNotif() async{
    final today = DateTime.now();
    final day = today.subtract(Duration(days: 15));

    final snapshot = await _apmRef
        .where('createdAt', isGreaterThanOrEqualTo: day)
        .where('type', isEqualTo: 'payment')
        .orderBy('createdAt')
        .get();

    return snapshot.docs.map((docs) => docs.data()).toList();
  }

  Future<void> add(NotificationModel apm) async {
    await _apmRef.add(apm);
  }

  Future<void> update(NotificationModel apm) async {
    await _apmRef.doc(apm.id).update(apm.toMap());
  }
}