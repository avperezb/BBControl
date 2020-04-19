import 'package:bbcontrol/models/orderProduct.dart';
import 'package:bbcontrol/setup/Database/preOrdersDatabase.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Services/auth.dart';
import 'package:bbcontrol/setup/Pages/Services/connectivity.dart';
import 'package:bbcontrol/setup/Pages/Services/orders_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class PreOrderPage extends StatefulWidget {

  @override
  _PreOrderPageState createState() => _PreOrderPageState();
}

class _PreOrderPageState extends State<PreOrderPage> {

  AuthService _auth = AuthService();
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<OrderProduct> orderList;
  int count = 0;
  CheckConnectivityState checkConnection = CheckConnectivityState();
  bool cStatus = true;
  OrdersFirestoreClass _ordersFirestoreClass = OrdersFirestoreClass();

  @override
  Widget build(BuildContext context) {
    if(orderList== null){
      orderList = List<OrderProduct>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Status'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF6B00),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('log out'),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: RaisedButton(
              padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
              color: const Color(0xFFD7384A),
              onPressed: () async {
                
              },
              child: Text('save',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
            ),
          ),

          Container(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
              child: TextFormField(
                validator: (input) {
                },
                onChanged: (input) {
                  print(databaseHelper);
                },
                decoration: InputDecoration(
                  icon: const Icon(Icons.email,
                      color: const Color(0xFFD7384A)
                  ),
                  hintText: 'Enter an email address',
                  labelText: 'Email',
                ),
              )
          ),
          Container(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
              child: TextFormField(
                validator: (input) {
                },
                onChanged: (input) {
                  print(databaseHelper);
                },
                decoration: InputDecoration(
                  icon: const Icon(Icons.email,
                      color: const Color(0xFFD7384A)
                  ),
                  hintText: 'Enter an email address',
                  labelText: 'Email',
                ),
              )
          ),
          Container(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
              child: TextFormField(
                validator: (input) {
                },
                onChanged: (input) {
                  updateListView();
                },
                decoration: InputDecoration(
                  icon: const Icon(Icons.email,
                      color: const Color(0xFFD7384A)
                  ),
                  hintText: 'Enter an email address',
                  labelText: 'Email',
                ),
              )
          ),
          Container(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
              child: TextFormField(
                validator: (input) {
                },
                onChanged: (input) {
                },
                decoration: InputDecoration(
                  icon: const Icon(Icons.email,
                      color: const Color(0xFFD7384A)
                  ),
                  hintText: 'Enter an email address',
                  labelText: 'Email',
                ),
              )
          ),
        ],
      ),
    );
  }

  void updateListView() {

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){

      Future<List<OrderProduct>> orderListFuture = databaseHelper.getList();
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
