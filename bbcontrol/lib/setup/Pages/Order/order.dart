import 'dart:io';

import 'package:bbcontrol/models/order.dart';
import 'package:bbcontrol/models/orderItem.dart';
import 'package:bbcontrol/setup/Database/orderItemDatabase.dart';
import 'package:bbcontrol/setup/Pages/DrawBar/math_Operation.dart';
import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Services/connectivity.dart';
import 'package:bbcontrol/setup/Pages/Services/employees_firestore.dart';
import 'package:bbcontrol/setup/Pages/Services/orders_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../DrawBar/drunk_Mode.dart';

class OrderPage extends StatefulWidget {
  String userId;
  OrderPage({this.userId});
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  MathOperation mathOperation = MathOperation();
  bool isSwitched = false;
  int correctAnswer;
  int userAnswer;
  bool isAnswerOkay;
  List<String> operationText;
  List<int> posiblesOpciones;
  int op1;
  int op2;
  int op3;
  var formatCurrency = NumberFormat.currency(
      symbol: '\$', decimalDigits: 0, locale: 'en_US');
  DatabaseItem databaseHelper = DatabaseItem();
  OrdersFirestoreClass _ordersFirestoreClass = OrdersFirestoreClass();
  EmployeesFirestoreClass _employeesFirestoreClass = EmployeesFirestoreClass();
  CheckConnectivityState checkConnection = CheckConnectivityState();
  DrunkModePage drunkModePage = DrunkModePage();
  List<OrderItem> orderList;
  int count = 0;
  bool cStatus = true;
  int total;
  bool auxReload = true;
  int cantOrdenes = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  DocumentSnapshot waiterAvailable;

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: Firestore.instance.collection('BBCEmployees').orderBy('ordersAmount', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData){
            return Container(
                color: Colors.white,
                child:  loaderFunction()
            );
          }else{
            waiterAvailable = snapshot.data.documents[0];
            return Scaffold(
                key: _scaffoldkey,
                appBar: AppBar(
                  title: Text('My order'),
                  centerTitle: true,
                  backgroundColor: const Color(0xFFB75BA4),
                ),
                body: FutureBuilder(
                  future: databaseHelper.getAllOrders(),
                  initialData: List<OrderItem>(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<OrderItem>> snapshot) {
                    if (!snapshot.hasData || snapshot.data.isEmpty) {
                      return Center(
                        child: Container(
                            width: 350,
                            height: 350,
                            decoration: BoxDecoration(
                              color: Colors.blue[200],
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 250,
                                  child: Text(
                                    'It looks like you don\'t have any orders!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Sacramento',
                                        color: Color(0xFF3066BE)
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Text('Start ordering',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 35,
                                        fontFamily: 'Sacramento',
                                        color: Color(0xFF3066BE)
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  width: 150,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.local_bar,
                                            size: 45),
                                        color: Colors.grey[300],
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                              '/Drinks', ModalRoute.withName('/'),
                                              arguments: widget.userId);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.room_service,
                                            size: 45),
                                        color: Colors.grey[300],
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                              '/Food', ModalRoute.withName('/'),
                                              arguments: widget.userId);
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
                      total = getTotal(snapshot);
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
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceAround,
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
                                  onTap: () {
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
                            height: MediaQuery
                                .of(context)
                                .size
                                .height - AppBar().preferredSize.height - 76 * 2,
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
                                                    orderProduct.quantity
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight
                                                            .w400
                                                    ),)
                                              ),
                                              Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 15, 0),
                                                  width: 120,
                                                  child: Container(
                                                      child: Text(
                                                          orderProduct
                                                              .productName)
                                                  )
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                            child: Row(
                                              children: <Widget>[
                                                Text(formatCurrency.format(
                                                    orderProduct.price *
                                                        orderProduct.quantity)),
                                                IconButton(
                                                  icon: Icon(Icons.delete_outline,
                                                      color: Colors.red),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (
                                                          BuildContext context) =>
                                                          _buildAboutDialog(
                                                              context, true,
                                                              orderProduct.id),
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
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              height: 60,
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
                                            padding: EdgeInsets.fromLTRB(
                                                20, 10, 20, 10),
                                            margin: EdgeInsets.fromLTRB(
                                                20, 5, 0, 5),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15))
                                            ),
                                            child: Text(
                                              formatCurrency.format(
                                                  getTotal(snapshot)),
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
                                        try {
                                          final result = await InternetAddress.lookup('google.com');
                                          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            bool estadoDM = await obtenerEstadoDrunkMode();
                                            print('cantidad de órdenes del SP');
                                            cantOrdenes = prefs.getInt('cantOrdenes');
                                            if(cantOrdenes==null) {
                                              print('ddddddddddddddd');
                                              cantOrdenes = 0;
                                            }
                                            print(cantOrdenes);
                                            print('hoooooooola');
                                            print(estadoDM);
                                            if(estadoDM){
                                              showMathOperation(context, snapshot);
                                            }else{
                                              if (cantOrdenes >= 3) {
                                                prefs.setBool("estadoDrunkMode", true);
                                                var res = showMathOperation(
                                                    context, snapshot);
                                                if (res) {
                                                  print('HAHDBFKENVKJNDV');
                                                  //Guardar hora de la última orden
                                                  int timestamp = DateTime.now().millisecondsSinceEpoch;
                                                  prefs.setInt('lastOrderDate', timestamp);
                                                  prefs.setInt('cantOrdenes', cantOrdenes+1);
                                                }
                                              }
                                              else{
                                                print('CANTIDAD ÓRDENES:');
                                                print(cantOrdenes);
                                                var res = await saveOrder(context, snapshot);
                                                if (res) {
                                                  print('eeeeeeeeeee');;
                                                  //Guardar hora de la última orden
                                                  int timestamp = DateTime.now().millisecondsSinceEpoch;
                                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                                  prefs.setInt('lastOrderDate', timestamp);
                                                  prefs.setInt('cantOrdenes', cantOrdenes+1);
                                                  cantOrdenes = prefs.getInt('cantOrdenes');
                                                }
                                                print('EHFBERHJV');
                                                print(cantOrdenes);
                                              }
                                            }
                                          }
                                        } on SocketException catch (_) {
                                          return connectionErrorToast();
                                        }
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
        }
    );
  }

