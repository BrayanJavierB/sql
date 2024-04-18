import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sql/database_helper.dart'; // Importa la clase DatabaseHelper
import 'package:sql/crypto_price.dart';
import 'package:sql/database_screen.dart';
import 'dart:async';

class PricesScreen extends StatefulWidget {
  @override
  _PricesScreenState createState() => _PricesScreenState();
}

class _PricesScreenState extends State<PricesScreen> {
  Dio dio = Dio();
  List<CryptoPrice> cryptoPrices = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    Timer.periodic(Duration(minutes: 1), (timer) {
      fetchData();
    });
  }

  void fetchData() async {
    try {
      Response response = await dio.get(
          'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,ripple,litecoin&vs_currencies=usd');
      Map<String, dynamic> cryptoData = response.data;
      setState(() {
        cryptoPrices = [
          CryptoPrice(
              name: 'Bitcoin',
              imagePath: 'assets/images/bitcoin.png',
              price: cryptoData['bitcoin']['usd'].toString()),
          CryptoPrice(
              name: 'Ethereum',
              imagePath: 'assets/images/ethereum.png',
              price: cryptoData['ethereum']['usd'].toString()),
          CryptoPrice(
              name: 'Ripple',
              imagePath: 'assets/images/ripple.png',
              price: cryptoData['ripple']['usd'].toString()),
          CryptoPrice(
              name: 'Litecoin',
              imagePath: 'assets/images/litecoin.png',
              price: cryptoData['litecoin']['usd'].toString()),
        ];
      });
    } catch (error) {
      setState(() {
        cryptoPrices = [
          CryptoPrice(
              name: 'Error',
              imagePath: 'assets/images/error.png',
              price: 'Error al cargar datos')
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Precios de Criptomonedas'),
        backgroundColor: const Color.fromARGB(255, 49, 49, 50),
      ),
      body: ListView.builder(
        itemCount: cryptoPrices.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: ListTile(
              leading: Image.asset(
                cryptoPrices[index].imagePath,
                width: 40,
                height: 40,
              ),
              title: Text(
                '${cryptoPrices[index].name}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '\$${cryptoPrices[index].price}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: Icon(Icons.save),
                onPressed: () async {
                  await DatabaseHelper().insertCryptoPrice(cryptoPrices[index]);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DatabaseScreen()),
          );
        },
        child: Icon(Icons.list),
      ),
    );
  }
}
