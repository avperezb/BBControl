import 'package:bbcontrol/Setup/Database/database_creator.dart';
import 'package:bbcontrol/setup/Pages/Reservations/reservation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationsList extends StatelessWidget {
  String userId;
  ReservationsList(String userId){
    this.userId = userId;
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection(
          "/Reservations").where("user_Id", isEqualTo: userId).orderBy("date")
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MakeReservation(userId)),);
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MakeReservation(userId)),);
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
                  return new ReservationTile(reservation['date'], reservation['start'], reservation['end'], reservation['preferences'] ,reservation['num_people']);
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
  int _numPeople;
  List _preferences;
  final formatDate = DateFormat("yMd");
  final formatHour = DateFormat("HH:mm a");
  ReservationTile(Timestamp date, Timestamp start, Timestamp end, List preferences, int numPeople){
    this._date = DateTime.parse(date.toDate().toString());
    this._startTime = DateTime.parse(start.toDate().toString());
    this._endTime = DateTime.parse(end.toDate().toString());
    this._numPeople = numPeople;
    this._preferences = preferences;
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
                getReservationStatus(),
                Container(
                  width: 55,
                  child: Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Icon(Icons.people_outline)
                      ),
                      Text('$_numPeople')
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



