import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/clinic_model.dart';

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

  Future<Clinic?> getById(String clinicId) async {
    final doc = await _clinicRef
        .doc(clinicId)
        .get();
    if (!doc.exists) throw StateError('Clinic not found');
    return doc.data();
  }
}