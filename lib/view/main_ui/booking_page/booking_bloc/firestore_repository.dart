import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_booking_app/view/main_ui/booking_page/booking_bloc/repository_interface.dart';

import '../../../model/appointment_model.dart';
import '../../../model/clinic_model.dart';
import '../../../model/dentist_model.dart';
import '../../../model/service_model.dart';



class FirestoreClinicRepository implements ClinicRepository {
  final _db = FirebaseFirestore.instance;
  @override
  Future<List<Clinic>> getAll() async {
    final snap = await _db.collection('clinics').get();
    return snap.docs.map(_clinicFromDoc).toList();
  }

  @override
  Future<Clinic> getById(String clinicId) async {
    final doc = await _db.collection('clinics').doc(clinicId).get();
    if (!doc.exists) throw StateError('Clinic not found');
    return _clinicFromDoc(doc);
  }


  Clinic _clinicFromDoc(DocumentSnapshot<Map<String, dynamic>> d){
    final m = d.data()!;
    final cfg = m['slotConfig'] as Map<String, dynamic>;
    final slotsRaw = (cfg['slot'] as List).cast<Map<String, dynamic>>();
    final slots = slotsRaw.map((e) => TimeSlotDef(
      id: e['id'] as String,
      start: e['start'] as String,
      end: e['end'] as String,
      capacity: (e['capacity'] as num).toInt(),
    )).toList();
    return Clinic(
      id: d.id,
      address: m['address'] as String,
      name: m['name'] as String,
      slotConfig: SlotConfig(
        intervalMinutes: (cfg['intervalMinutes'] as num).toInt(),
        slots: slots,
      ),
    );
  }
}

class FirestoreDentistRepository implements DentistRepository {
  final _db = FirebaseFirestore.instance;
  @override
  Future<List<Dentist>> getByClinic(String clinicId) async {
    final snap = await _db.collection('clinics')
        .doc(clinicId)
        .collection('staffs')
        .where('type', isEqualTo: 'dentist')
        .get();
    return snap.docs.map((d){
      final m = d.data();
      return Dentist(id: d.id, name: m['name'] as String,);
    }).toList();
  }
}

class FirestoreServiceRepository implements ServiceRepository {
  final _db = FirebaseFirestore.instance;
  @override
  Future<List<Service>> getAll() async {
    final snap = await _db.collection('services').get();
    return snap.docs.map((d){
      final m = d.data();
      return Service(
        id: d.id,
        name: m['name'] as String,
        durationMinutes: (m['durationMinutes'] as num).toInt(),
        description: m['description'] as String,
        imageUrl: m['imageUrl'] as String
      );
    }).toList();
  }
}

class FirestoreAppointmentRepository implements AppointmentRepository {
  final _db = FirebaseFirestore.instance;

  @override
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

  @override
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


  @override
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
    });
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
    );
  }
}