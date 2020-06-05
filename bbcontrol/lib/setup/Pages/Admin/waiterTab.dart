import 'dart:io';

import 'package:bbcontrol/models/offer.dart';
import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Waiter/createWaiter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class WaitersTab extends StatefulWidget {
  List<Offer> offers = new List<Offer>();
  @override
  _WaitersTabState createState() => _WaitersTabState();
}

class _WaitersTabState extends State<WaitersTab> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:  Firestore.instance.collection("/BBCEmployees").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.documents.isEmpty) {
            return ColorLoader5();
          }
          else{
            return Scaffold(
              bottomSheet: Container(
                margin: EdgeInsets.all(5),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child:  RaisedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CreateWaiterPage()));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: const Color(0xFFB75ba4))
                    ),
                    color: const Color(0xFFB75ba4),
                    child: Text('ADD',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
              body: Container(
                height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - 130,
                child: ListView(
                  children: snapshot.data.documents.map<SingleWaiter>((DocumentSnapshot waiter ){
                    String fullName = '${waiter['firstName']} ${waiter['lastName']}';
                    return SingleWaiter(name: fullName, active: waiter['active'],);
                  }).toList(),
                ),
              ),
            );
          }
        }
    );
  }

  checkInternetConnection(context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        updateSuccesfulToast();
      }
    } on SocketException catch (_) {
      return connectionErrorToast();
    }
  }

  connectionErrorToast(){
    return showSimpleNotification(
      Text("Connection error",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
        ),),
      subtitle: Text('Offers will be updated once the connection is back.',
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
      background: Colors.deepPurpleAccent,
      autoDismiss: false,
      slideDismiss: true,
    );
  }

  updateSuccesfulToast(){
    return showSimpleNotification(
      Text("Offers updated",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
        ),),
      subtitle: Text('The offers selected were successfully updated.',
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
      background: Colors.cyan,
      autoDismiss: false,
      slideDismiss: true,
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

class SingleWaiter extends StatefulWidget {
  String name;
  bool active;
  SingleWaiter({this.name, this.active});

  @override
  _SingleWaiterState createState() => _SingleWaiterState();
}

class _SingleWaiterState extends State<SingleWaiter> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Text(widget.name),
            ),
            widget.active ?
            Text('Active', style: TextStyle(color: Colors.green),) :
            Text('Inactive', style: TextStyle(color: Colors.red),)
          ],
        ),
      ),
    );
  }
}

