import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_booking_app/view/model/clinic_model.dart';

class ClinicRepository{

  late final FirebaseFirestore _db;
  late final CollectionReference<Clinic> _clinicRef;

  ClinicRepository(){
    _db = FirebaseFirestore.instance;
    _clinicRef = _db
        .collection('clinics')
        .withConverter(
        fromFirestore: (snap, _) => Clinic.fromSnapshot(snap),
        toFirestore: (clinic, _) => clinic.toMap()
    );

  }

  Future<List<Clinic>> getAll() async {
    final snapshot = await _clinicRef
        .get();

    return snapshot.docs.map((docs) => docs.data()).toList();
  }

  Future<Clinic?> get(String clinicId) async {
    final doc = await _clinicRef
        .doc(clinicId)
        .get();

    return doc.data();
  }
}