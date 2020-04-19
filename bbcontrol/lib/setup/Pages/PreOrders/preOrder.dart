import 'package:bbcontrol/models/orderProduct.dart';
import 'package:bbcontrol/setup/Database/preOrdersDatabase.dart';
import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class PreOrderPage extends StatefulWidget {

  @override
  _PreOrderPageState createState() => _PreOrderPageState();
}

class _PreOrderPageState extends State<PreOrderPage> {

  var formatCurrency = NumberFormat.currency(symbol: '\$',decimalDigits: 0, locale: 'en_US');
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<OrderProduct> orderList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Order status'),
          centerTitle: true,
          backgroundColor: const Color(0xFFFF6B00),
        ),
        bottomSheet: Card(
          elevation: 6.0,
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.55,
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    color: const Color(0xFFD7384A),
                    onPressed: () { },
                    child: Text('Add to order',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: FutureBuilder(
          future: databaseHelper.getAllOrders(),
          initialData: List<OrderProduct>(),
          builder: (BuildContext context, AsyncSnapshot<List<OrderProduct>> snapshot){
            if(snapshot.hasData) {
              return ListView(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Quantity',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Product',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Price',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  for(OrderProduct orderProduct in snapshot.data)
                    ListTile(
                      title: Container(
                        margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                width: 50,
                                child: Text(orderProduct.quantity.toString())
                            ),
                            Container(
                                width: 100,
                                child: Text(orderProduct.productName)),
                            Text(formatCurrency.format(orderProduct.price*orderProduct.quantity)),
                          ],
                        ),
                      ),
                      subtitle: Text(orderProduct.foodComments),
                    ),
                ],
              );
            }
            else{
              return Scaffold(
                appBar: AppBar(
                  title: Text('Order status'),
                  centerTitle: true,
                  backgroundColor: const Color(0xFFFF6B00),
                ),
                body: ColorLoader5(
                  dotOneColor: Colors.redAccent,
                  dotTwoColor: Colors.blueAccent,
                  dotThreeColor: Colors.green,
                  dotType: DotType.circle,
                  dotIcon: Icon(Icons.adjust),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          },
        )
    );
  }

  void updateListView() {

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){

      Future<List<OrderProduct>> orderListFuture = databaseHelper.getAllOrders();
      orderListFuture.then((orderList){
        setState(() {
          this.orderList = orderList;
          this.count = orderList.length;
          print(orderList);
        });
      });
    });
  }
}