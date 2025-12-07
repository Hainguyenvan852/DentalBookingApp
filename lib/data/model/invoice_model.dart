import 'package:cloud_firestore/cloud_firestore.dart';

class Invoice{
  final String? id;
  final String patientId;
  final String? paymentId;
  final String paymentType;
  final String invoiceType;
  final DateTime createdAt;
  final int totalAmount;
  final int amountPaid;
  final int balance;
  final String description;
  final String status;
  final List<dynamic> lineItems;

  Invoice({
    required this.id,
    required this.status,
    required this.amountPaid,
    required this.balance,
    required this.invoiceType,
    required this.createdAt,
    required this.totalAmount,
    required this.patientId,
    required this.paymentId,
    required this.paymentType,
    required this.description,
    required this.lineItems
  });

  Invoice copyWith({
    String? id,
    String? status,
    int? amountPaid,
    int? balance,
    String? invoiceType,
    DateTime? createdAt,
    int? totalAmount,
    String? patientId,
    String? paymentId,
    String? paymentType,
    String? description,
    List<dynamic>? lineItems}){
    return Invoice(
      id: id ?? this.id,
      status: status ?? this.status,
      amountPaid: amountPaid ?? this.amountPaid,
      balance: balance ?? this.balance,
      invoiceType: invoiceType ?? this.invoiceType,
      createdAt: createdAt ?? this.createdAt,
      totalAmount: totalAmount ?? this.totalAmount,
      patientId: patientId ?? this.patientId,
      paymentId: paymentId ?? this.paymentId,
      paymentType: paymentType ?? this.paymentType,
      description: description ?? this.description,
      lineItems: lineItems ?? this.lineItems
    );
  }

  factory Invoice.fromDoc(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    final ts = data['createdAt'] as Timestamp;

    return Invoice(
      id: snap.id,
      invoiceType: data['invoiceType'] as String,
      createdAt: ts.toDate(),
      totalAmount: data['totalAmount'] as int,
      description: data['description'] as String,
      patientId: data['patientId'] as String,
      paymentId: data['paymentId'] as String?,
      paymentType: data['paymentType'],
      status: data['status'] as String,
      amountPaid: data['amountPaid'] as int,
      balance: data['balance'] as int,
      lineItems: data['lineItems']
    );
  }

  Map<String, dynamic> toMap() => {
    'patientId': patientId,
    'paymentType': paymentType,
    'invoiceType': invoiceType,
    'paymentId': paymentId,
    'createdAt': createdAt,
    'totalAmount': totalAmount,
    'description': description,
    'amountPaid': amountPaid,
    'balance': balance,
    'status': status,
    'lineItems': lineItems
  };
}
