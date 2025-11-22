import 'package:dental_booking_app/data/model/installment_schedule_model.dart';
import 'package:dental_booking_app/data/repository/installment_schedule_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstallmentScheduleState{
  final List<InstallmentSchedule> installmentSchedules;
  final bool loading;
  final Object? error;

  InstallmentScheduleState({required this.installmentSchedules, required this.loading, this.error});

  InstallmentScheduleState copyWith({List<InstallmentSchedule>? list, bool? loading, Object? error}){
    return InstallmentScheduleState(
        installmentSchedules: list ?? installmentSchedules,
        loading: loading ?? this.loading,
        error: error ?? this.error
    );
  }
}

class InstallmentScheduleCubit extends Cubit<InstallmentScheduleState>{
  final InstallmentScheduleRepository _installmentRepo;

  InstallmentScheduleCubit(this._installmentRepo) : super(InstallmentScheduleState(loading: false, installmentSchedules: [],));

  void loadAll(String id) async{
    emit(state.copyWith(loading: true));

    try{
      final ip = await _installmentRepo.getAll(id);
      emit(state.copyWith(list: ip, loading: false,));
    }catch(e){
      emit(state.copyWith(error: e, loading: false, ));
    }
  }
}