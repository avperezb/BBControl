import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:bbcontrol/models/orderProduct.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{

  static DatabaseHelper _databaseHelper; //Singleton DatabaseHelper
  static Database _database;
  DatabaseHelper._createInstance();

  String preOrderTable = 'orderTable';
  String colId = 'id';
  String colProductName = 'productName';
  String colQuantity = 'quantity';
  String colBeerSize = 'beerSize';
  String colPrice = 'price';
  String coolFoodComments = 'foodComments';

  factory DatabaseHelper(){

    if(_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
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
    String path = directory.path + 'preOrders';

    var preOrdersDatabase = openDatabase(path, version: 1, onCreate: _createDb);

    return preOrdersDatabase;
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $preOrderTable($colId TEXT PRIMARY KEY, $colProductName TEXT,'
    '$colQuantity INTEGER, $colBeerSize TEXT, $colPrice INTEGER, $coolFoodComments TEXT)');
  }
  
  void deleteDB() async{
    Database db = await this.database;
    await db.execute('DELETE FROM $preOrderTable');
  }

  //Create DB table
  void populateDb(Database database, int version) async {
    await database.execute("CREATE TABLE PreOrders ("
        "id INTEGER PRIMARY KEY,"
        "productName TEXT,"
        "quantity INTEGER,"
        "beerSize INTEGER,"
        "price TEXT,"
        "foodComments TEXT"
        ")");
  }

  getPreOrdersMapList() async{
    Database db = await this.database;
    
   // var result = await db.rawQuery('SELECT * FROM $preOrderTable');
    var result = await db.query(preOrderTable );
    return result;
  }

  Future<int> insertPreOrder(OrderProduct pO) async{
    Database db = await this.database;
    var result = await db.insert(preOrderTable, pO.toMap());
    return result;
  }

  Future<int> updatePreOrder(OrderProduct pO) async{
    var db = await this.database;
    var result = await db.update(preOrderTable, pO.toMap(), where: '$colId = ?', whereArgs: [pO.productName]);
  }

  Future <int> deletePreOrder(String name) async{
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $preOrderTable WHERE $colProductName = \'$name\'');
    return result;
  }

  Future <int> getId(String productName) async{
    var db = await this.database;
    int result = await db.rawDelete('SELECT ID FROM $preOrderTable WHERE $colProductName = $productName');
    return result;
  }

  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $preOrderTable');
    int result = Sqflite.firstIntValue(x);
  }

  Future<List<OrderProduct>> getAllOrders() async{
    var productsList = await getPreOrdersMapList();
    int count = productsList.length;

    List<OrderProduct> pList = List<OrderProduct>();

    for(int i =0; i< count; i++){
      pList.add(OrderProduct.fromMapObject(productsList[i]));
    }
    return pList;
  }

}