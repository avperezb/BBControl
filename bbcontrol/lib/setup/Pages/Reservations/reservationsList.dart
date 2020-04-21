import 'package:bbcontrol/Setup/Database/database_creator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Extra/ColorLoader.dart';
import '../Extra/DotType.dart';
import 'reservationsAux.dart';

class ReservationsList extends StatelessWidget {
  ReservationDatabase db = new ReservationDatabase();

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection(
          "/Reservations")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('My reservations'),
              centerTitle: true,
              backgroundColor: const Color(0xFFFF6B00),
            ),
            body: ColorLoader5(
              dotOneColor: Colors.redAccent,
              dotTwoColor: Colors.blueAccent,
              dotThreeColor: Colors.green,
              dotType: DotType.circle,
              dotIcon: Icon(Icons.adjust),
              duration: Duration(seconds: 1),
            ),
          );
        }
        else {
          return Scaffold(
            appBar: AppBar(
              title: Text('My reservations'),
              centerTitle: true,
              backgroundColor: const Color(0xFFFF6B00),
            ),
            bottomSheet: Card(
              elevation: 6.0,
              child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    color: const Color(0xFFD7384A),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationView()),);
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
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.77,
              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: ListView(
                children: snapshot.data.documents.map<ReservationTile>((DocumentSnapshot reservation){
                  return ReservationTile(reservation['date'], reservation['start'], reservation['end'], reservation['table_number']);
                }).toList(),
              ),
            ),
          );
        }
      },
    );
  }
}

class ReservationTile extends StatelessWidget {
  DateTime _date;
  DateTime _startTime;
  DateTime _endTime;
  int _tableNumber;
  final formatDate = DateFormat("yMd");
  final formatHour = DateFormat("HH:mm a");
  ReservationTile(Timestamp date, Timestamp startTime, Timestamp endTime, int tableNumber){
    this._date = DateTime.parse(date.toDate().toString());
    this._startTime = DateTime.parse(startTime.toDate().toString());
    this._endTime = DateTime.parse(endTime.toDate().toString());
    this._tableNumber = tableNumber;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
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
                Text('Table $_tableNumber'),
                getReservationStatus(),
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Date: ${formatDate.format(_date)}'),
              Text('Starting hour: ${formatHour.format(_startTime)}'),
              Text('Ending hour: ${formatHour.format(_endTime)}'),
            ],
          ),
        ),
      ),
    );
  }

  getReservationStatus(){
    bool active = (_date.isAfter(DateTime.now())) ? true : false;
    if(active)
      return Text('Active',
        style: TextStyle(
            fontSize: 13,
            color: Colors.green[800]
        ),
      );
    else
      Text('Due',
        style: TextStyle(
            fontSize: 13,
            color: Colors.red[800]
        ),
      );
  }
}



