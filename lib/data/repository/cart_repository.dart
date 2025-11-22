import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_booking_app/data/model/cart_product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartRepository{

  late final FirebaseFirestore _db;
  late final FirebaseAuth _auth;
  late final CollectionReference<CartProduct> _cartRef;
  
  CartRepository(){
    _db = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
     _cartRef = _db
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('cart')
        .withConverter(
        fromFirestore: (snap, _) => CartProduct.fromSnapshot(snap),
        toFirestore: (product, _) => product.toMap()
    );
  }
  
  Future<List<CartProduct>> getAll() async {
    final snapshot = await _cartRef.get();
    
    return snapshot.docs.map((docs) => docs.data()).toList();
  }

  Future<String> update(CartProduct cp) async{
    try{
      await _cartRef.doc(cp.id).update(cp.toMap());
      return 'success';
    } catch(e){
      return 'error: ${e.toString()}';
    }
  }

  Future<String> delete(CartProduct cp) async{
    try{
      await _cartRef.doc(cp.id).delete();
      return 'success';
    } catch(e){
      return 'error: ${e.toString()}';
    }
  }

  Future<String> addToCart(CartProduct cp) async{

    final products = await getAll();

    if(products.isNotEmpty){
      for (var p in products) {
      if (p.productId == cp.productId) {
        final updatedProduct = p.copyWith(quantity: p.quantity + cp.quantity);
        
        await update(updatedProduct); 
        return 'success'; 
      }
    }

      try{
        final Map<String, dynamic> newCart = {
          'productId' : cp.productId,
          'nameProduct' : cp.nameProduct,
          'imageUrl' : cp.imageUrl,
          'price' : cp.price,
          'quantity' : cp.quantity,
          'isSelected' : cp.isSelected
        };
        
        await _db
          .collection('users')
          .doc('fjG3DhpLVtMKXE0eP27w0O3SbYB2')
          .collection('cart')
          .add(newCart);

        return 'success';
      } catch(e){
        return 'error: ${e.toString()}';
      }
    } else{
      try{
        final Map<String, dynamic> newCart = {
          'productId' : cp.productId,
          'nameProduct' : cp.nameProduct,
          'imageUrl' : cp.imageUrl,
          'price' : cp.price,
          'quantity' : cp.quantity,
          'isSelected' : cp.isSelected
        };
        
        await _db
          .collection('users')
          .doc('fjG3DhpLVtMKXE0eP27w0O3SbYB2')
          .collection('cart')
          .add(newCart);

        return 'success';
      } catch(e){
        return 'error: ${e.toString()}';
      }
    }
  }
}