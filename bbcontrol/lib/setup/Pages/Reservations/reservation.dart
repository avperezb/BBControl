import 'dart:io';

import 'package:bbcontrol/models/reservation.dart';
import 'package:bbcontrol/setup/Pages/Services/reservations_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:uuid/uuid.dart';

import '../Services/connectivity.dart';

class MakeReservation extends StatefulWidget {
  String userEmail;
  MakeReservation(String userEmail){
    this.userEmail = userEmail;
  }
  @override
  _MakeReservationState createState() => _MakeReservationState();
}

class _MakeReservationState extends State<MakeReservation> {
  DateTime _date;
  DateTime _startTime;
  TimeOfDay _startNoFormat;
  DateTime _endTime;
  int _numPeople;
  bool _neartv = false;
  bool _nearbar = false;
  bool _neararcade = false;
  CheckConnectivityState checkConnection = CheckConnectivityState();
  bool cStatus = true;
  ReservationsFirestoreClass _reservationsFirestoreClass = ReservationsFirestoreClass();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final formatDate = DateFormat("yMd");
  final formatHour = DateFormat("HH:mm a");
  var uuid = new Uuid();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Make a reservation',),
          centerTitle: true,
          backgroundColor: const Color(0xFFB75ba4),
        ),
        bottomSheet:  Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
            ),
            color: const Color(0xFFB75ba4),
            onPressed: () async{
              checkInternetConnection(context);
            },
            child: Text('Confirm reservation',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Form(
              key: _formKey,
              child: SizedBox(
                height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - 90,
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 20, 0, 10),
                      child: Text('Reservation details',
                        style: TextStyle(
                          fontSize: 17,
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
                            else if (input.isBefore(new DateTime.now())){
                              return  'The minimum date is ${formatDate.format(DateTime.now().add(Duration(days: 1)))}';
                            }
                            else return null;
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
                                firstDate: DateTime(2000),
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
                          else return null;
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
                              > Duration(hours: 3)){
                            return 'A reservation can\'t last more than 3 hours';
                          }
                          else if(input.difference((DateTime(input.year, input.month, input.day, _startNoFormat.hour, _startNoFormat.minute)))
                              < Duration(hours: 0)){
                            return 'Ending time must be after starting time';
                          }
                          else if(input.difference((DateTime(input.year, input.month, input.day, _startNoFormat.hour, _startNoFormat.minute)))
                              < Duration(hours: 1)){
                            return 'A reservation can\'t last less than 1 hour';
                          }
                          else return null;
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
                    Container(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(2),
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Please add a number';
                          }
                          else if( num.parse(input) < 2 || num.parse(input) > 10){
                            return 'The number must be between 2 and 10 people';
                          }
                          else return null;
                        },
                        decoration:const InputDecoration(
                            icon: const Icon(Icons.group,
                                color: const Color(0xFFD8AE2D)
                            ),
                            labelText: 'Number of people'
                        ),
                        onSaved: (input) => _numPeople = num.parse(input),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 30, 0, 30),
                      child: Text('Preferences',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: 80,
                            height: 80,
                            child: RaisedButton(
                              color: _neararcade ? Color(0xFF69B3E7) : Colors.grey[300],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(Icons.videogame_asset,
                                      color: _neararcade ? Color(0xFFd2e8f7) : Colors.grey[700]),
                                  Text('Near arcade',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _neararcade ? Color(0xFFd2e8f7) : Colors.grey[700],
                                    ),
                                  )
                                ],
                              ),
                              onPressed: (){
                                setState(() {
                                  _neararcade = !_neararcade;
                                });
                              },
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 80,
                            child: RaisedButton(
                                color: _neartv ? Color(0xFFD8AE2D) : Colors.grey[300],
                                onPressed: (){
                                  setState(() {
                                    _neartv = !_neartv;
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Icon(Icons.tv,
                                        color: _neartv ? Color(0xFFf7eed5) : Colors.grey[700]),
                                    Text('Near tv',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: _neartv ? Color(0xFFf7eed5) : Colors.grey[700],
                                      ),)
                                  ],
                                )
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 80,
                            child: RaisedButton(
                                color: _nearbar ? Color(0xFFD7384A) : Colors.grey[300],
                                onPressed: (){
                                  setState(() {
                                    _nearbar = !_nearbar;
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Icon(Icons.local_bar,
                                        color: _nearbar ? Color(0xFFf3c3c8) : Colors.grey[700]),
                                    Text('Near bar',
                                      style: TextStyle(
                                        color: _nearbar ? Color(0xFFf3c3c8) : Colors.grey[700],
                                      ),
                                      textAlign: TextAlign.center,)
                                  ],
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }

  checkInternetConnection(context) async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          List<String> preferences = new List<String>();
          if (_neararcade) preferences.add('near arcade');
          if (_nearbar) preferences.add(('near bar'));
          if (_neartv) preferences.add('near tv');
          Reservation reservation = new Reservation(
              uuid.v1(),
              _date,
              _endTime,
              _startTime,
              _numPeople,
              preferences,
              widget.userEmail);
          await _reservationsFirestoreClass.addReservation(reservation);
          Navigator.pop(context);
        }
      }
    } on SocketException catch (_) {
      return connectionErrorToast();
    }
  }

  connectionErrorToast(){
    return showSimpleNotification(
      Text("Oops! no internet connection",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
        ),),
      subtitle: Text('Please check your connection and try again.',
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
      background: Colors.blueGrey,
      autoDismiss: false,
      slideDismiss: true,
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
