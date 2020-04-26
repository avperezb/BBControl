import 'package:bbcontrol/models/order.dart';
import 'package:bbcontrol/models/orderItem.dart';
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
          backgroundColor: const Color(0xFFD7384A),
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
                                color: const Color(0xFFD7384A),
                                onPressed: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil('/Drinks', ModalRoute.withName('/'),arguments: widget.userId);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.room_service,
                                    size: 45),
                                color: const Color(0xFFD7384A),
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
                          width: 160,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.delete_outline,
                                    color: Colors.red),
                                onPressed: (){
                                  databaseHelper.deleteDB();
                                  deletedOrderToast();
                                  Navigator.of(context)
                                      .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                                },
                              ),
                              FlatButton(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                color: Colors.transparent,
                                child: Text('EMPTY ORDER',
                                  style: TextStyle(
                                      color: Colors.red
                                  ),
                                ),
                                onPressed: (){
                                  databaseHelper.deleteDB();
                                  deletedOrderToast();
                                  Navigator.of(context)
                                      .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                                },
                              ),
                            ],
                          )
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * .7,
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
                                          onPressed: () async{
                                            await databaseHelper.deletePreOrder(orderProduct.id);
                                            setState(() {
                                              auxReload = !auxReload;
                                            });
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
                                var uuid = new Uuid();
                                print(widget.userId);
                                Order newOrder = new Order.withId(uuid.v1(), "", widget.userId, DateTime.now());
                                await _ordersFirestoreClass.createOrder(newOrder);
                                for(OrderItem item in snapshot.data){
                                  print('ITEM:');print(item);
                                  await _ordersFirestoreClass.addItemToOrder(item,newOrder.id);
                                }
                                databaseHelper.deleteDB();
                                showToast(context);
                                if (!cStatus) {
                                  Navigator.of(context)
                                      .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
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
                                else{
                                  Navigator.of(context)
                                      .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                                  return showOverlayNotification((context) {
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
                              },
                              padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              color: const Color(0xFFD7384A),
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
                                    padding: EdgeInsets.fromLTRB(
                                        20, 10, 20, 10),
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