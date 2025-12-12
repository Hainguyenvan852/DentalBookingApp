import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repository/appointment_detail_repository.dart';

class MyAppointmentState{
  final List<AppointmentDetail> apmDetails;
  final bool loading;
  final Object? error;

  MyAppointmentState({required this.apmDetails, required this.loading, this.error});

  MyAppointmentState copyWith({List<AppointmentDetail>? apmDetails, bool? loading, Object? error,}){
    return MyAppointmentState(
        apmDetails: apmDetails ?? this.apmDetails,
        loading: loading ?? this.loading,
        error: error ?? this.error
    );
  }
}

class MyAppointmentCubit extends Cubit<MyAppointmentState>{
  final AppointmentDetailRepository repo;

  MyAppointmentCubit(this.repo) : super(MyAppointmentState(apmDetails: [], loading: false));

  Future<void> loadForUser() async {
    emit(state.copyWith(loading: true));

    try{
      final list = await repo.getAllForUser();
      emit(state.copyWith(apmDetails: list, loading: false));
    } catch(e){
      emit(state.copyWith(error: e, loading: false));
    }
  }

  Future<void> loadForDoctor() async {
    emit(state.copyWith(loading: true));

    try{
      final list = await repo.getAllForDoctor();
      emit(state.copyWith(apmDetails: list, loading: false));
    } catch(e){
      emit(state.copyWith(error: e, loading: false));
    }
  }

  Future<void> refreshForPatient() async {
    await loadForUser();
  }

  Future<void> refreshForDoctor() async {
    await loadForDoctor();
  }
}