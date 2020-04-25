import 'dart:convert';

import 'package:bbcontrol/models/finalOrderProduct.dart';
import 'package:bbcontrol/models/orderProduct.dart';
import 'package:bbcontrol/setup/Database/preOrdersDatabase.dart';
import 'package:bbcontrol/setup/Pages/Order/order.dart';
import 'package:bbcontrol/setup/Pages/Services/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sqflite/sqflite.dart';

class PreOrderBeer extends StatefulWidget {
  String order;
  PreOrderBeer(String order){
    this.order = order;
  }
  @override
  _PreOrderBeerState createState() => _PreOrderBeerState();
}

class _PreOrderBeerState extends State<PreOrderBeer> {


  List<FinalOrderProduct> finalListTemp = new List<FinalOrderProduct>();

  var formatCurrency = NumberFormat.currency(
      symbol: '\$', decimalDigits: 0, locale: 'en_US');
  DatabaseHelper databaseHelper = DatabaseHelper();
  CheckConnectivityState checkConnection = CheckConnectivityState();
  bool cStatus = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Order status'),
          centerTitle: true,
          backgroundColor: const Color(0xFFD7384A),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * .77,
              child: ListView(
                  children:
                  getProductList()
              ),
            ),
            Card(
              elevation: 6.0,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        color: const Color(0xFFD7384A),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceAround,
                          children: <Widget>[
                            Text('Add to order',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16
                              ),
                            ),
                            Container(
                              width: 120,
                              padding: EdgeInsets.fromLTRB(
                                  20, 10, 20, 10),
                              margin: EdgeInsets.fromLTRB(20, 5, 0, 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(15))
                              ),
                              child: Text(
                                formatCurrency.format(getTotal()),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          showToast(context);
                          if (!cStatus) {
                            showOverlayNotification((context) {
                              return Card(
                                margin: const EdgeInsets.fromLTRB(
                                    0, 0, 0, 0),
                                child: SafeArea(
                                  child: ListTile(
                                    title: Text('Oops, network error',
                                        style: TextStyle(fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)
                                    ),
                                    subtitle: Text(
                                      'Your order will be added when connection is back!.',
                                      style: TextStyle(fontSize: 16,
                                          color: Colors.white),
                                    ),
                                    trailing: IconButton(
                                        icon: Icon(Icons.close,
                                          color: Colors.white,),
                                        onPressed: () {
                                          OverlaySupportEntry.of(context)
                                              .dismiss();
                                        }),
                                  ),
                                ),
                                color: Colors.deepPurpleAccent,);
                            }, duration: Duration(milliseconds: 4000));
                          }
                          DatabaseHelper databaseHelper = new DatabaseHelper();
                          jsonDecode(widget.order).forEach((name,
                              content) => content.forEach((size, specs) async {
                            if(specs['quantity'] > 0){
                              OrderProduct op = new OrderProduct(name, specs['quantity'], size, specs['price'], "");
                              await databaseHelper.insertPreOrder(op);
                            }
                          }));
                          Navigator.pushNamedAndRemoveUntil(context, '/Order', ModalRoute.withName('/'));
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }

  void showToast(BuildContext context) async {
    await checkConnection.initConnectivity();
    setState(() {
      cStatus = checkConnection.getConnectionStatus(context);
    });
  }

  getTotal(){
    int total = 0;
    jsonDecode(widget.order).forEach((name,
        content) => content.forEach((size, specs){
      total += specs['quantity']*specs['price'];
    }));
    return total;
  }

  getProductList() {
    List<OrderProduct> auxList = new List<OrderProduct>();
    jsonDecode(widget.order).forEach((name,
        content) => content.forEach((size, specs){
      if(specs['quantity'] > 0){
        print(name + " "+ specs['quantity'].toString() + " " + size + " "+  specs['price'].toString() );
        OrderProduct op = new OrderProduct.withId(name.hashCode, name, specs['quantity'], size, specs['price'], "");
        auxList.add(op);
      }
    }));

    return auxList.map<Widget>((orderProduct) {
      return ListTile(
        title: Container(
          margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,),
                      child: Center(
                        child: Text(
                          orderProduct.quantity.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w500
                          ),),
                      )
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(
                          0, 0, 15, 0),
                      width: 120,
                      child: Container(
                          child: Text(orderProduct.productName,
                          style: TextStyle(
                          ),)
                      )
                  ),
                ],
              ),
              Container(
                  child: Text(formatCurrency.format(
                      orderProduct.price * orderProduct.quantity))
              ),
            ],

          ),
        ),
        subtitle: Container(
          margin: EdgeInsets.fromLTRB(53, 0, 0, 0),
            child: Text(orderProduct.beerSize,
              style: TextStyle(
                fontSize: 16,
              ),
            )
        ),
      );
    }).toList();
  }
}