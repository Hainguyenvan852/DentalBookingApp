import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_booking_app/view/model/service_model.dart';

class ServiceRepository{

  late final FirebaseFirestore _db;
  late final CollectionReference<Service> _serviceRef;

  ServiceRepository(){
    _db = FirebaseFirestore.instance;
    _serviceRef = _db
        .collection('services')
        .withConverter(
        fromFirestore: (snap, _) => Service.fromSnapshot(snap),
        toFirestore: (service, _) => service.toMap()
    );
  }

  Future<List<Service>> getAll() async {
    final snapshot = await _serviceRef
        .get();

    return snapshot.docs.map((docs) => docs.data()).toList();
  }

  Future<Service?> get(String serviceId) async {
    final docs = await _serviceRef
        .doc(serviceId)
        .get();

    return docs.data();
  }
}