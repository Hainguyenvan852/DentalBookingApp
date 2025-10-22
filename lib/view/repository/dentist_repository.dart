import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_booking_app/view/model/dentist_model.dart';

class DentistRepository{

  late final FirebaseFirestore _db;
  late final CollectionReference<Dentist> _dentistRef;

  DentistRepository(String clinicId){
    _db = FirebaseFirestore.instance;
    _dentistRef = _db
        .collection('clinics')
        .doc(clinicId)
        .collection('staffs')
        .withConverter(
        fromFirestore: (snap, _) => Dentist.fromSnapshot(snap),
        toFirestore: (dentist, _) => dentist.toMap()
    );
  }

  Future<List<Dentist>> getDentistForClinic() async {
    final snapshot = await _dentistRef
        .where('type', isEqualTo: 'dentist')
        .get();

    return snapshot.docs.map((docs) => docs.data()).toList();
  }

  Future<Dentist?> get(String dentistId) async {
    final doc = await _dentistRef
        .doc(dentistId)
        .get();

    return doc.data();
  }
}