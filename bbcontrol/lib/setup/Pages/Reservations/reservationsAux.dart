import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Reservations/reserveTable.dart';
import 'package:bbcontrol/setup/Pages/Reservations/table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../Services/connectivity.dart';

class ReservationView extends StatefulWidget {
  @override
  _ReservationViewState createState() => _ReservationViewState();
}

class _ReservationViewState extends State<ReservationView> {
  int numSeats = 0;
  SingleTable selected;
  CheckConnectivityState checkConnection = CheckConnectivityState();
  bool cStatus = true;
  callback(int seats, SingleTable table){
    setState(() {
      selected = table;
      numSeats = seats;
    });
  }
  bool leftPlacement = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection(
            "/Tables")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Reservations'),
                  centerTitle: true,
                  backgroundColor: const Color(0xFFFF6B00),
                ),
                body :
                ColorLoader5(
                  dotOneColor: Colors.redAccent,
                  dotTwoColor: Colors.blueAccent,
                  dotThreeColor: Colors.green,
                  dotType: DotType.circle,
                  dotIcon: Icon(Icons.adjust),
                  duration: Duration(seconds: 10),
                )
            );
          }
          else {
            return Scaffold(
              appBar: AppBar(
                title: Text('Reservations'),
                centerTitle: true,
                backgroundColor: const Color(0xFFFF6B00),
              ),
              body:Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 15.0),
                    color: const Color(0xFFFF6B00),
                    child: Text('Select the tables you wish to reserve:',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 300,
                          width: 100,
                          color: Colors.brown[400],
                          child: Center(
                            child: Text('Bar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height*.15, 0, 0),
                            child: getPositionedList(snapshot),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 0, 20),
                    child: Text('Number of seats: $numSeats',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 20, 15, 15),
                    child: RaisedButton(
                      padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      color: const Color(0xFFD7384A),
                      onPressed: () {
                        if(selected != null) {
                          showToast(context);
                          if(!cStatus) {
                            showOverlayNotification((context) {
                              return Card(
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: SafeArea(
                                  child: ListTile(
                                    title: Text('Connection Error',
                                        style: TextStyle(fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)
                                    ),
                                    subtitle: Text(
                                      'Products will be added when connection is back.',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                    trailing: IconButton(
                                        icon: Icon(
                                          Icons.close, color: Colors.white,),
                                        onPressed: () {
                                          OverlaySupportEntry.of(context)
                                              .dismiss();
                                        }),
                                  ),
                                ),
                                color: Colors.blueGrey,);
                            }, duration: Duration(milliseconds: 4000));
                          }
                          else {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => ReserveTable(selected)));
                          }
                        }
                        else{
                          showOverlayNotification((context) {
                            return Card(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: SafeArea(
                                child: ListTile(
                                  title: Text('Select a table',
                                      style: TextStyle(fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)
                                  ),
                                  subtitle: Text(
                                    'Please select a table to reserve.',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  trailing: IconButton(
                                      icon: Icon(
                                        Icons.close, color: Colors.white,),
                                      onPressed: () {
                                        OverlaySupportEntry.of(context)
                                            .dismiss();
                                      }),
                                ),
                              ),
                              color: Color(0xFF2A8EBA),);
                          }, duration: Duration(milliseconds: 4000));
                        }
                      },
                      child: Text('Reserve table',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
  void showToast(BuildContext context) async {
    await checkConnection.initConnectivity();
    setState(() {
      cStatus = checkConnection.getConnectionStatus(context);
      print(cStatus.toString()+'hhhhhhhhhhhhh');
    });
  }

  getPositionedList(AsyncSnapshot<dynamic> snapshot){
    bool leftPlacement = false;
    return ListView(
      children:
      snapshot.data.documents.map<Widget>((DocumentSnapshot table ){
        if(leftPlacement){
          leftPlacement = false;
          return Container(
              margin: EdgeInsets.fromLTRB(100, 0, 0, 0),
              child: SingleTable(table['seats'], table['available'], table['table_number'], callback)
          );
        }
        else{
          leftPlacement = true;
          return Container(
              margin: EdgeInsets.fromLTRB(0, 0, 100, 0),
              child: SingleTable(table['seats'], table['available'], table['table_number'], callback)
          );
        }
      }).toList(),
    );

  }
}