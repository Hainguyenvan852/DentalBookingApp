import 'package:dental_booking_app/data/model/invoice_model.dart';

class OrderModel{
  final String id;
  final Invoice invoice;
  final String addressDelivery;
  final String phoneContact;
  final String status;

  const OrderModel({
    required this.id,
    required this.invoice,
    required this.addressDelivery,
    required this.phoneContact,
    required this.status,
  });
}