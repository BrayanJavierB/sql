import 'package:flutter/material.dart';
//import 'package:sql/crypto_price.dart'; // Importa la clase CryptoPrice
//import 'package:sql/database_helper.dart'; // Importa la clase DatabaseHelper
import 'package:sql/prices_screen.dart'; // Importa la clase PricesScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: PricesScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
