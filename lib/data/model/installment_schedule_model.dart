import 'package:cloud_firestore/cloud_firestore.dart';

class InstallmentSchedule{
  final String id;
  final String? paymentId;
  final DateTime dueDate; // hạn trả góp
  final int amountDue;
  final int installmentNumber;
  final String status;

  InstallmentSchedule({
    required this.id,
    required this.installmentNumber,
    required this.dueDate,
    required this.amountDue,
    required this.paymentId,
    required this.status
  });

  factory InstallmentSchedule.fromDoc(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    final ts = data['dueDate'] as Timestamp;

    return InstallmentSchedule(
      id: snap.id,
      dueDate: ts.toDate(),
      amountDue: data['amountDue'] as int,
      status: data['status'] as String,
      paymentId: data['paymentId'] as String,
      installmentNumber: data['installmentNumber'] as int,
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': paymentId,
    'paymentId': paymentId,
    'installmentNumber': installmentNumber,
    'dueDate': dueDate,
    'amountDue': amountDue,
    'status': status
  };
}
