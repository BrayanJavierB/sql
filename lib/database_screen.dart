import 'package:flutter/material.dart';
import 'package:sql/database_helper.dart'; // Importa la clase DatabaseHelper
import 'crypto_price.dart';

class DatabaseScreen extends StatefulWidget {
  @override
  _DatabaseScreenState createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> {
  late Future<List<List<CryptoPrice>>> _futureCryptoPriceBlocks;
  late List<List<CryptoPrice>> _cryptoPriceBlocks;

  @override
  void initState() {
    super.initState();
    _futureCryptoPriceBlocks = DatabaseHelper().getCryptoPriceBlocks();
  }

  void _deleteCryptoPriceBlock(int blockIndex) async {
    await DatabaseHelper().deleteBlockOfCryptoPrices(
        _cryptoPriceBlocks[blockIndex]
            .map((cryptoPrice) => cryptoPrice.id!)
            .toList());
    setState(() {
      _cryptoPriceBlocks.removeAt(blockIndex);
    });
    ScaffoldMessenger.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registros Guardados'),
        backgroundColor: const Color.fromARGB(255, 49, 49, 50),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<List<CryptoPrice>>>(
        future: _futureCryptoPriceBlocks,
        builder: (BuildContext context,
            AsyncSnapshot<List<List<CryptoPrice>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else {
            _cryptoPriceBlocks = snapshot.data ?? [];
            return ListView.builder(
              itemCount: _cryptoPriceBlocks.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _cryptoPriceBlocks[index]
                                    .map((cryptoPrice) {
                                  return Text(
                                    '${cryptoPrice.name}: \$${cryptoPrice.price}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  );
                                }).toList(),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteCryptoPriceBlock(index);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
