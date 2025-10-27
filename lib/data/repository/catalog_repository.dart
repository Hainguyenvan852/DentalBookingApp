import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/category_model.dart';

class CatalogRepository{
  final _auth = FirebaseAuth.instance;
  late final FirebaseFirestore _db;
  late final CollectionReference<ProductCatalog> _productCatalogRef;

  CatalogRepository(){
    _db = FirebaseFirestore.instance;
    _productCatalogRef = _db
      .collection('products_catalog')
      .withConverter(
        fromFirestore: (snap, _) => ProductCatalog.fromSnapshot(snap),
        toFirestore: (productCatalog, _) => productCatalog.toMap()
      );
  }

  Future<List<ProductCatalog>> getAll() async{
    final snapshot = await _productCatalogRef
        .get();

    return snapshot.docs.map((docs) => docs.data()).toList();
  }

  Future<void> add(ProductCatalog newCatalog) async{
    try{
      await _productCatalogRef.add(newCatalog);
    } on FirebaseException catch (e){
      print(e.message);
    }
  }
}