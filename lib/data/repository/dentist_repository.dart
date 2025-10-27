import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/dentist_model.dart';

class DentistRepository{

  late final FirebaseFirestore _db;

  DentistRepository(){
    _db = FirebaseFirestore.instance;
  }

  Future<List<Dentist>> getByClinic(String clinicId) async {
    final snap = await _db.collection('clinics')
        .doc(clinicId)
        .collection('staffs')
        .where('type', isEqualTo: 'dentist')
        .get();
    return snap.docs.map((d){
      final m = d.data();
      return Dentist(id: d.id, name: m['name'] as String,);
    }).toList();
  }

  Future<Dentist?> getById(String dentistId, String clinicId) async {
    final doc = await _db.collection('clinics')
        .doc(clinicId)
        .collection('staffs')
        .doc(dentistId)
        .get();

    final m = doc.data()!;

    return Dentist(
        id: doc.id,
        name: m['name']
    );
  }
}