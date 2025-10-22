import 'dart:async';

import 'package:dental_booking_app/view/main_ui/booking_page/booking_bloc/repository_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

import '../../../model/appointment_model.dart';
import '../../../model/clinic_model.dart';
import '../../../model/dentist_model.dart';
import '../../../model/service_model.dart';


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

class DateState { final DateTime? selected; const DateState(this.selected); }
class DateCubit extends Cubit<DateState> { DateCubit(): super(DateState(DateTime.now()));


  void select(DateTime d)=>emit(DateState(DateTime(d.year,d.month,d.day)));
}


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


class TimeSlotState {
  final List<TimeSlot> slots; // absolute slots for selected date
  final Map<String, SlotStatus> statusBySlotId; // id -> status
  TimeSlot? selected;
  final bool ready; // true when config + date available
  TimeSlotState({
    required this.slots,
    required this.statusBySlotId,
    required this.ready,
    required this.selected
  });
  TimeSlotState copyWith({List<TimeSlot>? slots, TimeSlot? selected, Map<String, SlotStatus>? statusBySlotId, bool? ready}) =>
      TimeSlotState(selected: selected ?? this.selected, slots: slots ?? this.slots, statusBySlotId: statusBySlotId ?? this.statusBySlotId, ready: ready ?? this.ready,);
}


class TimeSlotCubit extends Cubit<TimeSlotState> {
  TimeSlotCubit(): super(TimeSlotState(slots: const [], statusBySlotId: const {}, ready: false, selected: null));


  void recompute({
    required DateTime? date,
    required SlotConfig? config,
    required List<Appointment> clinicAppointments,
    required List<Appointment> userAppointments,
    Service? service,
  }) {
    if (date == null || config == null) {
      emit(TimeSlotState(
        slots: const [],
        statusBySlotId: const {},
        ready: false,
        selected: null,
      ));
      return;
    }

    final slots = _materializeSlotsForDate(config, date);
    final Map<String, int> counts = { for (final s in slots) s.id: 0 };

    // Đếm số lượng appointment theo chi nhánh trong từng slot
    for (final apm in clinicAppointments) {
      final slot = slots.firstWhereOrNull((s) =>
      apm.startAt.isAtSameMomentAsOrAfter(s.startAt) && apm.startAt.isBefore(s.endAt));
      if (slot != null && apm.status != 'cancelled') {
        counts[slot.id] = (counts[slot.id] ?? 0) + 1;
      }
    }

    final Map<String, SlotStatus> statuses = {};
    for (final s in slots) {
      final def = config.slots.firstWhere((d) => d.id == s.id);
      final cap = def.capacity;
      final c = counts[s.id] ?? 0;

      // Kiểm tra xem user đã có lịch ở slot này chưa
      final userHasBooked = userAppointments.any((a) =>
      a.startAt.isAtSameMomentAsOrAfter(s.startAt) && a.startAt.isBefore(s.endAt)
      );

      if (cap <= 0) {
        statuses[s.id] = SlotStatus.closed;
      } else if (userHasBooked) {
        statuses[s.id] = SlotStatus.userBooked; // 🔥 đánh dấu slot đã đặt
      } else if (c >= cap) {
        statuses[s.id] = SlotStatus.crowded;
      } else if (c == 0) {
        statuses[s.id] = SlotStatus.empty;
      } else {
        statuses[s.id] = SlotStatus.normal;
      }
    }

    emit(TimeSlotState(
      slots: slots,
      statusBySlotId: statuses,
      ready: true,
      selected: null,
    ));
  }


  void select(TimeSlot s) => emit(state.copyWith(selected: s));
}

class NoteState{
  final String? content;

  NoteState({this.content});

  NoteState copyWith(String? content) => NoteState(
    content: content ?? this.content
  );
}

class NoteCubit extends Cubit<NoteState>{
  NoteCubit() : super(NoteState());

  void setContent(String ct){emit(state.copyWith(ct));}
}

class BookingDraftState {
  final Clinic? clinic;
  final Service? service;
  final Dentist? dentist;
  final DateTime? date;
  final TimeSlot? slot;
  final String notes;
  final bool submitting;
  bool get readyToSubmit => clinic != null && service != null && date != null && slot != null;
  BookingDraftState({this.clinic, this.service, this.dentist, this.date, this.slot, this.notes = '', this.submitting = false});
  BookingDraftState copyWith({Clinic? clinic, Service? service, Dentist? dentist, DateTime? date, TimeSlot? slot, String? notes, bool? submitting}) =>
      BookingDraftState(
        clinic: clinic ?? this.clinic,
        service: service ?? this.service,
        dentist: dentist ?? this.dentist,
        date: date ?? this.date,
        slot: slot ?? this.slot,
        notes: notes ?? this.notes,
        submitting: submitting ?? this.submitting
      );
}

class BookingDraftCubit extends Cubit<BookingDraftState> {
  BookingDraftCubit(): super(BookingDraftState());
  void setClinic(Clinic c){ emit(state.copyWith(clinic: c, dentist: null, slot: null)); }
  void setService(Service s){ emit(state.copyWith(service: s, slot: null)); }
  void setDentist(Dentist d){ emit(state.copyWith(dentist: d)); }
  void setDate(DateTime d){ emit(state.copyWith(date: DateTime(d.year,d.month,d.day), slot: null)); }
  void setSlot(TimeSlot s){ emit(state.copyWith(slot: s)); }
  void setNotes(String n){ emit(state.copyWith(notes: n)); }
  void clear(){ emit(BookingDraftState()); }
  void setSubmitting(bool v) => emit(state.copyWith(submitting: v));

  void resetForNext() {
    emit(BookingDraftState(
      clinic: state.clinic,
      service: state.service,
      dentist: state.dentist,
      date: state.date,
      slot: null,
      notes: '',
    ));
  }
}


List<TimeSlot> _materializeSlotsForDate(SlotConfig cfg, DateTime date){
  return cfg.slots.map((def){
    final sh = int.parse(def.start.substring(0,2));
    final sm = int.parse(def.start.substring(3,5));
    final eh = int.parse(def.end.substring(0,2));
    final em = int.parse(def.end.substring(3,5));
    final start = DateTime(date.year, date.month, date.day, sh, sm);
    var end = DateTime(date.year, date.month, date.day, eh, em);
    if (end.isBefore(start)) {
      end = end.add(const Duration(days: 1));
    }
    return TimeSlot(id: def.id, startAt: start, endAt: end);
  }).toList(growable: false);
}

extension _DateCmp on DateTime {
  bool isAtSameMomentAsOrAfter(DateTime other) => isAtSameMomentAs(other) || isAfter(other);
}