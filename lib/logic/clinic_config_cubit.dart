import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/clinic_model.dart';

class ClinicConfigState {
  final SlotConfig? config;
  final bool loading;
  final Object? error;
  ClinicConfigState({required this.config, required this.loading, this.error});
}


class ClinicConfigCubit extends Cubit<ClinicConfigState> {
  ClinicConfigCubit(): super(ClinicConfigState(config: null, loading: false));
  void setConfig(SlotConfig cfg){ emit(ClinicConfigState(config: cfg, loading: false)); }
  void clear(){ emit(ClinicConfigState(config: null, loading: false)); }
}