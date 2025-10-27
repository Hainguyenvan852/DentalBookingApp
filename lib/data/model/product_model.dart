import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final int price;
  final int amount;
  final int discount; // %
  final String imageUrl;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.amount,
    required this.imageUrl,
    required this.description
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'price': price,
    'discount': discount,
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
      discount: data['discount'] as int,
      amount: data['amount'] as int,
      imageUrl : data['imageUrl'] as String,
      description : data['description'] as String,
    );
  }
}