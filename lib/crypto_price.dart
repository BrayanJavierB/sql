class CryptoPrice {
  final int? id;
  final String name;
  final String imagePath;
  final String price;

  CryptoPrice(
      {this.id,
      required this.name,
      required this.imagePath,
      required this.price});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imagePath': imagePath,
      'price': price,
    };
  }
}