import 'dart:convert';

import 'package:bbcontrol/models/orderItem.dart';
import 'package:bbcontrol/setup/Database/orderItemDatabase.dart';
import 'package:bbcontrol/setup/Pages/Services/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:uuid/uuid.dart';

class PreOrderPage extends StatefulWidget {
  String order;
  String userId;
  var uuid = new Uuid();

  PreOrderPage(String order, String userId){
    this.order = order;
    this.userId = userId;
  }
  @override
  _PreOrderPageState createState() => _PreOrderPageState();
}

class _PreOrderPageState extends State<PreOrderPage> {

  var uuid = new Uuid();

  var formatCurrency = NumberFormat.currency(
      symbol: '\$', decimalDigits: 0, locale: 'en_US');
  CheckConnectivityState checkConnection = CheckConnectivityState();
  List<OrderItem> orderList;
  int count = 0;
  bool cStatus = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Order status'),
          centerTitle: true,
          backgroundColor: const Color(0xFFB75ba4),
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
                          DatabaseItem databaseHelper = new DatabaseItem();
                          jsonDecode(widget.order).forEach((name,
                              content) async {
                            if (content['quantity'] > 0) {
                              OrderItem op = OrderItem.withId(
                                  uuid.v1(),name, content['quantity'], "",
                                  content['price']);
                              await databaseHelper.insertItem(op);
                            }
                          });
                          Navigator.of(context).pushNamedAndRemoveUntil('/Order', ModalRoute.withName('/'),arguments: widget.userId);
                        },
                        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        color: const Color(0xFFB75ba4),
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
    jsonDecode(widget.order).forEach((name, content) {
      if (content['quantity'] > 0) {
        total += content['price']*content['quantity'];
      }
    });
    return total;
  }

  getProductList() {
    List<OrderItem> auxList = new List<OrderItem>();
    jsonDecode(widget.order).forEach((name, content) {
      if (content['quantity'] > 0) {
        OrderItem op = new OrderItem.withId(
            uuid.v1(),name, content['quantity'], "", content['price']);
        auxList.add(op);
      }
    });
    return auxList.map<Widget>((orderItem) {
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
                          orderItem.quantity.toString(),
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
                          child: Text(orderItem.productName)
                      )
                  ),
                ],
              ),
              Container(
                  child: Text(formatCurrency.format(
                      orderItem.price * orderItem.quantity))
              ),
            ],

          ),
        ),
      );
    }).toList();
  }
}