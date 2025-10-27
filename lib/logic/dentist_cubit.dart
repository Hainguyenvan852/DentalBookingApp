import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/dentist_model.dart';
import '../data/repository/dentist_repository.dart';

class DentistState {
  final List<Dentist> dentists;
  final Dentist? selected;
  final bool loading;
  final Object? error;
  DentistState({required this.dentists, required this.selected, required this.loading, this.error});
  DentistState copyWith({List<Dentist>? doctors, Dentist? selected, bool? loading, Object? error}) =>
      DentistState(dentists: doctors ?? this.dentists, selected: selected ?? this.selected, loading: loading ?? this.loading, error: error);
}


class DentistCubit extends Cubit<DentistState> {
  final DentistRepository repo;
  DentistCubit(this.repo) : super(DentistState(dentists: const [], selected: null, loading: false));


  Future<void> loadForClinic(String clinicId) async {
    emit(state.copyWith(loading: true));
    try {
      final list = await repo.getByClinic(clinicId);
      emit(DentistState(dentists: list, selected: null, loading: false));
    } catch (e) {
      emit(DentistState(dentists: const [], selected: null, loading: false, error: e));
    }
  }


  void select(Dentist d) => emit(state.copyWith(selected: d));
}