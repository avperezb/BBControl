import 'package:bbcontrol/models/finalOrderProduct.dart';
import 'package:bbcontrol/models/orderProduct.dart';
import 'package:bbcontrol/setup/Database/preOrdersDatabase.dart';
import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Services/connectivity.dart';
import 'package:bbcontrol/setup/Pages/Services/orders_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sqflite/sqflite.dart';

class PreOrderPage extends StatefulWidget {

  @override
  _PreOrderPageState createState() => _PreOrderPageState();
}

class _PreOrderPageState extends State<PreOrderPage> {


  List<FinalOrderProduct> finalListTemp = new List<FinalOrderProduct>();

  var formatCurrency = NumberFormat.currency(symbol: '\$',decimalDigits: 0, locale: 'en_US');
  DatabaseHelper databaseHelper = DatabaseHelper();
  OrdersFirestoreClass _ordersFirestoreClass = OrdersFirestoreClass();
  CheckConnectivityState checkConnection = CheckConnectivityState();
  List<OrderProduct> orderList;
  List<FinalOrderProduct> finalOrderList;
  int count = 0;
  bool cStatus = true;

  @override
  Widget build(BuildContext context) {
    if(orderList== null){
      orderList = List<OrderProduct>();
      updateListView();
    }
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    color: const Color(0xFFD7384A),
                    onPressed: () async {
                      for (int i = 0; i < count; i++) {
                        FinalOrderProduct product = new FinalOrderProduct(
                            i.toString() + 'a', orderList[i].productName,
                            orderList[i].quantity, orderList[i].beerSize,
                            orderList[i].price, orderList[i].foodComments);

                        finalListTemp.add(product);
                        await _ordersFirestoreClass.addProductToOrder(product);
                        bool statusOp = _ordersFirestoreClass
                            .getOperationStatus();
                        if (!statusOp) {
                          //
                        } else {
                          for (i = finalListTemp.length - 1; i >= 0; i--) {
                            finalListTemp.removeLast();
                          }
                        }
                      }
                      showToast(context);
                      if(!cStatus){
                        showOverlayNotification((context) {
                          return Card(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: SafeArea(
                              child: ListTile(
                                title: Text('Oops, network error',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)
                                ),
                                subtitle: Text('Your order will be added when connection is back!.',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                                trailing: IconButton(
                                    icon: Icon(Icons.close, color: Colors.white,),
                                    onPressed: () {
                                      OverlaySupportEntry.of(context).dismiss();
                                    }),
                              ),
                            ),
                            color: Colors.deepPurpleAccent,);
                        }, duration: Duration(milliseconds: 4000));;
                      }
                    },
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
                        Text('Product details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18
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
                              fontSize: 18
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
                            Row(
                              children: <Widget>[
                                Container(
                                    width: 50,
                                    child: Text(orderProduct.quantity.toString())
                                ),
                                Container(
                                    width: 100,
                                    child: Text(orderProduct.productName)),
                              ],
                            ),
                            Container(
                                child: Text(formatCurrency.format(orderProduct.price*orderProduct.quantity))
                            ),
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
  void showToast(BuildContext context) async {
    await checkConnection.initConnectivity();
    setState(() {
      cStatus = checkConnection.getConnectionStatus(context);
    });
  }

  void addOrder() async{

    if (finalListTemp.length != 0){

      List<FinalOrderProduct> finalListTemp = new List<FinalOrderProduct>();
      for (int i = 0; i < count; i++){
        FinalOrderProduct product = new FinalOrderProduct(i.toString()+'a', orderList[i].productName, orderList[i].quantity, orderList[i].beerSize,
            orderList[i].price, orderList[i].foodComments);

        finalListTemp.add(product);
        await _ordersFirestoreClass.addProductToOrder(product);
        bool statusOp = _ordersFirestoreClass.getOperationStatus();
        if(!statusOp){
          //
        }else {
          for (i = finalListTemp.length - 1; i >= 0; i--) {
            finalListTemp.removeLast();
          }
        }
      }
    }
  }
}