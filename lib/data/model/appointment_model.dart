import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final String clinicId;
  final String dentistId;
  final String patientId;
  final String serviceId;
  final DateTime startAt;
  final DateTime endAt;
  final String status; // confirmed, pending, canceled_by_patient, canceled_by_clinic
  final String ratingNote;
  final int rating;
  final String ratedContent;
  final String? cancelReason;
  final DateTime? canceledAt;

  Appointment({required this.ratedContent, required this.patientId,required this.clinicId,required this.serviceId,
    required this.dentistId,required this.ratingNote,required this.startAt,required this.endAt,required this.status,
    required this.id, required this.rating, required this.canceledAt, required this.cancelReason
  });

  Appointment copyWith({
    String? clinicId,
    String? dentistId,
    String? patientId,
    String? serviceId,
    DateTime? startAt,
    DateTime? endAt,
    String? status,
    String? notes,
    int? rating,
    String? content,
    DateTime? canceledAt,
    String? cancelReason
  }){
    return Appointment(
        patientId: patientId ?? this.patientId,
        clinicId: clinicId ?? this.clinicId,
        serviceId: serviceId ?? this.serviceId,
        dentistId: dentistId ?? this.dentistId,
        ratingNote: notes ?? ratingNote,
        startAt: startAt ?? this.startAt,
        endAt: endAt ?? this.endAt,
        status: status ?? this.status,
        id: id,
        rating: rating ?? this.rating,
        ratedContent: content ?? ratedContent,
        canceledAt: canceledAt ?? this.canceledAt,
        cancelReason: cancelReason ?? this.cancelReason
    );
  }
  Map<String, dynamic> toMap() => {
    'patientId': patientId,
    'clinicId': clinicId,
    'serviceId': serviceId,
    'dentistId': dentistId,
    'notes': ratingNote,
    'startAt': Timestamp.fromDate(startAt),
    'endAt': Timestamp.fromDate(endAt),
    'status': status,
    'rating': rating,
    'ratedContent': ratedContent,
    'canceledAt': canceledAt,
    'cancelReason': cancelReason
  };

  factory Appointment.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    Timestamp startAtTs = data['startAt'] as Timestamp;
    Timestamp endAtTs = data['endAt'] as Timestamp;
    Timestamp? cancelAtTs = data['canceledAt'] as Timestamp?;

    DateTime startAt = startAtTs.toDate();
    DateTime endAt = endAtTs.toDate();
    DateTime? cancelAt = cancelAtTs?.toDate();

    return Appointment(
      id: snap.id,
      patientId: data['patientId'] as String,
      clinicId: data['clinicId'] as String,
      serviceId: data['serviceId'] as String,
      dentistId: data['dentistId'] as String,
      ratingNote: data['notes'] as String,
      startAt: startAt,
      endAt: endAt,
      status: data['status'] as String,
      rating: data['rating'] as int,
      ratedContent: data['ratedContent'] as String,
      canceledAt: cancelAt,
      cancelReason: data['cancelReason'] as String?,
    );
  }
}

class AppointmentCreateRequest {
  final String clinicId;
  final String dentistId;
  final String patientId;
  final String serviceId;
  final DateTime startAt;
  final DateTime endAt;
  final String notes;
  AppointmentCreateRequest({
    required this.clinicId,
    required this.dentistId,
    required this.patientId,
    required this.serviceId,
    required this.startAt,
    required this.endAt,
    required this.notes,
  });
}

