import 'dart:convert';
import 'dart:io';
import 'package:bbcontrol/models/orderItem.dart';
import 'package:bbcontrol/setup/Database/orderItemDatabase.dart';
import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Services/connectivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  num expensesControl = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('/Customers').document(widget.userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            expensesControl = snapshot.data['limitAmount'];
            return Scaffold(
                appBar: AppBar(
                  title: Text('Order status'),
                  centerTitle: true,
                  backgroundColor: const Color(0xFFB75ba4),
                ),
                bottomSheet: Card(
                  elevation: 6.0,
                  child: Container(
                    height: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          child: RaisedButton(
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
                            onPressed: () async {
                              DatabaseItem databaseHelper = new DatabaseItem();
                              if(expensesControl > 0){
                                if(getTotal()<=expensesControl){
                                  jsonDecode(widget.order).forEach((name,
                                      content) async {
                                    if (content['quantity'] > 0) {
                                      OrderItem op = OrderItem.withId(
                                          uuid.v1(), name, content['quantity'], "",
                                          content['price']);
                                      await databaseHelper.insertItem(op);
                                      checkInternetConnection(context);
                                      Navigator.of(context).pushNamedAndRemoveUntil('/Order', ModalRoute.withName('/'),arguments: widget.userId);
                                    }
                                  });
                                }
                                else{
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildAboutDialog(context),
                                  );
                                }
                              }
                              else {
                                jsonDecode(widget.order).forEach((name,
                                    content) async {
                                  if (content['quantity'] > 0) {
                                    OrderItem op = OrderItem.withId(
                                        uuid.v1(), name, content['quantity'], "",
                                        content['price']);
                                    await databaseHelper.insertItem(op);
                                    checkInternetConnection(context);
                                    Navigator.of(context).pushNamedAndRemoveUntil('/Order', ModalRoute.withName('/'),arguments: widget.userId);
                                  }
                                });
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                body: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - 100,
                      child: ListView(
                          children:
                          getProductList()
                      ),
                    ),
                  ],
                )
            );
          } else {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Order status'),
                  centerTitle: true,
                  backgroundColor: const Color(0xFFB75ba4),
                ),
                bottomSheet: Card(
                  elevation: 6.0,
                  child: Container(
                    height: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          child: RaisedButton(
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
                            onPressed: () async{
                              DatabaseItem databaseHelper = new DatabaseItem();
                              if (expensesControl > 0) {
                                if (getTotal() <= expensesControl) {
                                  jsonDecode(widget.order).forEach((name,
                                      content) async {
                                    if (content['quantity'] > 0) {
                                      OrderItem op = OrderItem.withId(
                                          uuid.v1(), name, content['quantity'],
                                          "",
                                          content['price']);
                                      await databaseHelper.insertItem(op);

                                      checkInternetConnection(context);
                                      Navigator.of(context).pushNamedAndRemoveUntil(
                                          '/Order', ModalRoute.withName('/'),
                                          arguments: widget.userId);
                                    }
                                  });
                                }
                                else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildAboutDialog(context),
                                  );
                                }
                              }
                              else {
                                jsonDecode(widget.order).forEach((name,
                                    content) async {
                                  if (content['quantity'] > 0) {
                                    OrderItem op = OrderItem.withId(
                                        uuid.v1(), name, content['quantity'],
                                        "",
                                        content['price']);
                                    await databaseHelper.insertItem(op);
                                    checkInternetConnection(context);
                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                        '/Order', ModalRoute.withName('/'),
                                        arguments: widget.userId);
                                  }
                                });
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                body: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height - AppBar().preferredSize.height - 100,
                      child: ListView(
                          children:
                          getProductList()
                      ),
                    ),
                  ],
                )
            );
          }
        });
  }

  Widget loaderFunction() {
    return ColorLoader5(
      dotOneColor: Colors.redAccent,
      dotTwoColor: Colors.blueAccent,
      dotThreeColor: Colors.green,
      dotType: DotType.circle,
      dotIcon: Icon(Icons.adjust),
      duration: Duration(seconds: 2),
    );
  }
  Widget _buildAboutDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Cannot add your order!'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAboutText(),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          },
          textColor: Theme
              .of(context)
              .primaryColor,
          child: const Text('Okay, got it'),
        ),
      ],
    );
  }


  Widget _buildAboutText() {
    return new Text('Yoou set a limit for the expenses control. If you have changed your mind go to settings and change it!',
        style: const TextStyle(color: Colors.black87, fontSize: 15.9),
        textAlign: TextAlign.justify,
    );
  }


  void showToast(BuildContext context) async {
    await checkConnection.initConnectivity();
    setState(() {
      cStatus = checkConnection.getConnectionStatus(context);
    });
  }

  checkInternetConnection(context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      return connectionErrorToast();
    }
  }

  connectionErrorToast(){
    return showSimpleNotification(
      Text("Connection error",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
        ),),
      subtitle: Text('Products will still be added to your cart, but won\'t be able to order.',
        style: TextStyle(
        ),),
      trailing: Builder(builder: (context) {
        return FlatButton(
            textColor: Colors.white,
            onPressed: () {
              OverlaySupportEntry.of(context).dismiss();
            },
            child: Text('Dismiss',
              style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 16
              ),));
      }),
      background: Colors.deepPurpleAccent,
      autoDismiss: false,
      slideDismiss: true,
    );
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