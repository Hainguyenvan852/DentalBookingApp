

import '../../../model/appointment_model.dart';
import '../../../model/clinic_model.dart';
import '../../../model/dentist_model.dart';
import '../../../model/service_model.dart';

abstract class ClinicRepository {
  Future<List<Clinic>> getAll();
  Future<Clinic> getById(String clinicId);
}

abstract class DentistRepository {
  Future<List<Dentist>> getByClinic(String clinicId);
}

abstract class ServiceRepository {
  Future<List<Service>> getAll();
}

abstract class AppointmentRepository {
  /// Stream appointments of a clinic in [dayStart, dayEnd)
  Stream<List<Appointment>> streamByClinicAndDay({
    required String clinicId,
    required DateTime dayStart,
    required DateTime dayEnd,
  });

  Stream<List<Appointment>> streamUserAppointmentsByDay({
    required String patientId,
    required DateTime dayStart,
    required DateTime dayEnd,
  });

  Future<void> create(AppointmentCreateRequest req);
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