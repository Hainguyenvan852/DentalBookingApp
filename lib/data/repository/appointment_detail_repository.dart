import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_booking_app/data/model/user_model.dart';
import 'package:dental_booking_app/data/repository/appointment_repository.dart';
import 'package:dental_booking_app/data/repository/clinic_repository.dart';
import 'package:dental_booking_app/data/repository/dentist_repository.dart';
import 'package:dental_booking_app/data/repository/service_repository.dart';
import 'package:dental_booking_app/data/repository/user_repository.dart';

import '../model/appointment_model.dart';
import '../model/clinic_model.dart';
import '../model/dentist_model.dart';
import '../model/service_model.dart';

class AppointmentDetail{
  final Appointment appointment;
  final Clinic? clinic;
  final Dentist? dentist;
  final UserModel? patient;
  final Service? service;

  AppointmentDetail({required this.appointment, required this.clinic, required this.dentist, required this.service, this.patient });
}

class AppointmentDetailRepository {
  final appointmentRepo = AppointmentRepository();
  final clinicRepo = ClinicRepository();
  final dentistRepo = DentistRepository();
  final serviceRepo = ServiceRepository();
  final userRepo = UserRepository();
  final String userId;

  AppointmentDetailRepository({required this.userId});

  Future<List<AppointmentDetail>> getAllForUser() async {
    final appointments = await appointmentRepo.getAllForUser(userId);

    final futures = appointments.map((apm) async {
      Clinic? clinic;
      Dentist? dentist;
      Service? service;

      final f1 = clinicRepo
          .getById(apm.clinicId)
          .then((v) => clinic = v)
          .timeout(const Duration(seconds: 20))
          .catchError((_) {});

      final f2 = (apm.dentistId.isNotEmpty)
          ? dentistRepo
          .getById(apm.dentistId, apm.clinicId)
          .then((v) => dentist = v)
          .timeout(const Duration(seconds: 20))
          .catchError((_) {})
          : Future.value();

      final f3 = serviceRepo
          .getById(apm.serviceId)
          .then((v) => service = v)
          .timeout(const Duration(seconds: 20))
          .catchError((_) {});

      await Future.wait([f1, f2, f3]);

      return AppointmentDetail(
        appointment: apm,
        clinic: clinic,
        dentist: dentist,
        service: service,
      );
    }).toList();

    return Future.wait(futures);
  }

  Future<List<AppointmentDetail>> getAllForDoctor() async {
    final appointments = await appointmentRepo.getAllForDoctor(userId);

    final futures = appointments.map((apm) async {
      Clinic? clinic;
      Dentist? dentist;
      Service? service;
      UserModel? patient;

      final f1 = clinicRepo
          .getById(apm.clinicId)
          .then((v) => clinic = v)
          .timeout(const Duration(seconds: 30))
          .catchError((e) {
            print("Lỗi ${apm.clinicId}: $e");
          });

      final f2 = (apm.dentistId.isNotEmpty)
          ? dentistRepo
          .getById(apm.dentistId, apm.clinicId)
          .then((v) => dentist = v)
          .timeout(const Duration(seconds: 30))
          .catchError((e) {
            print("Lỗi ${apm.clinicId}: $e");
          })
          : Future.value();

      final f3 = serviceRepo
          .getById(apm.serviceId)
          .then((v) => service = v)
          .timeout(const Duration(seconds: 30))
          .catchError((e) {
            print("Lỗi ${apm.clinicId}: $e");
          });

      final f4 = userRepo
          .getUser(apm.patientId)
          .then((v) => patient = v)
          .timeout(const Duration(seconds: 30))
          .catchError((e) {
            print("Lỗi ${apm.clinicId}: $e");
          });

      await Future.wait([f1, f2, f3, f4]);

      return AppointmentDetail(
        appointment: apm,
        clinic: clinic,
        dentist: dentist,
        service: service,
        patient: patient
      );
    }).toList();

    return Future.wait(futures);
  }

  Future<AppointmentDetail> getById(String apmId) async {
    final apm = await appointmentRepo.getById(apmId);
    if (apm == null) {
      throw StateError('Appointment $apmId not found');
    }

    final clinicF = clinicRepo.getById(apm.clinicId);
    final dentistF = (apm.dentistId.isNotEmpty)
        ? dentistRepo.getById(apm.dentistId, apm.clinicId)
        : Future.value(null);
    final serviceF = serviceRepo.getById(apm.serviceId);

    final results = await Future.wait([clinicF, dentistF, serviceF]
        .map((f) => f.timeout(const Duration(seconds: 20)).catchError((_) => null)));

    final clinic  = results[0] as Clinic?;
    final dentist = results[1] as Dentist?;
    final service = results[2] as Service?;

    return AppointmentDetail(
      appointment: apm,
      clinic: clinic,
      dentist: dentist,
      service: service,
    );
  }

  Future<String> updateAppointment(Appointment appointment) async{
    final result = await appointmentRepo.update(appointment);
    return result;
  }

}
