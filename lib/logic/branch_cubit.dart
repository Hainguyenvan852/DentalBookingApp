import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/clinic_model.dart';
import '../data/repository/clinic_repository.dart';

class BranchState {
  final List<Clinic> clinics;
  final Clinic? selected;
  final bool loading;
  final Object? error;
  BranchState({
    required this.clinics,
    required this.selected,
    required this.loading,
    this.error,
  });
  BranchState copyWith({
    List<Clinic>? clinics,
    Clinic? selected,
    bool? loading,
    Object? error,
  }) => BranchState(
    clinics: clinics ?? this.clinics,
    selected: selected ?? this.selected,
    loading: loading ?? this.loading,
    error: error,
  );
}

class BranchCubit extends Cubit<BranchState> {
  final ClinicRepository repo;
  BranchCubit(this.repo)
      : super(BranchState(clinics: const [], selected: null, loading: true));


  Future<void> load() async {
    emit(state.copyWith(loading: true));
    try {
      final list = await repo.getAll();
      emit(BranchState(clinics: list, selected: list.isNotEmpty ? list.first : null, loading: false));
    } catch (e) {
      emit(BranchState(clinics: const [], selected: null, loading: false, error: e));
    }
  }

  void select(Clinic c) => emit(state.copyWith(selected: c));
}