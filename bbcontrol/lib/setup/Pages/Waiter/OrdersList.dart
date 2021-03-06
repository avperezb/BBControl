import 'package:bbcontrol/models/employees.dart';
import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';

class OrdersListWaiter extends StatelessWidget {
  final CollectionReference _ordersCollectionReference = Firestore.instance.collection('Orders');
  var formatCurrency = NumberFormat.currency(symbol: '\$', decimalDigits: 0, locale: 'en_US');
  final AuthService _auth = AuthService();
  Employee employee;
  OrdersListWaiter({this.employee});


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _ordersCollectionReference.where(
            'idWaiter', isEqualTo: employee.id).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.documents.isEmpty) {
            loaderFunction();
            return Scaffold(
              appBar: AppBar(
                title: Text('My Orders'),
                centerTitle: true,
                backgroundColor: const Color(0xFFAD4497),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.white
                    ),
                    onPressed: (){
                      _auth.signOut();
                      Navigator.of(context).pushReplacementNamed('/Login');
                    },
                  )
                ],
              ),
              body: Center(
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
                      ],
                    )
                ),
              ),
            );
          }
          else {
            return Scaffold(
              appBar: AppBar(
                title: Text('My Orders'),
                centerTitle: true,
                backgroundColor: const Color(0xFFAD4497),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.white
                    ),
                    onPressed: (){
                      _auth.signOut();
                      Navigator.of(context).pushReplacementNamed('/Login');
                    },
                  )
                ],
              ),
              body:
              Container(
                child: ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, int index) {
                      final items = snapshot.data.documents;
                      String date = DateFormat("yMd").format(items[index]['created'].toDate()).toString();
                      return Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: containerColor('${items[index]['state']}'),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: FlatButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (
                                context) => OrderDetailWaiter(orderId: '${items[index]['id']}', total: items[index]['total'])));
                          },
                          child: ListTile(
                            title: Container(
                              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7),
                              child: Container(
                                child: ListTile(
                                  title: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0.0, 0.0, 0.0, 7),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: <Widget>[
                                        getOrderStatus(
                                            '${items[index]['state']}'),
                                      ],
                                    ),
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>[
                                          Text('Order date: $date',
                                              style: TextStyle(fontSize: 17)),
                                          Text('Total: ${formatCurrency.format(items[index]['total'])}',
                                              style: TextStyle(fontSize: 17)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),
            );
          }
        }
    );
  }

  Color containerColor(String status){
    bool finished = (status == '1') ? true : false;
    if (finished)
      return Color(0xFFF0F4F3);
    else
      return Color(0xFFB3E6AB);
  }

  getOrderStatus(String status) {
    print(status);
    bool finished = (status == '1') ? true : false;
    if (finished)
      return Text('Order has been delivered',
        style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Colors.red[800]
        ),
      );
    else
      return Text('Ongoing order',
        style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Colors.green[800]
        ),
      );
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
}

class OrderDetailWaiter extends StatelessWidget {

  String orderId;
  num total;
  var formatCurrency = NumberFormat.currency(
      symbol: '\$', decimalDigits: 0, locale: 'en_US');

  OrderDetailWaiter({Key key, this.orderId, this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firestore.instance.collection('/Orders/$orderId/products')
            .getDocuments(),
        builder: (context, snapshot) {
          loaderFunction();
          if (!snapshot.hasData || snapshot.data.documents.isEmpty) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Detail of order'),
                  centerTitle: true,
                  backgroundColor: const Color(0xFFAD4497),
                ),
                body: ColorLoader5(
                  dotOneColor: Colors.redAccent,
                  dotTwoColor: Colors.blueAccent,
                  dotThreeColor: Colors.green,
                  dotType: DotType.circle,
                  dotIcon: Icon(Icons.adjust),
                  duration: Duration(seconds: 2),
                )
            );
          }
          else {
            return Scaffold(
              appBar: AppBar(
                title: Text('Detail of order'),
                centerTitle: true,
                backgroundColor: const Color(0xFFAD4497),
              ),
              bottomSheet: Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                height: 60,
                decoration: BoxDecoration(
                    color: Color(0xFFC591BA),
                    borderRadius: BorderRadius.all(
                        Radius.circular(15))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          30, 10, 0, 10),
                      child: Text('TOTAL',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20, fontWeight: FontWeight.w800
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          0, 10, 30, 10),
                      child: Text('${formatCurrency.format(total)}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20, fontWeight: FontWeight.w800
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              body:
              Container(
                child:
                Column(
                  children: <Widget>[
                    Container(
                      color: Color(0xFFF6CDED),
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 40, 10),
                            child: Text('Product', style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 50, 10),
                            child: Text('Quantity', style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 20, 10),
                            child: Text('Price', style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, int index) {
                          final items = snapshot.data.documents;
                          return Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                        padding: EdgeInsets.fromLTRB(0, 13, 0, 0),
                                        width: 120,
                                        height: 50,
                                        child: Container(
                                            child: Text(
                                                '${items[index]['productName']}',
                                                style: TextStyle(fontSize: 18),
                                                textAlign: TextAlign.left)
                                        )
                                    ),
                                    Container(
                                        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                        width: 60,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFCDF6D6),
                                          shape: BoxShape.circle,),
                                        child: Center(
                                          child: Text(
                                            '${items[index]['quantity']}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500
                                            ),),
                                        )
                                    ),
                                    Container(
                                        margin: EdgeInsets.fromLTRB(25, 0, 10, 0),
                                        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        width: 120,
                                        height: 50,
                                        child: Container(
                                            child: Text('${formatCurrency.format(
                                                items[index]['price'])}',
                                                style: TextStyle(fontSize: 16),
                                                textAlign: TextAlign.right))
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    ifSize('${items[index]['beerSize']}')
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                    ),
                  ],
                ),
              ),
            );
          }
        }
    );
  }

  Widget ifSize(String size){

    if (size.length==0){
      return Container(
          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
          width: 120,
          child: Container(
              child: Text('',
                  style: TextStyle( fontSize: 15),textAlign: TextAlign.left)
          )
      );
    }
    else{
      return Container(
          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
          width: 120,
          child: Container(
            child: Text('$size',
                style: TextStyle( fontSize: 15, color: Colors.blueGrey),textAlign: TextAlign.left),
          )
      );
    }

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
}

