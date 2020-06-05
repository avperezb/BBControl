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

  final AuthService _auth = AuthService();
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
        body: TabBarView(
          children: <Widget>[
            OffersTab(),
            WaitersTab(),
          ],
        ),
      ),
    );
  }
}
