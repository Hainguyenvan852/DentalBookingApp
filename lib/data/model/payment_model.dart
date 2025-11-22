import 'package:cloud_firestore/cloud_firestore.dart';

class Payment{
  final String id;
  final String userId;
  final String invoiceId;
  final String method;
  final DateTime createdAt;
  final int amount;
  final String description;

  Payment({
    required this.id,
    required this.method,
    required this.createdAt,
    required this.amount,
    required this.userId,
    required this.invoiceId,
    required this.description
  });

  factory Payment.fromDoc(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    final ts = data['createdAt'] as Timestamp;

    return Payment(
      id: snap.id,
      method: data['method'] as String,
      createdAt: ts.toDate(),
      amount: data['amount'] as int,
      description: data['description'] as String,
      userId: data['userId'],
      invoiceId: data['invoiceId'],
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'invoiceId': invoiceId,
    'method': method,
    'createdAt': createdAt,
    'amount': amount,
    'description': description
  };
}
