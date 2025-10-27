import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/appointment_model.dart';
import '../data/repository/appointment_repository.dart';

class AppointmentState {
  final List<Appointment> clinicAppointments;
  final List<Appointment> userAppointments;
  final bool loading;
  final Object? error;
  AppointmentState({required this.clinicAppointments, required this.loading, this.error, required this.userAppointments});

  AppointmentState copyWith({List<Appointment>? clinicAppointments, List<Appointment>? userAppointments, bool? loading, Object? error}) =>
      AppointmentState(
          clinicAppointments: clinicAppointments ?? this.clinicAppointments,
          userAppointments: userAppointments ?? this.userAppointments,
          loading: loading ?? this.loading,
          error: error ?? this.error
      );
}


class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentRepository repo;

  StreamSubscription? _clinicSub;
  StreamSubscription? _userSub;

  AppointmentCubit(this.repo) : super(AppointmentState(clinicAppointments: const [], loading: false, userAppointments: []));


  void listenClinicAndUser({
    required String clinicId,
    required String patientId,
    required DateTime day,
  }) {
    _clinicSub?.cancel();
    _userSub?.cancel();
    emit(state.copyWith(loading: true));

    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));

    _clinicSub = repo.streamByClinicAndDay(
      clinicId: clinicId,
      dayStart: start,
      dayEnd: end,
    ).listen((list) => emit(state.copyWith(clinicAppointments: list, loading: false)),
        onError: (e) => emit(state.copyWith(error: e)));

    _userSub = repo.streamUserAppointmentsByDay(
      patientId: patientId,
      dayStart: start,
      dayEnd: end,
    ).listen((list) => emit(state.copyWith(userAppointments: list)),
        onError: (e) => emit(state.copyWith(error: e)));
  }

  @override
  Future<void> close() { _clinicSub?.cancel(); return super.close(); }
}
