import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_booking_app/view/model/appointment_model.dart';
import 'package:dental_booking_app/view/model/clinic_model.dart';
import 'package:dental_booking_app/view/model/dentist_model.dart';
import 'package:dental_booking_app/view/repository/appointment_repository.dart';
import 'package:dental_booking_app/view/repository/clinic_repository.dart';
import 'package:dental_booking_app/view/repository/dentist_repository.dart';
import 'package:dental_booking_app/view/repository/service_repository.dart';

import '../model/service_model.dart';

class AppointmentDetail{
  final Appointment appointment;
  final Clinic? clinic;
  final Dentist? dentist;
  final Service? service;

  AppointmentDetail({required this.appointment, required this.clinic, required this.dentist, required this.service });
}

class AppointmentDetailRepository{
  final String userId;
  late final List<Appointment> appointments;
  late final FirebaseFirestore _db;
  late final CollectionReference<Appointment> _apmRef;

  AppointmentDetailRepository({required this.userId}){
    _db = FirebaseFirestore.instance;
    _apmRef = _db
        .collection('appointments')
        .withConverter<Appointment>(
        fromFirestore: (snap,_) => Appointment.fromSnapshot(snap),
        toFirestore: (apm,_) => apm.toMap()
    );
  }

  Future<List<AppointmentDetail>> getAppointmentDetail() async{
    appointments = await AppointmentRepository().getAll(userId);
    List<AppointmentDetail> apmDetails = [];

    for (var apm in appointments){
      var clinic = await ClinicRepository().get(apm.clinicId);
      var dentist = await DentistRepository(apm.clinicId).get(apm.dentistId);
      var service = await ServiceRepository().get(apm.serviceId);

      apmDetails.add(AppointmentDetail(appointment: apm, clinic: clinic, dentist: dentist, service: service));
    }

    return apmDetails;
  }
}