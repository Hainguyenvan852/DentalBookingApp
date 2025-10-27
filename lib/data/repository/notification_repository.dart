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
        .withConverter<Notification>(
        fromFirestore: (snap,_) => Notification.fromSnapshot(snap),
        toFirestore: (apm,_) => apm.toMap()
    );
  }

  late final FirebaseFirestore _db;
  late final CollectionReference<Notification> _apmRef;

  Future<List<Notification>> getAll() async{
    final today = DateTime.now();
    final day = today.subtract(Duration(days: 15));

    final snapshot = await _apmRef
        .where('createdAt', isGreaterThanOrEqualTo: day)
        .orderBy('createdAt')
        .get();

    return snapshot.docs.map((docs) => docs.data()).toList();
  }

  Future<List<Notification>> getReminderNotif() async{
    final today = DateTime.now();
    final day = today.subtract(Duration(days: 15));

    final snapshot = await _apmRef
        .where('createdAt', isGreaterThanOrEqualTo: day)
        .where('type', isEqualTo: 'reminder')
        .orderBy('createdAt')
        .get();

    return snapshot.docs.map((docs) => docs.data()).toList();
  }

  Future<List<Notification>> getOverviewNotif() async{
    final today = DateTime.now();
    final day = today.subtract(Duration(days: 15));

    final snapshot = await _apmRef
        .where('createdAt', isGreaterThanOrEqualTo: day)
        .where('type', isEqualTo: 'overview')
        .orderBy('createdAt')
        .get();

    return snapshot.docs.map((docs) => docs.data()).toList();
  }

  Future<List<Notification>> getPaymentNotif() async{
    final today = DateTime.now();
    final day = today.subtract(Duration(days: 15));

    final snapshot = await _apmRef
        .where('createdAt', isGreaterThanOrEqualTo: day)
        .where('type', isEqualTo: 'payment')
        .orderBy('createdAt')
        .get();

    return snapshot.docs.map((docs) => docs.data()).toList();
  }

  Future<void> add(Notification apm) async {
    await _apmRef.add(apm);
  }

  Future<void> update(Notification apm, String apmId) async {
    await _apmRef.doc(apmId).update(apm.toMap());
  }
}