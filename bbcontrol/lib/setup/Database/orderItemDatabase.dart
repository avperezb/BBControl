import 'dart:async';
import 'dart:io';
import 'package:bbcontrol/models/orderItem.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseItem{

  static DatabaseItem _databaseHelper; //Singleton DatabaseHelper
  static Database _database;
  DatabaseItem._createInstance();

  String orderItemsTable = 'orderItemsTable';
  String colId = 'id';
  String colProductName = 'productName';
  String colQuantity = 'quantity';
  String colBeerSize = 'beerSize';
  String colPrice = 'price';

  factory DatabaseItem(){

    if(_databaseHelper == null) {
      _databaseHelper = DatabaseItem._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async{

    if(_database== null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase () async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'orderItems';

    var preOrdersDatabase = openDatabase(path, version: 1, onCreate: _createDb);

    return preOrdersDatabase;
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $orderItemsTable'
        '($colId TEXT PRIMARY KEY, $colProductName TEXT,'
        '$colQuantity INTEGER, $colBeerSize TEXT, $colPrice INTEGER)');
  }

  void deleteDB() async{
    Database db = await this.database;
    await db.execute('DELETE FROM $orderItemsTable'
        '');
  }

  //Create DB table
  void populateDb(Database database, int version) async {
    await database.execute("CREATE TABLE orderItems ("
        "id INTEGER PRIMARY KEY,"
        "productName TEXT,"
        "quantity INTEGER,"
        "beerSize INTEGER,"
        "price TEXT)");
  }

  getPreOrdersMapList() async{
    Database db = await this.database;

    // var result = await db.rawQuery('SELECT * FROM $orderItemsTable
    // ');
    var result = await db.query(orderItemsTable
    );
    return result;
  }

  Future<int> insertItem(OrderItem pO) async{
    Database db = await this.database;
    var result = await db.insert(orderItemsTable
        , pO.toMap());
    return result;
  }

  Future<int> updatePreOrder(OrderItem pO) async{
    var db = await this.database;
    var result = await db.update(orderItemsTable
        , pO.toMap(), where: '$colId = ?', whereArgs: [pO.productName]);
  }

  Future <int> deletePreOrder(String id) async{
    var db = await this.database;
    print('id item');
    print(id);
    int result = await db.rawDelete('DELETE FROM $orderItemsTable'
        ' WHERE $colId = \'$id\'');
    return result;
  }

  Future <int> getId(String productName) async{
    var db = await this.database;
    int result = await db.rawDelete('SELECT ID FROM $orderItemsTable'
        ' WHERE $colProductName = $productName');
    return result;
  }

  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $orderItemsTable'
        '');
    int result = Sqflite.firstIntValue(x);
  }

  Future<List<OrderItem>> getAllOrders() async{
    var productsList = await getPreOrdersMapList();
    int count = productsList.length;

    List<OrderItem> pList = List<OrderItem>();

    for(int i =0; i< count; i++){
      pList.add(OrderItem.fromMapObject(productsList[i]));
    }
    return pList;
  }

}