  Future<bool> obtenerEstadoDrunkMode()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("estadoDrunkMode");
  }

  guardarEstadoDrunkMode(bool estadoActual)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("estadoDrunkMode", estadoActual);
  }

  actualizarCantOrdenes(int cant)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("cantidadOrdenes", cant);
  }

  Widget loaderFunction(){
    return ColorLoader5(
      dotOneColor: Colors.redAccent,
      dotTwoColor: Colors.blueAccent,
      dotThreeColor: Colors.green,
      dotType: DotType.circle,
      dotIcon: Icon(Icons.adjust),
      duration: Duration(seconds: 2),
    );
  }

  successfulOrderToast(){
    return showSimpleNotification(
      Text("Your order has been placed",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
        ),),
      subtitle: Text('Sit back and relax while we fulfill your order.',
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
      background: Colors.blue,
      autoDismiss: false,
      slideDismiss: true,
    );
  }

  Future<bool> saveOrder(context, snapshot) async{
    bool rta = false;
    try{
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var uuid = new Uuid();
        databaseHelper.deleteDB();
        Order newOrder = new Order.withId(
            uuid.v1(),
            waiterAvailable.data['id'],
            widget.userId,
            DateTime.now(),
            '0',
            total,
            0);
        _employeesFirestoreClass.updateEmployeeOrdersAmount(
            waiterAvailable.data['id'], 1);
        await _ordersFirestoreClass.createOrder(newOrder);
        rta = true;
        successfulOrderToast();
        for (OrderItem item in snapshot.data) {
          await _ordersFirestoreClass.addItemToOrder(item, newOrder.id);
        }
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/', (Route<dynamic> route) => false);
      }
    } on SocketException catch (_) {
      return connectionErrorToast();
    }
    return rta;
  }

  connectionErrorToast(){
    return showSimpleNotification(
      Text("Oops! no internet connection",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
        ),),
      subtitle: Text('Please check your connection and try again.',
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
      background: Colors.blueGrey,
      autoDismiss: false,
      slideDismiss: true,
    );
  }

  bool showMathOperation(context, snapshot){
    bool rta = false;
    operationText = mathOperation.operation();
    posiblesOpciones = mathOperation.calculateResult(operationText);
    correctAnswer = posiblesOpciones[2];
    op1 = posiblesOpciones[mathOperation.randomNumber(0, 2)];
    posiblesOpciones.remove(op1);
    op2 = posiblesOpciones[mathOperation.randomNumber(0, 1)];
    posiblesOpciones.remove(op2);
    op3 = posiblesOpciones[0];
    posiblesOpciones.remove(op3);
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              title: const Text(
                  'Select the correct answer'),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment
                    .start,
                children: <Widget>[
                  textOfDialog(operationText),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    if (correctAnswer == op1) {
                      setState(() {
                        isSwitched = !isSwitched;
                      });
                      saveOrder(context,snapshot);
                      rta = true;
                    }
                    else {
                      Navigator.of(context).pop();
                      showSnackBar();
                    }
                  },
                  textColor: Theme
                      .of(context)
                      .primaryColor,
                  child: Text(op1.toString()),
                ),
                FlatButton(
                  onPressed: () {
                    if (correctAnswer == op2) {
                      setState(() {
                        isSwitched = !isSwitched;
                      });
                      saveOrder(context,snapshot);
                      rta = true;
                    }
                    else {
                      Navigator.of(context).pop();
                      showSnackBar();
                    }
                  },
                  textColor: Theme
                      .of(context)
                      .primaryColor,
                  child: Text(op2.toString()),
                ),
                FlatButton(
                  onPressed: () {
                    if (correctAnswer == op3) {
                      setState(() {
                        isSwitched = !isSwitched;
                      });
                      saveOrder(context,snapshot);
                      rta = true;
                    }
                    else {
                      Navigator.of(context).pop();
                      showSnackBar();
                    }
                  },
                  textColor: Theme
                      .of(context)
                      .primaryColor,
                  child: Text(op3.toString()),
                ),
              ],
            )
    );
    return rta;
  }

  void showSnackBar() {
    final snackBarContent = SnackBar(
      content: Text("You cannot order if your answer is wrong! Try again.", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15)),
      duration: Duration(days: 1),
      backgroundColor: Color(0xFFDE5F54),
      action: SnackBarAction(
          label: 'Dismiss', onPressed: _scaffoldkey.currentState.hideCurrentSnackBar,textColor: Color(0xFFF7F9F7)),
    );
    _scaffoldkey.currentState.showSnackBar(snackBarContent);
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
    return showSimpleNotification(
      Text("Order deleted",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
        ),),
      subtitle: Text('Your cart is now empty.',
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
      background: Colors.blue,
      autoDismiss: false,
      slideDismiss: true,
    );
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