import 'package:cloud_firestore/cloud_firestore.dart';

class Clinic{
  final String id;
  final String name;
  final String address ;
  final SlotConfig slotConfig;

  const Clinic({
    required this.id,
    required this.name,
    required this.address,
    required this.slotConfig
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'address': address,
    'slotConfig': slotConfig
  };

  factory Clinic.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data()!;
    final cfg = m['slotConfig'] as Map<String, dynamic>;
    final slotsRaw = (cfg['slot'] as List).cast<Map<String, dynamic>>();
    final slots = slotsRaw.map((e) => TimeSlotDef(
      id: e['id'] as String,
      start: e['start'] as String,
      end: e['end'] as String,
      capacity: (e['capacity'] as num).toInt(),
    )).toList();
    return Clinic(
      id: d.id,
      address: m['address'] as String,
      name: m['name'] as String,
      slotConfig: SlotConfig(
        intervalMinutes: (cfg['intervalMinutes'] as num).toInt(),
        slots: slots,
      ),
    );
  }
}

class SlotConfig {
  final int intervalMinutes;
  final List<TimeSlotDef> slots;
  SlotConfig({
    required this.intervalMinutes,
    required this.slots,
  });
}

class TimeSlotDef {
  final String id;
  final String start;
  final String end;
  final int capacity;
  const TimeSlotDef({
    required this.id,
    required this.start,
    required this.end,
    required this.capacity,
  });
}

class TimeSlot {
  final String id; // maps to TimeSlotDef.id
  final DateTime startAt; // absolute time on selected date
  final DateTime endAt; // absolute time on selected date
  TimeSlot({required this.id, required this.startAt, required this.endAt});
}

enum SlotStatus { crowded, normal, empty, closed, userBooked }

