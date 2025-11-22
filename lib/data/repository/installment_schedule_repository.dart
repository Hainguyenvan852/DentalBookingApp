import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_booking_app/data/model/installment_schedule_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InstallmentScheduleRepository{

  late final FirebaseFirestore _db;
  late final FirebaseAuth _auth;

  InstallmentScheduleRepository(){
    _db = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
  }

  Future<List<InstallmentSchedule>> getAll(String invoiceId) async {
    final snapshot = await _db.collection('invoices')
    .doc(invoiceId)
    .collection('installmentSchedule')
    .orderBy('dueDate')
    .get();

    return snapshot.docs.map((docs) => InstallmentSchedule.fromDoc(docs)).toList();
  }

  Future<InstallmentSchedule?> getById(String invoiceId, String scheduleId) async {
    final snapshot = await _db.collection('invoices')
        .doc(invoiceId)
        .collection('installmentSchedule')
        .doc('scheduleId')
        .get();

    return InstallmentSchedule.fromDoc(snapshot);
  }
}