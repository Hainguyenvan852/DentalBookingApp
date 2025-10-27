import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/appointment_model.dart';
import '../data/model/clinic_model.dart';
import '../data/model/service_model.dart';

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

