import 'dart:async';

import 'package:dental_booking_app/data/repository/appointment_detail_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentDetailState{
  final AppointmentDetail? detail;
  final bool loading;
  final Object? error;

  AppointmentDetailState({this.detail, required this.loading, this.error,});

  AppointmentDetailState copyWith({AppointmentDetail? apmDetails, bool? loading, Object? error}){
    return AppointmentDetailState(
      detail: apmDetails ?? this.detail,
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
      final list = await repo.getById(apmId);
      emit(state.copyWith(apmDetails: list, loading: false));
    } catch(e){
      emit(state.copyWith(error: e));
    }
  }

  Future<void> refresh() async {
    final id = state.detail?.appointment.id;
    if (id != null) await loadDetail(id);
  }

}