import 'dart:async';

import 'package:dental_booking_app/data/model/appointment_model.dart';
import 'package:dental_booking_app/data/repository/appointment_detail_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentDetailState{
  final AppointmentDetail? detail;
  final bool loading;
  final Object? error;

  AppointmentDetailState({this.detail, required this.loading, this.error,});

  AppointmentDetailState copyWith({AppointmentDetail? apmDetails, bool? loading, Object? error}){
    return AppointmentDetailState(
      detail: apmDetails ?? detail,
      loading: loading ?? this.loading,
      error: error ?? this.error
    );
  }
}

class AppointmentDetailCubit extends Cubit<AppointmentDetailState>{
  final AppointmentDetailRepository repo;

  AppointmentDetailCubit(this.repo) : super(AppointmentDetailState(loading: false));

  Future<void> loadDetail(String apmId) async {
    emit(state.copyWith(loading: true));

    try{
      final detail = await repo.getById(apmId);
      emit(state.copyWith(apmDetails: detail, loading: false));
    } catch(e){
      emit(state.copyWith(error: e));
    }
  }

  Future<void> cancel(Appointment appointment) async {
    emit(state.copyWith(loading: true));

    final result = await repo.updateAppointment(appointment);

    if(result == 'success'){
      final detail = await repo.getById(appointment.id);
      emit(state.copyWith(apmDetails: detail, loading: false));
    }
    else{
      emit(state.copyWith(error: result));
    }

  }

  Future<void> updateAppointment(Appointment appointment) async {
    emit(state.copyWith(loading: true));

    final result = await repo.updateAppointment(appointment);

    if(result == 'success'){
      final detail = await repo.getById(appointment.id);
      emit(state.copyWith(apmDetails: detail, loading: false));
    }
    else{
      emit(state.copyWith(error: result));
    }
  }
}