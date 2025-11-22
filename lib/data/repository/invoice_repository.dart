import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_booking_app/data/model/invoice_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InvoiceRepository{

  late final FirebaseFirestore _db;
  late final CollectionReference<Invoice> _paymentRef;
  late final FirebaseAuth _auth;

  InvoiceRepository(){
    _db = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;

    _paymentRef = _db
        .collection('invoices')
        .withConverter(
        fromFirestore: (snap, _) => Invoice.fromDoc(snap),
        toFirestore: (payment, _) => payment.toMap()
    );
  }

  Future<List<Invoice>> getAll(String patientId) async {
    final snapshot = await _paymentRef
        .where('patientId', isEqualTo: patientId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((docs) => docs.data()).toList();
  }

  Future<Invoice?> getById(String paymentId) async {
    final docs = await _paymentRef
        .doc(paymentId)
        .get();

    return docs.data();
  }

  Future<String> updateInvoice(Invoice i) async{
    try{
      await _paymentRef.doc(i.id).update(i.toMap());
      return 'success';
    } catch(e){
      return e.toString();
    }
  }
}