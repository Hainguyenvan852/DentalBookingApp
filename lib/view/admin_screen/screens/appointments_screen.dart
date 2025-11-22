import 'package:flutter/material.dart';

class Appointment {
  String id;
  String patient;
  DateTime time;
  String note;

  Appointment({
    required this.id,
    required this.patient,
    required this.time,
    this.note = '',
  });
}

class AppointmentsScreen extends StatefulWidget {
  final String searchQuery;
  const AppointmentsScreen({super.key, this.searchQuery = ''});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final List<Appointment> _list = [
    Appointment(id: 'a1', patient: 'Nguyễn Văn An', time: DateTime.now().add(const Duration(days: 1, hours: 9)), note: 'Tư vấn niềng răng'),
    Appointment(id: 'a2', patient: 'Lê Thị Hoa', time: DateTime.now().add(const Duration(days: 2, hours: 10)), note: 'Tẩy trắng'),
  ];

  List<Appointment> _filtered() {
    final q = widget.searchQuery.trim().toLowerCase();
    if (q.isEmpty) return _list;
    return _list.where((ap) {
      return ap.patient.toLowerCase().contains(q) || ap.note.toLowerCase().contains(q) || ap.time.toString().toLowerCase().contains(q);
    }).toList();
  }

  void _openAddEdit({Appointment? item}) {
    final isEdit = item != null;
    final patientCtrl = TextEditingController(text: item?.patient ?? '');
    final timeCtrl = TextEditingController(text: item != null ? item.time.toString() : '');
    final noteCtrl = TextEditingController(text: item?.note ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Sửa lịch' : 'Thêm lịch'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: patientCtrl, decoration: const InputDecoration(labelText: 'Bệnh nhân')),
              TextField(controller: timeCtrl, decoration: const InputDecoration(labelText: 'Thời gian (ví dụ: 2025-11-25 09:00)')),
              TextField(controller: noteCtrl, decoration: const InputDecoration(labelText: 'Ghi chú')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              if (patientCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập tên bệnh nhân')));
                return;
              }
              DateTime parsed;
              try {
                parsed = DateTime.parse(timeCtrl.text.trim());
              } catch (_) {
                // fallback
                parsed = DateTime.now().add(const Duration(hours: 1));
              }
              setState(() {
                if (isEdit) {
                  item!.patient = patientCtrl.text.trim();
                  item.time = parsed;
                  item.note = noteCtrl.text.trim();
                } else {
                  _list.add(Appointment(id: DateTime.now().millisecondsSinceEpoch.toString(), patient: patientCtrl.text.trim(), time: parsed, note: noteCtrl.text.trim()));
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isEdit ? 'Đã cập nhật lịch' : 'Đã thêm lịch')));
            },
            child: Text(isEdit ? 'Lưu' : 'Thêm'),
          )
        ],
      ),
    );
  }

  void _confirmDelete(Appointment ap) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa lịch'),
        content: Text('Xóa lịch của ${ap.patient} vào ${ap.time}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => _list.removeWhere((e) => e.id == ap.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa lịch')));
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  Widget _itemTile(Appointment ap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(ap.patient),
        subtitle: Text('${ap.time} • ${ap.note}'),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(onPressed: () => _openAddEdit(item: ap), icon: const Icon(Icons.edit_sharp)),
          IconButton(onPressed: () => _confirmDelete(ap), icon: const Icon(Icons.delete_sharp)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 6),
      ElevatedButton.icon(
        onPressed: () => _openAddEdit(),
        icon: const Icon(Icons.add_circle_sharp),
        label: const Text('Thêm lịch'),
        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      ),
      const SizedBox(height: 12),
      Expanded(
        child: filtered.isEmpty
            ? const Center(child: Text('Không tìm thấy lịch hẹn'))
            : ListView.separated(
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) => _itemTile(filtered[i]),
        ),
      ),
    ]);
  }
}
