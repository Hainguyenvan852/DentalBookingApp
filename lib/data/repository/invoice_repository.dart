import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_booking_app/data/model/invoice_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InvoiceRepository{

  late final FirebaseFirestore _db;
  late final CollectionReference<Invoice> _invoiceRef;
  late final FirebaseAuth _auth;

  InvoiceRepository(){
    _db = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;

    _invoiceRef = _db
        .collection('invoices')
        .withConverter(
        fromFirestore: (snap, _) => Invoice.fromDoc(snap),
        toFirestore: (invoice, _) => invoice.toMap()
    );
  }

  Future<List<Invoice>> getAll() async {
    final snapshot = await _invoiceRef
        .where('patientId', isEqualTo: _auth.currentUser!.uid)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((docs) => docs.data()).toList();
  }

  Future<Invoice?> getById(String paymentId) async {
    final docs = await _invoiceRef
        .doc(paymentId)
        .get();

    return docs.data();
  }

  Future<String> updateInvoice(Invoice i) async{
    try{
      await _invoiceRef.doc(i.id).update(i.toMap());
      return 'success';
    } catch(e){
      return e.toString();
    }
  }

  Future<String> createNewInvoice(Invoice i) async{
    try{
      final doc = await _invoiceRef.add(i);
      return doc.id;
    } catch(e){
      return 'error';
    }
  }
}