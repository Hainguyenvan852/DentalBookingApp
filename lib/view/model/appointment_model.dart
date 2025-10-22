import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final String clinicId;
  final String dentistId;
  final String patientId;
  final String serviceId;
  final DateTime startAt;
  final DateTime endAt;
  final String status; // confirmed, pending, cancelled
  final String notes;

  Appointment({required this.patientId,required this.clinicId,required this.serviceId,required this.dentistId,required this.notes,required this.startAt,required this.endAt,required this.status, required this.id});

  Map<String, dynamic> toMap() => {
    'patientId': patientId,
    'clinicId': clinicId,
    'serviceId': serviceId,
    'dentistId': dentistId,
    'notes': notes,
    'startAt': Timestamp.fromDate(startAt),
    'endAt': Timestamp.fromDate(endAt),
    'status': status,
  };

  factory Appointment.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    Timestamp startAtTs = data['startAt'] as Timestamp;
    Timestamp endAtTs = data['endAt'] as Timestamp;

    DateTime startAt = startAtTs.toDate();
    DateTime endAt = endAtTs.toDate();

    return Appointment(
      id: snap.id,
      patientId: data['patientId'] as String,
      clinicId: data['clinicId'] as String,
      serviceId: data['serviceId'] as String,
      dentistId: data['dentistId'] as String,
      notes: data['notes'] as String,
      startAt: startAt,
      endAt: endAt,
      status: data['status'] as String,
    );
  }
}