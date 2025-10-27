import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/clinic_model.dart';
import '../data/model/dentist_model.dart';
import '../data/model/service_model.dart';

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