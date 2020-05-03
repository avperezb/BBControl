import 'dart:io';

import 'package:bbcontrol/setup/Pages/Reservations/reservation.dart';
import 'package:bbcontrol/models/reservation.dart' as res;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';

class ReservationsList extends StatelessWidget {
  String userId;
  ReservationsList(String userId){
    this.userId = userId;
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection(
          "/Reservations").where("user_Id", isEqualTo: userId).orderBy("date", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.documents.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text('My reservations'),
              centerTitle: true,
              backgroundColor: const Color(0xFFB75ba4),
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
                        child: Text('It looks like you don\'t have any reservations at the moment',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: FlatButton(
                          color: Colors.transparent,
                          child: Text('ADD A RESERVATION',
                            style: TextStyle(
                              color: const Color(0xFFB75ba4),
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: (){
                            checkInternetConnection(context);
                          },
                        ),
                      )
                    ],
                  )
              ),
            ),
          );
        }
        else {
          return Scaffold(
            appBar: AppBar(
                title: Text('My reservations'),
                centerTitle: true,
                backgroundColor: const Color(0xFFB75ba4)
            ),
            bottomSheet: Card(
              elevation: 6.0,
              child: Container(
                height: 60,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    color: const Color(0xFFB75ba4),
                    onPressed: () {
                      checkInternetConnection(context);
                    },
                    child: Text('Add a reservation',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - 90,
              margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: ListView(
                children:
                snapshot.data.documents.map<ReservationTile>((DocumentSnapshot reservation){
                  List<String> prefs = new List<String>();
                  for(String str in reservation['preferences']){
                    prefs.add(str.toString());
                  }
                  res.Reservation reserva = new res.Reservation(
                      reservation['id'],
                      DateTime.parse(reservation['date'].toDate().toString()),
                      DateTime.parse(reservation['end'].toDate().toString()),
                      DateTime.parse(reservation['start'].toDate().toString()),
                      reservation['num_people'],
                      prefs,
                      reservation['user_Id']);
                  return new ReservationTile(reserva);
                }).toList(),
              ),
            ),
          );
        }
      },
    );
  }
  checkInternetConnection(context) async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MakeReservation(userId)),);
      }
    } on SocketException catch (_) {
      return connectionErrorToast();
    }
  }

  connectionErrorToast(){
    return showOverlayNotification((context) {
      return Card(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: SafeArea(
          child: ListTile(
            title: Text('Connection error',
                style: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)
            ),
            subtitle: Text(
              'Check your connection and try again.',
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
        color: Colors.blueGrey,)
      ;
    }, duration: Duration(milliseconds: 4000));
  }
}

class ReservationTile extends StatelessWidget {
  String _id;
  DateTime _date;
  DateTime _startTime;
  DateTime _endTime;
  int _numPeople;
  List _preferences;
  String _userId;
  res.Reservation _reservation;
  final formatDate = DateFormat("yMd");
  final formatHour = DateFormat("HH:mm a");

  ReservationTile(res.Reservation reservation){
    this._id = reservation.id;
    this._date = reservation.date;
    this._startTime = reservation.startTime;
    this._endTime = reservation.endTime;
    this._numPeople = reservation.numPeople;
    this._preferences = reservation.preferences;
    this._userId = reservation.userId;
    this._reservation = reservation;
  }
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(_id),
      // ignore: missing_return
      confirmDismiss: (direction) {
        if(direction == DismissDirection.endToStart){
          showDialog(context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: const Text('Are you sure?'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('You won\'t be able to get this reservation back!')
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text('CANCEL'),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text('DELETE'),
                      onPressed: () async{
                        await Firestore.instance.collection("/Reservations").document(_id).delete();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        }
        else{
          if(_date.isAfter(DateTime.now()))
            Navigator.of(context).pushNamed('/EditReservation', arguments: _reservation);
          else
          showDialog(context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: const Text('Due reservation'),
                  content: Text('This reservation is no longer available for changes.'),
                  actions: <Widget>[
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text('DISMISS'),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        }
      },
      secondaryBackground: Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          padding: EdgeInsets.only(right: 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.grey[500],
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.delete_outline,
                color: Colors.white,
                size: 30,
              ),
            ],
          )
      ),
      background: Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          padding: EdgeInsets.only(left: 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.blue,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.edit,
                color: Colors.white,
                size: 30,
              ),
            ],
          )
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
        child: Container(
          child: ListTile(
            title: Container(
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  getReservationStatus(),
                  Container(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Icon(Icons.people_outline)
                        ),
                        Text('$_numPeople'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Date: ${formatDate.format(_date)}'),
                    Text('Start time: ${formatHour.format(_startTime)}'),
                    Text('End time: ${formatHour.format(_endTime)}'),
                  ],
                ),
                getPreferences(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getPreferences(){
    if(_preferences.isNotEmpty){
      List<IconData> icons = [];
      if(_preferences.contains('near arcade')) icons.add(Icons.videogame_asset);
      if(_preferences.contains('near tv')) icons.add(Icons.tv);
      if(_preferences.contains('near bar')) icons.add(Icons.local_bar);
      return Row(
        children: <Widget>[
          for(int i = 0; i < icons.length; i++)
            Container(
                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child:(
                    Icon(icons[i],
                      color: Colors.grey[600],)
                )
            )

        ],
      );
    }
    else return Container();
  }

  getReservationStatus(){
    bool active = (_date.isAfter(DateTime.now())) ? true : false;
    if(active)
      return Text('Active reservation',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.green[800]
        ),
      );
    else
      return Text('Due reservation',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.red[800]
        ),
      );
  }


}



