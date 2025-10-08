import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_booking_app/view/model/appointment_model.dart';

class AppointmentRepository{
   AppointmentRepository(){
    _db = FirebaseFirestore.instance;
    _apmRef = _db
        .collection('appointments')
        .withConverter<AppointmentModel>(
        fromFirestore: (snap,_) => AppointmentModel.fromSnapshot(snap),
        toFirestore: (apm,_) => apm.toMap()
    );
  }
  
  late final FirebaseFirestore _db;
  late final CollectionReference<AppointmentModel> _apmRef;

  Future<List<AppointmentModel>> getAll(String userId) async{
    final snapshot = await _apmRef
      .where('patientId', isEqualTo: userId.trim())
      .where('status', whereIn: ['confirmed', 'completed'])
      .get();

    return snapshot.docs.map((docs) => docs.data()).toList();
  }

   Future<List<AppointmentModel>> getToday(String userId) async{
     final today = DateTime.now();
     final startOfDay = DateTime(today.year, today.month, today.day);
     final nextDay = startOfDay.add(Duration(days: 1));

     final snapshot = await _apmRef
         .where('patientId', isEqualTo: userId.trim())
         .where('startAt', isGreaterThanOrEqualTo: startOfDay)
         .where('startAt', isLessThan: nextDay)
         .where('status', isEqualTo: 'confirmed')
         .orderBy('startAt')
         .get();

     return snapshot.docs.map((docs) => docs.data()).toList();
   }

  Future<void> add(AppointmentModel apm) async {
    await _apmRef.add(apm);
  }

  Future<void> update(AppointmentModel apm, String apmId) async {
    await _apmRef.doc(apmId).update(apm.toMap());
  }
}