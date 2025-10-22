import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_booking_app/view/model/appointment_model.dart';

class AppointmentRepository{
   AppointmentRepository(){
    _db = FirebaseFirestore.instance;
    _apmRef = _db
        .collection('appointments')
        .withConverter<Appointment>(
        fromFirestore: (snap,_) => Appointment.fromSnapshot(snap),
        toFirestore: (apm,_) => apm.toMap()
    );
  }
  
  late final FirebaseFirestore _db;
  late final CollectionReference<Appointment> _apmRef;

   Future<List<Appointment>> getAll(String userId) async{
     final snapshot = await _apmRef
         .where('patientId', isEqualTo: userId.trim())
         .where('status', whereIn: ['confirmed', 'completed', 'pending'])
         .orderBy('startAt', descending: true)
         .get();

     return snapshot.docs.map((docs) => docs.data()).toList();
   }


    Future<List<Appointment>> getConfirmedAndCompleted(String userId) async{
      final snapshot = await _apmRef
        .where('patientId', isEqualTo: userId.trim())
        .where('status', whereIn: ['confirmed', 'completed'])
        .get();

      return snapshot.docs.map((docs) => docs.data()).toList();
    }

    Future<List<Appointment>> getTodayAppointment(String userId) async{
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

    Future<List<Appointment>> getAppointmentForTimeSlot(String userId, String start, String end, DateTime selectedDate) async{

      int sh = int.parse(start.substring(0, 2));
      int sm = int.parse(start.substring(3, 5));

      final startTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, sh, sm);

      final snapshot = await _apmRef
         .where('patientId', isEqualTo: userId.trim())
         .where('startAt', isEqualTo: startTime)
         .where('status', isEqualTo: 'confirmed')
         .get();

      return snapshot.docs.map((docs) => docs.data()).toList();
    }


  Future<void> add(Appointment apm) async {
    await _apmRef.add(apm);
  }

  Future<void> update(Appointment apm, String apmId) async {
    await _apmRef.doc(apmId).update(apm.toMap());
  }
}