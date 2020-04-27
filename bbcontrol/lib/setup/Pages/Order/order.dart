import 'dart:io';

import 'package:bbcontrol/models/order.dart';
import 'package:bbcontrol/models/orderItem.dart';
import 'package:bbcontrol/setup/Database/orderItemDatabase.dart';
import 'package:bbcontrol/setup/Pages/Services/connectivity.dart';
import 'package:bbcontrol/setup/Pages/Services/orders_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:uuid/uuid.dart';

class OrderPage extends StatefulWidget {
  String userId;
  OrderPage({this.userId});
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  var formatCurrency = NumberFormat.currency(
      symbol: '\$', decimalDigits: 0, locale: 'en_US');
  DatabaseItem databaseHelper = DatabaseItem();
  OrdersFirestoreClass _ordersFirestoreClass = OrdersFirestoreClass();
  CheckConnectivityState checkConnection = CheckConnectivityState();
  List<OrderItem> orderList;
  int count = 0;
  bool cStatus = true;
  int total;
  bool auxReload = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My order'),
          centerTitle: true,
          backgroundColor: const Color(0xFFB75BA4),
        ),
        body: FutureBuilder(
          future: databaseHelper.getAllOrders(),
          initialData: List<OrderItem>(),
          builder: (BuildContext context, AsyncSnapshot<List<OrderItem>> snapshot) {
            if (!snapshot.hasData || snapshot.data.isEmpty) {
              return Center(
                child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: const Color(0xFFffcc94),
                      shape: BoxShape.circle,

                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Text('Oops!',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            'It looks like you don\'t have any orders',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Text('Start ordering',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          width: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.local_bar,
                                    size: 45),
                                color: const Color(0xFFB75ba4),
                                onPressed: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil('/Drinks', ModalRoute.withName('/'),arguments: widget.userId);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.room_service,
                                    size: 45),
                                color: const Color(0xFFB75ba4),
                                onPressed: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil('/Food', ModalRoute.withName('/'),arguments: widget.userId);
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                ),
              );
            }
            else {
              return Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 15, 20, 0),
                        child: InkWell(
                          child: Container(
                              width: 160,
                              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Icon(Icons.delete_outline,
                                      color: Colors.red),
                                  Text('EMPTY ORDER',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                          ),
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildAboutDialog(context, false, ""),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - 76*2,
                    child: ListView(
                      children: <Widget>[
                        for(OrderItem orderProduct in snapshot.data)
                          ListTile(
                            title: Container(
                              margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 0, 20, 0),
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,),
                                          child: Text(
                                            orderProduct.quantity.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400
                                            ),)
                                      ),
                                      Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 0, 15, 0),
                                          width: 120,
                                          child: Container(
                                              child: Text(
                                                  orderProduct.productName)
                                          )
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Row(
                                      children: <Widget>[
                                        Text(formatCurrency.format(
                                            orderProduct.price *
                                                orderProduct.quantity)),
                                        IconButton(
                                          icon: Icon( Icons.delete_outline,
                                              color: Colors.red),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  _buildAboutDialog(context, true, orderProduct.id),
                                            );
                                          },
                                        )
                                      ],
                                    ),
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
                          ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 6.0,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      height: 70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                  Text('Confirm order',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16
                                    ),
                                  ),
                                  Container(
                                    width: 120,
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    margin: EdgeInsets.fromLTRB(20, 5, 0, 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))
                                    ),
                                    child: Text(
                                      formatCurrency.format(getTotal(snapshot)),
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
                                var uuid = new Uuid();
                                print(widget.userId);
                                Order newOrder = new Order.withId(uuid.v1(), "", widget.userId, DateTime.now());
                                await _ordersFirestoreClass.createOrder(newOrder);
                                for(OrderItem item in snapshot.data){
                                  print('ITEM:');print(item);
                                  await _ordersFirestoreClass.addItemToOrder(item,newOrder.id);
                                }
                                databaseHelper.deleteDB();
                                checkInternetConnection(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        )
    );
  }
  successfulOrderToast(){
    showOverlayNotification((context) {
      return Card(
        margin: const EdgeInsets.fromLTRB(
            0, 0, 0, 0),
        child: SafeArea(
          child: ListTile(
            title: Text('Your order has been placed',
                style: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)
            ),
            subtitle: Text(
              'Sit back and relax while we fulfill your order.',
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
        color: Colors.blue,);
    }, duration: Duration(milliseconds: 4000));
  }
  checkInternetConnection(context) async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        databaseHelper.deleteDB();
        Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        return successfulOrderToast();
      }
    } on SocketException catch (_) {
      databaseHelper.deleteDB();
      Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      return connectionErrorToast();
    }
  }

  connectionErrorToast(){
    return showOverlayNotification((context) {
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

  Widget _buildAboutDialog(BuildContext context, bool isItem, String productId) {
    return new AlertDialog(
      title: const Text('Are you sure?'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAboutText(isItem),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('CANCEL'),
        ),
        FlatButton(
          onPressed: () async{
            if(!isItem){
              Navigator.of(context).pop();
              databaseHelper.deleteDB();
              deletedOrderToast();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
            }
            else{
              Navigator.of(context).pop();
              databaseHelper.deletePreOrder(productId);
              setState(() {
                auxReload = !auxReload;
              });
            }
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('DELETE'),
        ),
      ],
    );
  }

  Widget _buildAboutText(bool isItem) {
    return new RichText(
      text: new TextSpan(
        text: isItem ? 'This item will be deleted from your cart' : 'You won\'t be able to get your products back!',
        style: const TextStyle(color: Colors.black87),
        children: <TextSpan>[
        ],
      ),
    );
  }

  deletedOrderToast(){
    return showOverlayNotification((context) {
      return Card(
        margin: const EdgeInsets.fromLTRB(
            0, 0, 0, 0),
        child: SafeArea(
          child: ListTile(
            title: Text('Order deleted',
                style: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)
            ),
            subtitle: Text(
              'Your cart is now empty.',
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
        color: Colors.blue,);
    }, duration: Duration(milliseconds: 4000));
  }

  int getTotal(snapshot) {
    int total = 0;
    for (OrderItem orderProduct in snapshot.data) {
      total += orderProduct.price * orderProduct.quantity;
    }
    return total;
  }

  void showToast(BuildContext context) async {
    await checkConnection.initConnectivity();
    setState(() {
      cStatus = checkConnection.getConnectionStatus(context);
    });
  }
}