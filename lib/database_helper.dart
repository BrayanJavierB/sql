import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql/crypto_price.dart';
import 'dart:async';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'crypto_database.db';
  static const String tableName = 'crypto_prices';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), dbName);

    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        imagePath TEXT,
        price TEXT
      )
    ''');
  }

  Future<int> insertCryptoPrice(CryptoPrice cryptoPrice) async {
    final db = await database;
    return await db.insert(tableName, cryptoPrice.toMap());
  }

  Future<List<CryptoPrice>> getCryptoPrices() async {
    final db = await database;
    final List<Map<String, dynamic>> cryptoPricesMap =
        await db.query(tableName);

    return List.generate(cryptoPricesMap.length, (index) {
      return CryptoPrice(
        id: cryptoPricesMap[index]['id'],
        name: cryptoPricesMap[index]['name'],
        imagePath: cryptoPricesMap[index]['imagePath'],
        price: cryptoPricesMap[index]['price'],
      );
    });
  }

  Future<int> deleteCryptoPrice(int id) async {
    final db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllCryptoPrices() async {
    final db = await database;
    return await db.delete(tableName);
  }
}
