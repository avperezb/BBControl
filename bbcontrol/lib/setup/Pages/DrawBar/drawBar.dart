
import 'package:bbcontrol/models/navigation_model.dart';
import 'package:bbcontrol/setup/Pages/DrawBar/edit_Profile.dart';
import 'package:bbcontrol/setup/Pages/DrawBar/my_orders.dart';
import 'package:bbcontrol/setup/Pages/Services/auth.dart';
import 'package:bbcontrol/setup/Pages/Services/customers_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drunk_Mode.dart';
import 'location.dart';
import 'expenses_Control.dart';

class MenuDrawer extends StatefulWidget {

  String userIdFromHome;
  String userFirstName;
  String userLastName;
  String userEmail;
  DateTime userDateBirth;
  num userPhoneNumber;
  num userLimitAmount;

  MenuDrawer(String userId, DateTime bd, String userFName, String userLName, String email, num phone, num limitAmount){
    this.userIdFromHome = userId;
    this.userFirstName = userFName;
    this.userLastName = userLName;
    this.userEmail = email;
    this.userDateBirth = bd;
    this.userPhoneNumber = phone;
    this.userLimitAmount = limitAmount;
  }

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {

  initState() {
    // TODO: implement initState
    obtenerEstadoExpControl();
    super.initState();
  }

  bool isSwitched = false;
  CustomersFirestoreClass _customersFirestoreClass = CustomersFirestoreClass();
  double maxWidth = 200;
  NavigationModel editProfile = new NavigationModel(
      'My profile', Icons.account_circle);
  NavigationModel myOrders = new NavigationModel("My orders", Icons.view_list);
  NavigationModel callWaiter = new NavigationModel("Call waiter", Icons.restaurant_menu);
  NavigationModel  settings = new NavigationModel("Settings", Icons.settings);
  NavigationModel  logOut = new NavigationModel("Log out", Icons.exit_to_app);
  final AuthService _auth = AuthService();

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
                  leading: Icon(editProfile.icon),
                  title: Text(editProfile.title, style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
                  onTap: actionEditProfile,
                ),
              ),
              Card( ////             <-- Card widget
                color: Color(0xFFF5E8F2),
                child: ListTile(
                  leading: Icon(myOrders.icon),
                  title: Text(myOrders.title, style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
                  onTap: actionMyOrders,
                ),
              ),
              Card( ////             <-- Card widget
                color: Color(0xFFF5E8F2),
                child: ListTile(
                  leading: Icon(callWaiter.icon),
                  title: Text(callWaiter.title, style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
                  onTap: actionCallWaiter,
                ),
              ),
              Card( //
                color: Color(0xFFF5E8F2),//                          <-- Card widget
                child: ExpansionTile(
                  initiallyExpanded: false,
                  leading: Icon(settings.icon),
                  title: Text(settings.title, style: TextStyle(
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ExpensesControlPage(userId: widget.userIdFromHome)));
                            },
                          ),
                          Switch(
                            value: isSwitched,
                            onChanged: (value) async{
                              await guardarEstadoExpControl(value);
                              if (!isSwitched) {
                                if (widget.userLimitAmount > 0){
                                  setState(() {
                                    isSwitched = value;
                                  });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text('Oops!'),
                                            content: new Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                _buildAboutTextLimitZero(),
                                              ],
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                textColor: Theme.of(context).primaryColor,
                                                child: const Text('Cancel'),
                                              ),
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context, rootNavigator: true).pop();
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ExpensesControlPage(userId: widget.userIdFromHome)));
                                                },
                                                textColor: Theme.of(context).primaryColor,
                                                child: const Text('Acept'),
                                              ),
                                            ],
                                          )
                                  );
                                }
                              }
                              else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildAboutDialog(context),
                                );
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
                              actionDrunkMode();
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
                  leading: Icon(logOut.icon),
                  title: Text(logOut.title, style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
                  onTap: actionLogOut,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void obtenerEstadoExpControl() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = prefs.getBool("estadoExpControl");
    });
  }

  guardarEstadoExpControl(bool estadoActual)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("estadoExpControl", estadoActual);
  }

  actionEditProfile() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ProfilePage(userId: widget.userIdFromHome)));
  }

  actionMyOrders() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => MyOrdersPage(userId: widget.userIdFromHome)));
  }

  actionCallWaiter() {
    Navigator.pop(context);
    return showSimpleNotification(
      Text("Hang on a minute",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
        ),),
      subtitle: Text('Your waiter is on the way to assist you.',
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

  actionDrunkMode(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => DrunkModePage()));
  }

  void actionLogOut() {
    Navigator.pop(context);
    _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/Login');
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
          child: const Text('No'),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              isSwitched = !isSwitched;
            });
            _customersFirestoreClass.setLimitAmount(widget.userIdFromHome, 0);
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Yes'),
        ),
      ],
    );
  }

  Widget _buildAboutText() {
    return new RichText(
      text: new TextSpan(
        text: 'You\'re about to set the limit of your spent back to none. Think about it!',
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        children: <TextSpan>[
        ],
      ),
    );
  }

  Widget _buildAboutTextLimitZero() {
    return new RichText(
      text: new TextSpan(
        text: 'Your limit amount must be specified before turning on this mode.',
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        children: <TextSpan>[
        ],
      ),
    );
  }
}
