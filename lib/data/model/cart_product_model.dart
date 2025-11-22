import 'package:cloud_firestore/cloud_firestore.dart';

class CartProduct {
  final String id;
  final String productId;
  final String nameProduct;
  final String imageUrl;
  final int price;
  int quantity;
  bool isSelected;

  CartProduct({
    required this.id,
    required this.productId,
    required this.nameProduct,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.isSelected,
  });

  CartProduct copyWith({String? id, String? productId, String? nameProduct, String? imageUrl, int? price, int? quantity, bool? isSelected})
    => CartProduct(
      id: id ?? this.id, 
      productId: productId ?? this.productId, 
      nameProduct: nameProduct ?? this.nameProduct, 
      imageUrl: imageUrl ?? this.imageUrl, 
      price: price ?? this.price, 
      quantity: quantity ?? this.quantity, 
      isSelected: isSelected ?? this.isSelected
    );

  Map<String, dynamic> toMap() => {
    'id': id,
    'productId': productId,
    'name': nameProduct,
    'price': price,
    'imageUrl' : imageUrl,
    'quantity': quantity,
    'isSelected': isSelected
  };

  factory CartProduct.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return CartProduct(
      id: snap.id,
      productId: data['productId'],
      nameProduct: data['nameProduct'] as String,
      imageUrl : data['imageUrl'] as String,
      price: data['price'] as int,
      quantity: data['quantity'] as int,
      isSelected: data['isSelected'] as bool
    );
  }
}