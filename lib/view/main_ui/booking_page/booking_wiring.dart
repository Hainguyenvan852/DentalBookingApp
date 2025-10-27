import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../logic/appointment_cubit.dart';
import '../../../logic/booking_draft_cubit.dart';
import '../../../logic/branch_cubit.dart';
import '../../../logic/clinic_config_cubit.dart';
import '../../../logic/date_cubit.dart';
import '../../../logic/dentist_cubit.dart';
import '../../../logic/note_cubit.dart';
import '../../../logic/service_cubit.dart';
import '../../../logic/slot_cubit.dart';

class BookingWiringExample {
  final BranchCubit branchCubit;
  final ServiceCubit serviceCubit;
  final DentistCubit dentistCubit;
  final DateCubit dateCubit;
  final ClinicConfigCubit clinicCfgCubit;
  final AppointmentCubit appointmentCubit;
  final TimeSlotCubit timeSlotCubit;
  final BookingDraftCubit draftCubit;
  final NoteCubit noteCubit;
  final FirebaseAuth auth;


  late final StreamSubscription _branchSub;
  late final StreamSubscription _dateSub;
  late final StreamSubscription _apmSub;
  late final StreamSubscription _serviceSub;
  late final StreamSubscription _dentistSub;
  late final StreamSubscription _slotSub;
  late final StreamSubscription _draftSub;


  BookingWiringExample({
    required this.branchCubit,
    required this.serviceCubit,
    required this.dentistCubit,
    required this.dateCubit,
    required this.clinicCfgCubit,
    required this.appointmentCubit,
    required this.timeSlotCubit,
    required this.draftCubit,
    required this.noteCubit,
    required this.auth
  }){
// 1) When branch changes → load doctors + set clinic config + draft.clinic
    _branchSub = branchCubit.stream.listen((bState){
      final c = bState.selected;
      if (c != null){
        dentistCubit.loadForClinic(c.id);
        clinicCfgCubit.setConfig(c.slotConfig);
        draftCubit.setClinic(c);
// If date already chosen, start listening appointments for this clinic/day
        final d = dateCubit.state.selected;
        if (d != null){
          draftCubit.setDate(d);
          appointmentCubit.listenClinicAndUser(clinicId: c.id, day: d, patientId: auth.currentUser!.uid);
        }
      } else {
        clinicCfgCubit.clear();
      }
    });

// 2) When date changes → (re)listen appointments for clinic/day; reset slot in draft
    _dateSub = dateCubit.stream.listen((dState){
      final c = branchCubit.state.selected;
      if (c != null){
        appointmentCubit.listenClinicAndUser(clinicId: c.id, day: dState.selected!, patientId: auth.currentUser!.uid);
        draftCubit.setDate(dState.selected!);
      }
    });


// 3) When appointments or clinic config changes → recompute slot statuses
    _apmSub = appointmentCubit.stream.listen((aState){
      _recomputeSlots();
    });
    clinicCfgCubit.stream.listen((_) => _recomputeSlots());

// 4) When select service → set clinic in booking draft
    _serviceSub = serviceCubit.stream.listen((sState){
      final s = sState.selected;

      if(s != null){
        draftCubit.setService(s);
      }
    });


// 5) When select dentist → set dentist in booking draft

    _dentistSub = dentistCubit.stream.listen((dState){
      final d = dState.selected;

      if(d != null){
        draftCubit.setDentist(d);
      }
    });

// 6) When select slot → set slot in booking draft

    _slotSub = timeSlotCubit.stream.listen((tsState){
      final ts = tsState.selected;

      if(ts != null){
        draftCubit.setSlot(ts);
      }
    });

  }

  void _recomputeSlots(){
    final cfg = clinicCfgCubit.state.config;
    final d = dateCubit.state.selected;
    final clinicApm = appointmentCubit.state.clinicAppointments;
    final userApm = appointmentCubit.state.userAppointments;
    final srv = serviceCubit.state.selected;
    timeSlotCubit.recompute(date: d, config: cfg, clinicAppointments: clinicApm, service: srv, userAppointments: userApm);
  }

  Future<void> dispose() async {
    await _branchSub.cancel();
    await _dateSub.cancel();
    await _apmSub.cancel();
  }
}