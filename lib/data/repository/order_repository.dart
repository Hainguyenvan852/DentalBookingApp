import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_booking_app/data/model/order_model.dart';
import 'package:dental_booking_app/data/repository/invoice_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderRepository{

  late final FirebaseFirestore _db;
  late final FirebaseAuth _auth;
  final _invoiceRepository = InvoiceRepository();
  
  OrderRepository(){
    _db = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
  }

  Future<List<OrderModel>> getAll() async {
    final snapshot = await _db
      .collection('orders')
      .where('customerId', isEqualTo: _auth.currentUser!.uid)
      .get();

      final data = snapshot.docs.map((docs) => fromSnapshot(docs)).toList();
      
      List<OrderModel> orders = [];

      for(var i in data){
        final invoice = await _invoiceRepository.getById(i['invoiceId']);
        if(invoice == null) break;

        orders.add(OrderModel(
          id: i['id'],
          invoice: invoice,
          addressDelivery: i['addressDelivery'],
          phoneContact: i['phoneContact'],
          status: i['status'],
          customerId: i['customerId']
        ),);
      }
    return orders;
  }

  Future<String> createNewOrder(OrderModel order) async {
    try{
      await _db
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('orders')
          .add(toMap(order));

      return 'success';
    } catch (e){
      return 'error: $e';
    }
  }
}

Map<String, dynamic> fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {

  return {
    "id": data.id, 
    "invoiceId": data['invoiceId'], 
    "addressDelivery": data['addressDelivery'], 
    "phoneContact": data['phoneContact'], 
    "status": data['status'],
    "customerId": data['customerId']
  };
}

Map<String, dynamic> toMap(OrderModel order){
  return {
    'invoiceId': order.invoice.id,
    'addressDelivery' : order.addressDelivery,
    'phoneContact' : order.phoneContact,
    'status' : order.status,
    'customerId' : order.customerId
  };
}