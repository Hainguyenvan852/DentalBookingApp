import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final int price;
  final int amount;
  final int salePrice;
  final String imageUrl;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.salePrice,
    required this.amount,
    required this.imageUrl,
    required this.description
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'price': price,
    'salePrice': salePrice,
    'amount': amount,
    'imageUrl' : imageUrl,
    'description' : description,
  };

  factory Product.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return Product(
      id: snap.id,
      name: data['name'] as String,
      price: data['price'] as int,
      salePrice: data['salePrice'] as int,
      amount: data['amount'] as int,
      imageUrl : data['imageUrl'] as String,
      description : data['description'] as String,
    );
  }
}