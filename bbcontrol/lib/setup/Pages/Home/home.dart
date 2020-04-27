import 'package:bbcontrol/Setup/Pages/Food/food.dart';
import 'package:bbcontrol/models/customer.dart';
import 'package:bbcontrol/models/navigation_model.dart';
import 'package:bbcontrol/models/orderItem.dart';
import 'package:bbcontrol/setup/Database/orderItemDatabase.dart';
import 'package:bbcontrol/setup/Pages/DrawBar/edit_Profile.dart';
import 'package:bbcontrol/setup/Pages/DrawBar/expenses_Control.dart';
import 'package:bbcontrol/setup/Pages/DrawBar/my_orders.dart';
import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Reservations/reservationsList.dart';
import 'package:bbcontrol/setup/Pages/Services/auth.dart';
import 'package:bbcontrol/setup/Pages/Order/order.dart';
import 'package:bbcontrol/setup/Pages/Services/connectivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class HomeState extends State<Home> {

  CheckConnectivityState checkConnection = CheckConnectivityState();
  DatabaseItem databaseHelper = DatabaseItem();
  bool cStatus = true;
  List<OrderItem> orderList;
  int count = 0;
  final iconSize = 60.0;
  bool isConnected = true;

  Widget build(BuildContext context) {

    return new StreamBuilder(
        stream: Firestore.instance.collection('Customers').document('${widget.customer.id}').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {

            return ColorLoader5(
              dotOneColor: Colors.redAccent,
              dotTwoColor: Colors.blueAccent,
              dotThreeColor: Colors.green,
              dotType: DotType.circle,
              dotIcon: Icon(Icons.adjust),
              duration: Duration(seconds: 1),
            );
          }
          else {
            String userId = snapshot.data['id'];
            String userFirstName = snapshot.data['firstName'];
            String userLastName = snapshot.data['lastName'];
            DateTime dateBirth = snapshot.data['birthDate'].toDate();
            String userEmail = snapshot.data['email'];
            num phoneNumber = snapshot.data['phoneNumber'];

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
                          Container(
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
                          ),
                          Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2,
                                    height: (MediaQuery.of(context).size.height - AppBar().preferredSize.height - 24.0) * 4 / 9,
                                    child: FlatButton(
                                      color: const Color(0xFFD7384A),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed('/Drinks', arguments: userId);
                                        showToast(context);
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
                                      onPressed: () {
                                        Navigator.of(context).pushNamed('/Cab');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2,
                                    height: (MediaQuery.of(context).size.height - AppBar().preferredSize.height - 24.0) * 2 / 9,
                                    child: FlatButton(
                                      color: const Color(0xFFFF6B00),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed('/Offers');
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
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2,
                                    height: (MediaQuery.of(context).size.height - AppBar().preferredSize.height -24.0) * 4 / 9,
                                    child: Builder(
                                      builder: (context) =>
                                          FlatButton(
                                            color: const Color(0xFFD8AE2D),
                                            onPressed: () {
                                             Navigator.of(context).pushNamed('/Food', arguments: userId);
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
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            height: (MediaQuery
                                .of(context)
                                .size
                                .height - AppBar().preferredSize.height -
                                24.0) / 6,
                            child: FlatButton(
                              color: const Color(0xFF6DAC3B),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => OrderPage()));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  (MediaQuery.of(context).orientation == Orientation.portrait) ? Icon(Icons.shopping_cart,
                                      size: iconSize,
                                      color: Colors.white) : Container(),
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
              endDrawer: new MenuDrawer(userId, dateBirth, userFirstName, userLastName, userEmail, phoneNumber),
            );
          }
        }
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

class MenuDrawer extends StatefulWidget {

  String userIdFromHome;
  String userFirstName;
  String userLastName;
  String userEmail;
  DateTime userDateBirth;
  num userPhoneNumber;

  Function (String, String, String) callback;

  MenuDrawer(String userId, DateTime bd, String userFName, String userLName, String email, num phone){

    this.userIdFromHome = userId;
    this.userFirstName = userFName;
    this.userLastName = userLName;
    this.userEmail = email;
    this.userDateBirth = bd;
    this.userPhoneNumber = phone;
  }

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  double maxWidth = 200;
  NavigationModel option1 = new NavigationModel(
      'My profile', Icons.account_circle);
  NavigationModel option2 = new NavigationModel("My orders", Icons.view_list);
  NavigationModel option3 = new NavigationModel("Settings", Icons.settings);
  NavigationModel option4 = new NavigationModel("Log out", Icons.exit_to_app);
  NavigationModel option5 = new NavigationModel("Call waiter", Icons.restaurant_menu);
  final AuthService _auth = AuthService();
  bool isSwitched = false;
  bool isButtonExpensesDisabled = true;
  @override
  Widget build(BuildContext context) {

    return Container(
      child: new Drawer(
        child: Container(
          color: Color(0xFFEAD0E5),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(
                height: 150.0,
                child: DrawerHeader(
                  decoration: new BoxDecoration(
                      color: Color(0xFFB75BA4)),
                  padding: EdgeInsets.fromLTRB(20, 10, 10, 5),
                  child: Column(
                    children:<Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 10.0),
                        child: Text('${widget.userFirstName}',
                            style: TextStyle(fontSize: 20),
                        ),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.black87, width: 1.0)),
                            color: Colors.transparent
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 10.0),
                          child: Text('${widget.userEmail}',
                            style: TextStyle(fontSize: 17),
                          ),
                        alignment: Alignment.centerLeft,
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                ),
              ),
              Card(////                         <-- Card widget
                color: Color(0xFFF5E8F2),
                child: ListTile(
                  leading: Icon(option1.icon),
                  title: Text(option1.title, style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
                  onTap: action1,
                ),
              ),
              Card( ////             <-- Card widget
                color: Color(0xFFF5E8F2),
                child: ListTile(
                  leading: Icon(option2.icon),
                  title: Text(option2.title, style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
                  onTap: action2,
                ),
              ),
              Card( ////             <-- Card widget
                color: Color(0xFFF5E8F2),
                child: ListTile(
                  leading: Icon(option5.icon),
                  title: Text(option5.title, style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
                  onTap: action2,
                ),
              ),
              Card( //
                color: Color(0xFFF5E8F2),//                          <-- Card widget
                child: ExpansionTile(
                  initiallyExpanded: false,
                  leading: Icon(option3.icon),
                  title: Text(option3.title, style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
                  trailing: Icon(Icons.expand_more),
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 10.0, 0.0),
                      child: Row(
                        children: <Widget>[
                          FlatButton(
                            textColor: Colors.blueGrey,
                            child: Text(
                              'Expenses Control',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                            color: Colors.transparent,
                            onPressed: () {
                              if (!isSwitched) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ExpensesControlPage()));
                              }
                            },
                          ),
                          Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              if (!isSwitched) {
                                setState(() {
                                  isSwitched = value;
                                });
                              }
                              else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildAboutDialog(context),
                                );
                                // Perform some action

                              }
                            },
                            activeTrackColor: Color(0xFFC591BA),
                            activeColor: Color(0xFF8B2275),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 10.0, 0.0),
                      child: Row(
                        children: <Widget>[
                          FlatButton(
                            textColor: Colors.blueGrey,
                            child: Text(
                              'Drunk Mode',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                            color: Colors.transparent,
                            onPressed: () {
                              print('holaaa');
                            },
                          ),
                          Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                color: Color(0xFFF5E8F2),
                child: ListTile(
                  leading: Icon(option4.icon),
                  title: Text(option4.title, style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
                  onTap: action4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void action1() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ProfilePage(userId: widget.userIdFromHome)));
  }

  void action2() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => MyOrdersPage(userId: widget.userIdFromHome)));
  }

  void action3() {

  }

  void action4() {
    Navigator.pop(context);
    _auth.signOut();
  }

  Widget _buildAboutDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Are you sure?'),
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
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Okay, got it!'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Okay, got it!'),
        ),
      ],
    );
  }

  Widget _buildAboutText() {
    return new RichText(
      text: new TextSpan(
        text: 'You\'re about to set the limit of your spent back to none. Think about it!',
        style: const TextStyle(color: Colors.black87),
        children: <TextSpan>[
        ],
      ),
    );
  }
}
