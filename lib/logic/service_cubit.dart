import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/service_model.dart';
import '../data/repository/service_repository.dart';

class ServiceState {
  final List<Service> services;
  final Service? selected;
  final bool loading;
  final Object? error;
  ServiceState({required this.services, required this.selected, required this.loading, this.error});
  ServiceState copyWith({List<Service>? services, Service? selected, bool? loading, Object? error}) =>
      ServiceState(services: services ?? this.services, selected: selected ?? this.selected, loading: loading ?? this.loading, error: error);
}


class ServiceCubit extends Cubit<ServiceState> {
  final ServiceRepository repo;
  ServiceCubit(this.repo) : super(ServiceState(services: const [], selected: null, loading: true));


  Future<void> load(Service? s) async {
    emit(state.copyWith(loading: true));
    try {
      final list = await repo.getAll();

      emit(ServiceState(services: list, selected: s, loading: false));
    } catch (e) {
      emit(ServiceState(services: const [], selected: null, loading: false, error: e));
    }
  }


  void select(Service s) => emit(state.copyWith(selected: s));
}