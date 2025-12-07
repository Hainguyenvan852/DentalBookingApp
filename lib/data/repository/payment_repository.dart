import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_booking_app/data/model/payment_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentRepository{

  late final FirebaseFirestore _db;
  late final CollectionReference<Payment> _paymentRef;
  late final FirebaseAuth _auth;

  PaymentRepository(){
    _db = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;

    _paymentRef = _db
        .collection('payments')
        .withConverter(
        fromFirestore: (snap, _) => Payment.fromDoc(snap),
        toFirestore: (payment, _) => payment.toMap()
    );
  }

  Future<List<Payment>> getAll(String userId) async {
    final snapshot = await _paymentRef
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((docs) => docs.data()).toList();
  }

  Future<Payment?> getById(String paymentId) async {
    final docs = await _paymentRef
        .doc(paymentId)
        .get();

    return docs.data();
  }

  Future<String> createNewPayment(Payment p) async{
    try{
      final result = await _paymentRef.add(p);
      return result.id;
    } catch(e){
      return 'error';
    }
  }
}