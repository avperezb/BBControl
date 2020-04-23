import 'package:bbcontrol/Setup/Database/database_creator.dart';
import 'package:bbcontrol/Setup/Pages/Reservations/reservationsList.dart';
import 'package:bbcontrol/models/customer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Reservations extends StatefulWidget {
  const Reservations({Key key, @required this.customer}) : super(key: key);
  final Customer customer;
  _ReservationsState createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> {
  int numPeople = 0;
  int reservaId = 0;
  ReservationsList rl = new ReservationsList();

  callback(numPeople){
    setState(() {
      this.numPeople += numPeople;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservations'),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                color: Colors.brown[400],
                width: 300,
                height: 50,
                child: Center(
                  child: Text('Bar',
                    style: TextStyle(color: Colors.white,
                        fontSize: 20
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0 , 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Table(0, callback),
                Table(0, callback),
                Table(0, callback),
                Table(0, callback),
                Table(0, callback),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0 , 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Table(3, callback),
                Table(3, callback),
                Table(2, callback),
                Table(3, callback),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0 , 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Table(2, callback),
                Table(2, callback),
                Table(1, callback),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0 , 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Table(1, callback),
                Table(3, callback),
                Table(3, callback),
                Table(2, callback),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 20.0, 0.0 , 0.0),
              child: Text('Number of seats: $numPeople',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
              )),
          )
          ,
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
            child: RaisedButton(
              padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
              color: const Color(0xFFD7384A),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationsList2()));

              },
              child: Text('New reservation',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
            ),
          ),
        ],
      ),
    );
  }

  Container createR() {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
      color: const Color(0xFF996480),
      child: Column(
        children: <Widget>[
          Text('Table: 8',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),
          Text('Seats: $numPeople',
            style: TextStyle(
                fontSize: 17
            ),
          ),
          Text('Start date: ${(new DateFormat('yyyy-MM-dd hh:mm')).format(DateTime.now())})',
            style: TextStyle(
                fontSize: 17
            ),
          ),
          Text('End date: ${(new DateFormat('yyyy-MM-dd hh:mm')).format(DateTime.now().add(Duration(hours:2, minutes:0, seconds:0)))})',
            style: TextStyle(
                fontSize: 17
            ),
          ),
        ],
      ),
    );
  }
}

class ReservationsList2 extends StatelessWidget {
  ReservationDatabase db = new ReservationDatabase();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today reservations'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF6B00),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            color: const Color(0xFF996480),
            child: Column(
              children: <Widget>[
                Text('Table: 5',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text('Seats: 4',
                  style: TextStyle(
                      fontSize: 17
                  ),
                ),
                Text('Start hour: 4:00 pm',
                  style: TextStyle(
                      fontSize: 17
                  ),
                ),
                Text('End hour: 6:00 pm',
                  style: TextStyle(
                      fontSize: 17
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            color: const Color(0xFF996480),
            child: Column(
              children: <Widget>[
                Text('Table: 7',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text('Seats: 4',
                  style: TextStyle(
                      fontSize: 17
                  ),
                ),
                Text('Start hour: 6:00 pm',
                  style: TextStyle(
                      fontSize: 17
                  ),
                ),
                Text('End hour: 8:00 pm',
                  style: TextStyle(
                      fontSize: 17
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            color: const Color(0xFF996480),
            child: Column(
              children: <Widget>[
                Text('Table: 8',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text('Seats: 4',
                  style: TextStyle(
                      fontSize: 17
                  ),
                ),
                Text('Start hour: 8:00 pm',
                  style: TextStyle(
                      fontSize: 17
                  ),
                ),
                Text('End hour: 10:00 pm',
                  style: TextStyle(
                      fontSize: 17
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 150.0, 10.0, 0.0),
            child: RaisedButton(
              padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
              color: const Color(0xFFD7384A),
              onPressed:(){ },
              child: Text('Add new reservation',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
            ),
          ),
        ],
      ),
    );
  }

}

class Table extends StatefulWidget {
  int numPeople = 0;
  int iconRoute = 1;
  Function(int) callback;
  Table(int iconRoute, Function callback){
    this.iconRoute = iconRoute;
    this.numPeople = iconRoute + 1;
    this.callback = callback;
  }
  _TableState createState() => _TableState();
}

class _TableState extends State<Table> {
  final icons = [Icons.looks_one,
    Icons.looks_two,
    Icons.looks_3,
    Icons.looks_4];
  bool selected = false;
  bool previousState = false;
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icons[widget.iconRoute],
        color: selected ? const Color(0xFF69B3E7) : Colors.brown[600],
      ),
      onPressed: () {
        setState(() {
          previousState = selected;
          selected = !selected;
          if(previousState) {
            widget.callback(widget.numPeople * -1);
          }
          else{
            widget.callback(widget.numPeople);
          }
        });
      },
    );
  }
}
