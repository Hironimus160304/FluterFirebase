import 'package:cloud_firestore/cloud_firestore.dart';

class Shoe {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String imageUrl;

  Shoe({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
  });

  factory Shoe.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    var data = doc.data()!;
    return Shoe(
      id: doc.id,
      name: data['name'] ?? "Unknown",
      brand: data['brand'] ?? "Unknown",
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'brand': brand,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}
