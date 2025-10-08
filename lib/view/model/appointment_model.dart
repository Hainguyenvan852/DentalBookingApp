import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String appointmentId;
  final String patientId;
  final String clinicId;
  final String serviceId;
  final String dentistId;
  final String notes;
  final DateTime createdAt;
  final DateTime startAt;
  final DateTime endAt;
  final String status;

  AppointmentModel({required this.patientId,required this.clinicId,required this.serviceId,required this.dentistId,required this.notes,required this.createdAt,required this.startAt,required this.endAt,required this.status, required this.appointmentId});

  Map<String, dynamic> toMap() => {
    'patientId': patientId,
    'clinicId': clinicId,
    'serviceId': serviceId,
    'dentistId': dentistId,
    'notes': notes,
    'createAt': Timestamp.fromDate(createdAt),
    'startAt': Timestamp.fromDate(startAt),
    'endAt': Timestamp.fromDate(endAt),
    'status': status,
  };

  factory AppointmentModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    Timestamp createdAtTs = data['createdAt'] as Timestamp;
    Timestamp startAtTs = data['startAt'] as Timestamp;
    Timestamp endAtTs = data['endAt'] as Timestamp;

    DateTime createdAt = createdAtTs.toDate();
    DateTime startAt = startAtTs.toDate();
    DateTime endAt = endAtTs.toDate();

    return AppointmentModel(
      appointmentId: snap.id,
      patientId: data['patientId'] as String,
      clinicId: data['clinicId'] as String,
      serviceId: data['serviceId'] as String,
      dentistId: data['dentistId'] as String,
      notes: data['notes'] as String,
      createdAt: createdAt,
      startAt: startAt,
      endAt: endAt,
      status: data['status'] as String,
    );
  }
}