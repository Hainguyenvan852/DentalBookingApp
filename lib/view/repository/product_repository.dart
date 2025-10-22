import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_booking_app/view/model/product_model.dart';

class ProductRepository{

  late final FirebaseFirestore _db;
  late final CollectionReference<Product> _productRef;
  
  ProductRepository(String catalogId){
    _db = FirebaseFirestore.instance;
    _productRef = _db
        .collection('products_catalog')
        .doc(catalogId)
        .collection('products')
        .withConverter(
        fromFirestore: (snap, _) => Product.fromSnapshot(snap),
        toFirestore: (product, _) => product.toMap()
    );
  }
  
  Future<List<Product>> getProductForCatalog() async {
    final snapshot = await _productRef
        .get();

    return snapshot.docs.map((docs) => docs.data()).toList();
  }


}