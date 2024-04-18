import 'package:flutter/material.dart';
import 'package:sql/database_helper.dart'; 
import 'crypto_price.dart';

class DatabaseScreen extends StatefulWidget {
  @override
  _DatabaseScreenState createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Base de datos Crypto'),
        backgroundColor: const Color.fromARGB(255, 49, 49, 50),
      ),
      body: FutureBuilder(
        future: DatabaseHelper().getCryptoPrices(),
        builder:
            (BuildContext context, AsyncSnapshot<List<CryptoPrice>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                String price = '\$${snapshot.data![index].price}';
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(
                      snapshot.data![index].name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      price,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await DatabaseHelper()
                            .deleteCryptoPrice(snapshot.data![index].id!);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Registro eliminado'),
                          duration: Duration(seconds: 1),
                        ));
                        setState(() {
                          snapshot.data!.removeAt(index);
                        });
                      },
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


