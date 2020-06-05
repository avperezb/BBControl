import 'package:bbcontrol/models/navigation_model.dart';
import 'package:bbcontrol/setup/Pages/Admin/offersTab.dart';
import 'package:bbcontrol/setup/Pages/Admin/waiterTab.dart';
import 'package:bbcontrol/setup/Pages/Services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminTabs extends StatefulWidget {
  String email;
  AdminTabs({this.email});

  @override
  _AdminTabsState createState() => _AdminTabsState();
}

class _AdminTabsState extends State<AdminTabs> with SingleTickerProviderStateMixin {

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('BBControl'),
          centerTitle: true,
          backgroundColor: const Color(0xFFB75BA4),
          bottom: TabBar(
            tabs: [
              Tab(text: 'DAILY PROMOTIONS'),
              Tab(text: 'WAITERS')
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            OffersTab(),
            WaitersTab(),
          ],
        ),
        endDrawer: MenuDrawer(userEmail: widget.email),
      ),
    );
  }
}

class MenuDrawer extends StatefulWidget {

  String userEmail;
  MenuDrawer({this.userEmail});

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  double maxWidth = 200;

  NavigationModel option4 = new NavigationModel("Log out", Icons.exit_to_app);
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
                        child: Text('${widget.userEmail}',
                          style: TextStyle(fontSize: 20),
                        ),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.black87, width: 1.0)),
                            color: Colors.transparent
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
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

  void action4() {
    Navigator.pop(context);
    _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/Login');
  }
}

