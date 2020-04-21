import 'package:bbcontrol/models/reservation.dart';
import 'package:bbcontrol/setup/Pages/Reservations/table.dart';
import 'package:bbcontrol/setup/Pages/Services/reservations_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';

import '../Services/connectivity.dart';
import 'reservationsList.dart';

class ReserveTable extends StatefulWidget {
  SingleTable table;
  ReserveTable(SingleTable table){
    this.table = table;
  }
  @override
  _ReserveTableState createState() => _ReserveTableState();
}

class _ReserveTableState extends State<ReserveTable> {
  DateTime _date;
  DateTime _startTime;
  TimeOfDay _startNoFormat;
  DateTime _endTime;
  CheckConnectivityState checkConnection = CheckConnectivityState();
  bool cStatus = true;
  ReservationsFirestoreClass _reservationsFirestoreClass = ReservationsFirestoreClass();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final formatDate = DateFormat("yMd");
  final formatHour = DateFormat("HH:mm a");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Reserve table',),
          centerTitle: true,
          backgroundColor: const Color(0xFFFF6B00),
        ),
        bottomSheet: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: RaisedButton(
            padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
            ),
            color: const Color(0xFFD7384A),
            onPressed: () async{
              if (_formKey.currentState.validate()) {
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
                      color: Colors.blueGrey,);
                  }, duration: Duration(milliseconds: 4000));
                }
                else {
                  _formKey.currentState.save();
                  Reservation reservation = new Reservation(
                      _date, _endTime, _startTime, widget.table.tableNumber);
                  await _reservationsFirestoreClass.addReservation(reservation);
                  Navigator.pop(context);
                }
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
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10, 20, 0, 20),
                child: Text('Table ${widget.table.tableNumber}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: DateTimeField(
                    validator: (input) {
                      if (input == null) {
                        return 'Please enter a date';
                      }
                      else{
                        if(input.isBefore(new DateTime.now())){
                          return  'The minimum date is ${formatDate.format(DateTime.now().add(Duration(days: 1)))}';
                        }
                      }
                    },
                    format: formatDate,
                    decoration:const InputDecoration(
                        icon: const Icon(Icons.calendar_today,
                            color: const Color(0xFFD8AE2D)
                        ),
                        labelText: 'Reservation date'
                    ),
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now().add(Duration(days: 1)),
                          lastDate: DateTime(2100));
                    },
                    onSaved: (input) => _date = input
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: DateTimeField(
                  validator: (input) {
                    if (input == null) {
                      return 'Please select a time';
                    }
                    else if(input.hour < 15){
                      return 'The minimum starting hour is 03:00 PM';
                    }
                  },
                  format: DateFormat("hh:mm a"),
                  decoration:const InputDecoration(
                      icon: const Icon(Icons.watch_later,
                          color: const Color(0xFFD8AE2D)
                      ),
                      labelText: 'Starting time'
                  ),
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime(2020, 4, 22, 15)),
                    );
                    _startNoFormat = time;
                    return DateTimeField.convert(time);
                  },
                  onSaved: (input) => {_startTime = input},
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: DateTimeField(
                  validator: (input) {
                    if (input == null) {
                      return 'Please select a time';
                    }
                    else if(input.difference((DateTime(input.year, input.month, input.day, _startNoFormat.hour, _startNoFormat.minute)))
                        > Duration(hours: 2)){
                      return 'A reservation can\'t last more than 2 hours';
                    }
                  },
                  format: DateFormat("hh:mm a"),
                  decoration:const InputDecoration(
                      icon: const Icon(Icons.access_time,
                          color: const Color(0xFFD8AE2D)
                      ),
                      labelText: 'Ending time'
                  ),
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _startNoFormat,
                    );
                    print(time.hour);
                    return DateTimeField.convert(time);
                  },
                  onSaved: (input) => _endTime = input,
                ),
              ),
            ],
          ),
        )
    );
  }

  void showToast(BuildContext context) async {
    await checkConnection.initConnectivity();
    setState(() {
      cStatus = checkConnection.getConnectionStatus(context);
      print(cStatus.toString()+'hhhhhhhhhhhhh');
    });
  }
}
