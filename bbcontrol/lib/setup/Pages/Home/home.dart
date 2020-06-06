import 'package:bbcontrol/models/customer.dart';
import 'package:bbcontrol/models/orderItem.dart';
import 'package:bbcontrol/setup/Database/orderItemDatabase.dart';
import 'package:bbcontrol/setup/Pages/DrawBar/location.dart';
import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Reservations/reservationsList.dart';
import 'package:bbcontrol/setup/Pages/Order/order.dart';
import 'package:bbcontrol/setup/Pages/Services/connectivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../DrawBar/drawBar.dart';


class Home extends StatefulWidget {

  const Home({
    Key key,
    @required this.customer, this.inBBC
  }): super(key: key);
  final Customer customer;
  final bool inBBC;

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  void initState() {
    // TODO: implement initState
    putDrunkModeInSP();
    putExpControlInSP();
    isNearBBCC();
    super.initState();
  }

  void isNearBBCC() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
    setState(() {
      inBBC2 = prefs.getBool('estaEnBBCSP');
    });

  }

  void putDrunkModeInSP() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('estadoDrunkMode', false);
  }

  putExpControlInSP() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('estadoExpControl', false);
  }

  bool inBBC2;
  CheckConnectivityState checkConnection = CheckConnectivityState();
  LocationClass lc = LocationClass();
  DatabaseItem databaseHelper = DatabaseItem();
  bool cStatus = true;
  List<OrderItem> orderList;
  int count = 0;
  final iconSize = 60.0;
  bool isConnected = true;
  bool drunkModeState;

  void nearBBC() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      inBBC2 = prefs.getBool("estaEnBBCSP");
    });
  }

  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance.collection('Customers').document('${widget.customer.id}').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return Container(
                color: Colors.white,
                child:  loaderFunction()
            );
          }
          else {
            String userId = snapshot.data['id'];
            String userFirstName = snapshot.data['firstName'];
            String userLastName = snapshot.data['lastName'];
            DateTime dateBirth = snapshot.data['birthDate'].toDate();
            String userEmail = snapshot.data['email'];
            num phoneNumber = snapshot.data['phoneNumber'];
            num limitAmount = snapshot.data['limitAmount'];
            return Scaffold(
              appBar: AppBar(
                title: Text('Menu'),
                centerTitle: true,
                backgroundColor: const Color(0xFFAD4497),
              ),
              body: Builder(
                builder: (context) =>
                    ListView(
                      children: <Widget>[ Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          reservationsButton(userId),
                          Row(
                            children: <Widget>[
                              drinksButton(userId),
                              Column(
                                children: <Widget>[
                                  specialOffersButton(userId, inBBC2),
                                  foodButton(userId, inBBC2),
                                ],
                              ),
                            ],
                          ),
                          currentOrdersButton(inBBC2),
                        ],
                      ),
                      ],
                    ),
              ),
              endDrawer: new MenuDrawer(userId, dateBirth, userFirstName, userLastName, userEmail, phoneNumber, limitAmount),
            );
          }
        }
    );
  }

  Widget reservationsButton(userId){
    return Container(
      height: (MediaQuery
          .of(context)
          .size
          .height - AppBar().preferredSize.height -
          24.0) / 6,
      child: FlatButton(
        color: const Color(0xFF69B3E7),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => ReservationsList(userId)),);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            (MediaQuery.of(context).orientation == Orientation.portrait) ? Icon(Icons.group,
                size: iconSize,
                color: Colors.white) : Container(),
            Text('Reservations',
              style: TextStyle(
                color: Colors.white,
              ),)
          ],
        ),
      ),
    );
  }

  Widget specialOffersButton(String userId, bool inBBC){
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: (MediaQuery.of(context).size.height - AppBar().preferredSize.height - 24.0) * 2 / 9,
      child: FlatButton(
        color: const Color(0xFFFF6B00),
        onPressed: () async{
          nearBBC();
          print('está en bbc?');
          print(inBBC2);
          if (inBBC2) {
            Navigator.of(context).pushNamed('/Offers', arguments: userId);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            (MediaQuery.of(context).orientation == Orientation.portrait) ? Icon(Icons.local_offer,
                size: iconSize,
                color: Colors.white) : Container(),
            Text('Special offers',
              style: TextStyle(
                color: Colors.white,
              ),)
          ],
        ),
      ),
    );
  }

  Widget drinksButton(String userId){
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 2,
          height: (MediaQuery.of(context).size.height - AppBar().preferredSize.height - 24.0) * 4 / 9,
          child: FlatButton(
            color: const Color(0xFFD7384A),
            onPressed: () async{
            nearBBC();
            print('está en bbc?');
            print(inBBC2);
            if (inBBC2) {
              Navigator.of(context).pushNamed('/Drinks', arguments: userId);
            }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment
                  .center,
              children: <Widget>[
                (MediaQuery.of(context).orientation == Orientation.portrait) ? Icon(Icons.local_bar,
                    size: iconSize,
                    color: Colors.white) : Container(),
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
              .height -
              AppBar().preferredSize.height -
              24.0) * 2 / 9,
          child: FlatButton(
            color: const Color(0xFF8f72ff),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment
                  .center,
              children: <Widget>[
                (MediaQuery.of(context).orientation == Orientation.portrait) ? Icon(Icons.directions_car,
                    size: iconSize,
                    color: Colors.white) : Container(),
                Text('Request cab',
                  style: TextStyle(
                    color: Colors.white,
                  ),)
              ],
            ),
            onPressed: () async {
              nearBBC();
              print('está en bbc?');
              print(inBBC2);
              if (inBBC2) {
                Navigator.of(context).pushNamed('/Cab');
              }
            },
          ),
        ),
      ],
    );
  }

  Widget foodButton(String userId, bool inBBC){
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: (MediaQuery.of(context).size.height - AppBar().preferredSize.height -24.0) * 4 / 9,
      child: Builder(
        builder: (context) =>
            FlatButton(
              color: const Color(0xFFD8AE2D),
              onPressed: () async {
                nearBBC();
                print('está en bbc?');
                print(inBBC2);
                if (inBBC2) {
                  Navigator.of(context).pushNamed('/Food', arguments: userId);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  (MediaQuery.of(context).orientation == Orientation.portrait) ? Icon(Icons.room_service,
                      size: iconSize,
                      color: Colors.white) : Container(),
                  Text('Food',
                    style: TextStyle(
                      color: Colors.white,
                    ),)
                ],
              ),
            ),
      ),
    );
  }

  Widget currentOrdersButton(bool inBBC){
    return Container(
      height: (MediaQuery
          .of(context)
          .size
          .height - AppBar().preferredSize.height -
          24.0) / 6,
      child: FlatButton(
        color: const Color(0xFF6DAC3B),
        onPressed: () async{
          nearBBC();
          print('está en bbc?');
          print(inBBC2);
          if (inBBC2) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => OrderPage()));
            loaderFunction();
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            (MediaQuery.of(context).orientation == Orientation.portrait) ? Icon(Icons.shopping_cart,
                size: iconSize,
                color: Colors.white) : Container(),
            Text('Current orders',
              style: TextStyle(
                color: Colors.white,
              ),)
          ],
        ),
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
