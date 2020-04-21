import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Reservations/reserveTable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReservationView extends StatefulWidget {
  @override
  _ReservationViewState createState() => _ReservationViewState();
}

class _ReservationViewState extends State<ReservationView> {
  int numSeats = 0;
  Table selected;
  callback(int seats, Table table){
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ReserveTable(selected)));
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

  getPositionedList(AsyncSnapshot<dynamic> snapshot){
    bool leftPlacement = false;
    return ListView(
      children:
        snapshot.data.documents.map<Widget>((DocumentSnapshot table ){
          if(leftPlacement){
            leftPlacement = false;
            return Container(
                margin: EdgeInsets.fromLTRB(100, 0, 0, 0),
                child: Table(table['seats'], table['available'], table['table_number'], callback)
            );
          }
          else{
            leftPlacement = true;
            return Container(
                margin: EdgeInsets.fromLTRB(0, 0, 100, 0),
                child: Table(table['seats'], table['available'], table['table_number'], callback)
            );
          }
        }).toList(),
    );

  }
}

class Table extends StatefulWidget {
  int seats;
  bool available;
  bool selected;
  int tableNumber;
  Function(int, Table) callback;
  Table(int seats, bool available, int tableNumber, Function callback){
    this.seats = seats;
    this.available = available;
    selected = false;
    this.callback = callback;
    this.tableNumber = tableNumber;
  }

  @override
  _TableState createState() => _TableState();
}

class _TableState extends State<Table> {
  @override
  void initState() {
    color = (widget.available) ? Colors.brown[600] : Colors.grey[600];
    super.initState();
  }
  var icons = {
    1 : Icons.looks_two,
    2 : Icons.looks_two,
    3 : Icons.looks_3,
    4 : Icons.looks_4
  };
  var color;
  bool selected = false;
  bool previousState = false;

  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          icons[widget.seats],
          color: color,
          size:40,
        ),
        onPressed: () {
          setState(() {
            previousState = selected;
            selected = !selected;
            //     color = (selected) ? const Color(0xFF69B3E7) : Colors.brown[600];
            widget.callback(widget.seats, widget);
          });
        });
  }
}


