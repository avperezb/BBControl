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

class EditReservation extends StatefulWidget {
  Reservation reservation;
  EditReservation({this.reservation});
  @override
  _EditReservationState createState() => _EditReservationState();
}

class _EditReservationState extends State<EditReservation> {
  DateTime _date;
  DateTime _startTime;
  TimeOfDay _startNoFormat;
  DateTime _endTime;
  int _numPeople;
  bool _neartv = false;
  bool _nearbar = false;
  bool _neararcade = false;

  void initState(){
    List<String> prefs = widget.reservation.preferences;
    if(prefs.contains('near arcade')) _neararcade = true;
    if(prefs.contains('near tv')) _neartv = true;
    if(prefs.contains('near bar')) _nearbar = true;
    super.initState();
  }
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
          title: Text('Edit reservation',),
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
              checkInternetConnection(context, widget.reservation);
            },
            child: Text('Confirm changes',
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
                          initialValue: widget.reservation.date,
                          onShowPicker: (context, currentValue) {
                            return showDatePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                initialDate: widget.reservation.date,
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
                        initialValue: widget.reservation.startTime,
                        onShowPicker: (context, currentValue) async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(widget.reservation.startTime),
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
                              > Duration(hours: 3) || (DateTime(input.year, input.month, input.day, _startNoFormat.hour, _startNoFormat.minute))
                              .difference(input) > Duration(hours:  3)){
                            return 'A reservation can\'t last more than 3 hours';
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
                        initialValue: widget.reservation.endTime,
                        onShowPicker: (context, currentValue) async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime:TimeOfDay.fromDateTime( widget.reservation.endTime),
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
                        initialValue: widget.reservation.numPeople.toString(),
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

  checkInternetConnection(context, Reservation reservation) async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _formKey.currentState.save();
        List<String> preferences = new List<String>();
        if(_neararcade)  preferences.add('near arcade');
        if(_nearbar) preferences.add(('near bar'));
        if(_neartv) preferences.add('near tv');
        reservation = Reservation(
            reservation.id, _date, _endTime, _startTime, _numPeople, preferences, reservation.userId);
        await _reservationsFirestoreClass.updateReservation(reservation);
        Navigator.pop(context);
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

  void showToast(BuildContext context) async {
    await checkConnection.initConnectivity();
    setState(() {
      cStatus = checkConnection.getConnectionStatus(context);
      print(cStatus.toString()+'hhhhhhhhhhhhh');
    });
  }
}
