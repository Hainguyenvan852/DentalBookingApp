import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/appointment_model.dart';

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

   Future<Appointment?> getById(String apmId) async{
     final docs = await _apmRef
        .doc(apmId)
        .get();

     return docs.data();
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

   Stream<List<Appointment>> streamByClinicAndDay({
     required String clinicId,
     required DateTime dayStart,
     required DateTime dayEnd,
   }) {
     return _db.collection('appointments')
         .where('clinicId', isEqualTo: clinicId)
         .where('startAt', isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart))
         .where('startAt', isLessThan: Timestamp.fromDate(dayEnd))
         .orderBy('startAt')
         .snapshots()
         .map((qs) => qs.docs.map(_apmFromDoc).toList());
   }

   Stream<List<Appointment>> streamUserAppointmentsByDay({
     required String patientId,
     required DateTime dayStart,
     required DateTime dayEnd,
   }) {
     return _db.collection('appointments')
         .where('patientId', isEqualTo: patientId)
         .where('startAt', isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart))
         .where('startAt', isLessThan: Timestamp.fromDate(dayEnd))
         .orderBy('startAt')
         .snapshots()
         .map((qs) => qs.docs.map(_apmFromDoc).toList());
   }

   Appointment _apmFromDoc(DocumentSnapshot<Map<String, dynamic>> d){
     final m = d.data()!;
     return Appointment(
       id: d.id,
       clinicId: m['clinicId'] as String,
       dentistId: (m['dentistId'] as String?) ?? '',
       patientId: m['patientId'] as String,
       serviceId: m['serviceId'] as String,
       startAt: (m['startAt'] as Timestamp).toDate(),
       endAt: (m['endAt'] as Timestamp).toDate(),
       status: m['status'] as String,
       notes: (m['notes'] as String?) ?? '',
       rating: m['rating'] as int,
       ratedContent: m['ratedContent'] as String,
     );
   }

   Future<void> create(AppointmentCreateRequest req) async {
     await _db.collection('appointments').add({
       'clinicId': req.clinicId,
       'dentistId': req.dentistId,
       'patientId': req.patientId,
       'serviceId': req.serviceId,
       'startAt': Timestamp.fromDate(req.startAt),
       'endAt': Timestamp.fromDate(req.endAt),
       'status': 'pending',
       'notes': req.notes,
       'createdAt': FieldValue.serverTimestamp(),
       'rating' : 0,
       'ratedContent': ''
     });
   }

  Future<String> update(Appointment apm) async {
    try{
      await _apmRef.doc(apm.id).update(apm.toMap());
    } on FirebaseException catch(e){
      return e.message!;
    }

    return 'success';
  }
}