import 'dart:convert';

// This is the function RemoteServices is looking for
List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String image;
  final Map rating; // The API sends a map like { "rate": 3.9, "count": 120 }

  // The Constructor
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.rating
  });

  // A helper function to translate the internet data (JSON) into our Dart object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      // We force price to be a double, just in case the API sends an integer
      price: json['price'].toDouble(),
      description: json['description'],
      image: json['image'],
      rating: json['rating'],
    );
  }
}