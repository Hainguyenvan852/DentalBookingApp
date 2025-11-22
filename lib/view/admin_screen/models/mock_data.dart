class UserAccount {
  final String id;
  final String name;
  final String role;
  final String phone;


  UserAccount({required this.id, required this.name, required this.role, required this.phone});
}


final List<UserAccount> mockAccounts = [
  UserAccount(id: 'A001', name: 'Nguyễn Văn A', role: 'Admin', phone: '0987000001'),
  UserAccount(id: 'A002', name: 'Trần Thị B', role: 'Reception', phone: '0987000002'),
  UserAccount(id: 'A003', name: 'Lê Văn C', role: 'Doctor', phone: '0987000003'),
];


final List<Map<String, String>> mockAppointments = [
  {'time': '2025-11-20 09:00', 'patient': 'Hoàng D', 'note': 'Khám tổng quát'},
  {'time': '2025-11-20 10:30', 'patient': 'Phạm E', 'note': 'Tẩy trắng răng'},
];