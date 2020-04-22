import 'package:bbcontrol/Setup/Pages/Food/food.dart';
import 'package:bbcontrol/Setup/Pages/Reservations/reservationsList.dart';
import 'package:bbcontrol/models/customer.dart';
import 'package:bbcontrol/models/orderProduct.dart';
import 'package:bbcontrol/setup/Database/preOrdersDatabase.dart';
import 'package:bbcontrol/setup/Pages/Services/connectivity.dart';
import 'package:bbcontrol/setup/Pages/Services/customers_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bbcontrol/Setup/Pages/Drinks/drinks.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sqflite/sqflite.dart';


class Home extends StatefulWidget {

  const Home({
    Key key,
    @required this.customer
  }): super(key: key);
  final Customer customer;

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home>{

  CheckConnectivityState checkConnection = CheckConnectivityState();
  DatabaseHelper databaseHelper = DatabaseHelper();
  bool cStatus = true;
  List<OrderProduct> orderList;
  int count = 0;
  final iconSize = 60.0;

  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance.collection('/Customers').document('{$widget.customer.id}').get().asStream(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            var customer = snapshot.data;
            print('holaaaa'+customer['fullName']);
          return Scaffold(
            appBar: AppBar(
              title: Text('Menu'),
              centerTitle: true,
              backgroundColor: const Color(0xFFFF6B00),
            ),
            body: Builder(
              builder: (context) =>
                  ListView(
                    children: <Widget>[ Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          height: (MediaQuery
                              .of(context)
                              .size
                              .height - AppBar().preferredSize.height - 24.0) /
                              6,
                          child: FlatButton(
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                            color: const Color(0xFF69B3E7),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ReservationsList()),);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.group,
                                    size: iconSize,
                                    color: Colors.white),
                                Text('Reservations',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),)
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 2,
                                  height: (MediaQuery
                                      .of(context)
                                      .size
                                      .height - AppBar().preferredSize.height -
                                      24.0) * 4 / 9,
                                  child: FlatButton(
                                    padding: EdgeInsets.fromLTRB(
                                        0.0, 90.0, 0.0, 90.0),
                                    color: const Color(0xFFD7384A),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => DrinksTabs()),);
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Icon(Icons.local_bar,
                                            size: iconSize,
                                            color: Colors.white),
                                        Text('Drinks',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),)
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 2,
                                  height: (MediaQuery
                                      .of(context)
                                      .size
                                      .height - AppBar().preferredSize.height -
                                      24.0) * 2 / 9,
                                  child: FlatButton(
                                    padding: EdgeInsets.fromLTRB(
                                        0.0, 25.0, 0.0, 25.0),
                                    color: const Color(0xFFFF6B00),
                                    onPressed: () {},
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Icon(Icons.directions_car,
                                            size: iconSize,
                                            color: Colors.white),
                                        Text('Request cab',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 2,
                                  height: (MediaQuery
                                      .of(context)
                                      .size
                                      .height - AppBar().preferredSize.height -
                                      24.0) * 2 / 9,
                                  child: FlatButton(
                                    padding: EdgeInsets.fromLTRB(
                                        0.0, 25.0, 0.0, 25.0),
                                    color: const Color(0xFFD8AE2D),
                                    onPressed: () {},
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Icon(Icons.local_offer,
                                            size: iconSize,
                                            color: Colors.white),
                                        Text('Special offers',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),)
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 2,
                                  height: (MediaQuery
                                      .of(context)
                                      .size
                                      .height - AppBar().preferredSize.height -
                                      24.0) * 4 / 9,
                                  child: Builder(
                                    builder: (context) =>
                                        FlatButton(
                                          padding: EdgeInsets.fromLTRB(
                                              0.0, 90.0, 0.0, 90.0),
                                          color: const Color(0xFF996480),
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FoodList()));
                                            showToast(context);
                                            if (!cStatus) {
                                              showOverlayNotification((
                                                  context) {
                                                return Card(
                                                  margin: const EdgeInsets
                                                      .fromLTRB(0, 0, 0, 0),
                                                  child: SafeArea(
                                                    child: ListTile(
                                                      title: Text(
                                                          'Connection Error',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                              color: Colors
                                                                  .white)
                                                      ),
                                                      subtitle: Text(
                                                        'Orders will be added when connection is back.',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors
                                                                .white),
                                                      ),
                                                      trailing: IconButton(
                                                          icon: Icon(
                                                            Icons.close,
                                                            color: Colors
                                                                .white,),
                                                          onPressed: () {
                                                            OverlaySupportEntry
                                                                .of(context)
                                                                .dismiss();
                                                          }),
                                                    ),
                                                  ),
                                                  color: Colors.blueGrey,);
                                              }, duration: Duration(
                                                  milliseconds: 4000));
                                              ;
                                            }
                                          },
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Icon(Icons.room_service,
                                                  size: iconSize,
                                                  color: Colors.white),
                                              Text('Food',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),)
                                            ],
                                          ),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          height: (MediaQuery
                              .of(context)
                              .size
                              .height - AppBar().preferredSize.height - 24.0) /
                              6,
                          child: FlatButton(
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                            color: const Color(0xFFB6B036),
                            onPressed: () {},
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.shopping_cart,
                                    size: iconSize,
                                    color: Colors.white),
                                Text('My order',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ],
                  ),
            ),
            endDrawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  SizedBox(
                    height: 88.0,
                    child: DrawerHeader(
                      child: Text('${snapshot.data["fullName"]}',
                          style: TextStyle(fontSize: 20)),
                      decoration: BoxDecoration(
                          color: Colors.blue
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('My profile', textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 20)),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('My orders', textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 20)),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Settings', textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 20)),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Log out', textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 20)),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        }});
  }

  void choiceAction(String choice){
    print(choice);
  }

  void showToast(BuildContext context) async {
    await checkConnection.initConnectivity();
    setState(() {
      cStatus = checkConnection.getConnectionStatus(context);
    });
  }

  void createDB() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
  }
}

